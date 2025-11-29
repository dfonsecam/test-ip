import bparser from "body-parser";
import expcors from "cors";
import express from "express";
import shelljs from "shelljs";

const app = express();
app.use(expcors({ origin: true }));
app.use(bparser.text({ type: "*/*" }));

app.get("/", (req, res) => {
  fetch("https://api.ipify.org?format=json")
    .then(async (result) => {
      const response = await result.json();
      const hostname = req.hostname;
      res.send({ hostname, response });
    })
    .catch((error) => res.send(error));
});

app.post("/exec", (req, res) => {
  const command = req.body.replace("--format-to-json", "");
  console.log("Executing:", command);
  const formatJson = req.body.includes("--format-to-json");

  shelljs.exec(
    command,
    {
      timeout: 10 * 1000,
    },
    (code, stdout, stderr) => {
      console.log(`Command response code: ${code}.`);
      if (code !== 0) {
        return res.status(500).send({
          code,
          error: stderr || "Unknown error",
        });
      }
      return res.send({
        code,
        output: formatJson ? JSON.parse(stdout) : stdout,
      });
    },
  );
});

app.listen(8080, () => {
  console.log(`listening`);
});
