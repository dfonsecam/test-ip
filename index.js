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

app.post('/exec', async (req, res) =>
  shell.exec(
    req.body,
    {
      timeout: 10 * 1000,
    },
    (code, stdout, stderr) => {
      console.log(`Command response code: ${code}.`);
      if (stdout) {
        res.send(`Output: ${stdout}`);
      } else if (stderr) {
        res.send(`Error: ${stderr}`);
      }
    },
  ),
);

app.listen(8080, () => {
  console.log(`listening`);
});
