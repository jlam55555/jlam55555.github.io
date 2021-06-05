(define church-zero
  ;; Church numeral implementation of 0
  (lambda (f)
    (lambda (x) x)))

(define (church-1+ n)
  ;; Church numeral implementation of 1+
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))

;;; notes:
;;; - zero is a procedure that always returns the identity
;;;   function, so it is the same as writing:
(define (church-zero f) identity)
;;;   where identity is defined in ../utils/utils. This makes
;;;   sense as the zero of some function group.
;;;   Thus we can imagine each "number" to be represented as
;;;   a function.
;;; - From the previous observation, we can expect add-1 to
;;;   be some map on functions F -> F.

;;; The reprentation of 1 in this function space is (add-1 zero),
;;; which simplifies to:
;;; (assuming that f is a unary procedure)

;;; From the above, we can clearly see that the representation
;;; of 2 is:
(define church-two
  (lambda (f)
    (lambda (x)
      (f (f x)))))
;;; simplifying:
(define (church-two f)
  (lambda (x)
    (f (f x))))
;;; in terms of our friends from ../1.3/exercises.scm:
(define church-two double)

;;; the generalized version of this is that the number n is represented
;;; by the function that autocomposes a function n times. Thus, to sum
;;; of two "numbers" a+b is the function that autocomposes a function n+m times
(define (church-add a b)
  ;; add two Church numerals
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x)))))

;;; with this understanding, the definition of multiplication is
;;; also pretty clear:
(define (church-multiply a b)
  ;; multiply two Church numerals
  (lambda (f)
    (lambda (x)
      ((a (b f)) x))))

;;; now, it's intuitive that the church numerals are isomorphic to the
;;; nonnegative integers by the autocompose mapping (from 1.3 exercises),
;;; so the conversion to/from Church numerals is well-defined
(define (fx->church n)
  ;; generate an arbitrary church numeral from a regular nonnegative number
  (lambda (f)
    (n-fold-compose f n)))

(define (church->fx n)
  ;; converts a church numeral into a number equivalent
  ((n 1+) 0))
