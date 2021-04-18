// serve the webpage built in ./docs
const express = require('express');
const app = express();

const BUILDDIR = 'docs';
const PORT = 5000;

// static hosting of the docs folder
app.use(express.static(BUILDDIR));

app.get('**', (req, res) => {
    res.sendFile(`${__dirname}/docs/404.html`);
})

// listen on port 5000
app.listen(PORT, () => console.log(`Listening on port ${PORT}...`));
