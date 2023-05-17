/**
 * canon_copy_from_read_buf	-	copy read data in canonical mode
 * @tty: terminal device
 * @kbp: data
 * @nr: size of data
 *
 * Helper function for n_tty_read(). It is only called when %ICANON is on; it
 * copies one line of input up to and including the line-delimiting character
 * into the result buffer.
 *
 * Note: When termios is changed from non-canonical to canonical mode and the
 * read buffer contains data, n_tty_set_termios() simulates an EOF push (as if
 * C-d were input) _without_ the %DISABLED_CHAR in the buffer. This causes data
 * already processed as input to be immediately available as input although a
 * newline has not been received.
 *
 * Locking:
 *  * called under the %atomic_read_lock mutex
 *  * n_tty_read()/consumer path:
 *	caller holds non-exclusive %termios_rwsem;
 *	read_tail published
 */
static bool canon_copy_from_read_buf(struct tty_struct *tty,
				     unsigned char **kbp,
				     size_t *nr)
{
	struct n_tty_data *ldata = tty->disc_data;
	size_t n, size, more, c;
	size_t eol;
	size_t tail, canon_head;
	int found = 0;

	/* N.B. avoid overrun if nr == 0 */
	if (!*nr)
		return false;

	canon_head = smp_load_acquire(&ldata->canon_head);
	n = min(*nr, canon_head - ldata->read_tail);

	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);

	n_tty_trace("%s: nr:%zu tail:%zu n:%zu size:%zu\n",
		    __func__, *nr, tail, n, size);

	eol = find_next_bit(ldata->read_flags, size, tail);
	more = n - (size - tail);
	if (eol == N_TTY_BUF_SIZE && more) {
		/* scan wrapped without finding set bit */
		eol = find_first_bit(ldata->read_flags, more);
		found = eol != more;
	} else
		found = eol != size;

	n = eol - tail;
	if (n > N_TTY_BUF_SIZE)
		n += N_TTY_BUF_SIZE;
	c = n + found;

	if (!found || read_buf(ldata, eol) != __DISABLED_CHAR)
		n = c;

	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu tail:%zu more:%zu\n",
		    __func__, eol, found, n, c, tail, more);

	tty_copy(tty, *kbp, tail, n);
	*kbp += n;
	*nr -= n;

	if (found)
		clear_bit(eol, ldata->read_flags);
	smp_store_release(&ldata->read_tail, ldata->read_tail + c);

	if (found) {
		if (!ldata->push)
			ldata->line_start = ldata->read_tail;
		else
			ldata->push = 0;
		tty_audit_push();
		return false;
	}

	/* No EOL found - do a continuation retry if there is more data */
	return ldata->read_tail != canon_head;
}
