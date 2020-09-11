const axios = require('axios').default;
const express = require('express');

const app = express();

app.get('/', (req, res) => {
    axios
        .get('https://api.ipify.org?format=json')
        .then((result) => {
            const hostname = req.hostname;
            const response = { ...result.data };
            res.send({ hostname, response });
        })
        .catch((error) => res.send(error));
});

app.listen(8080, () => {
    console.log(`listening`);
});
