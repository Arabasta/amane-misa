const express = require('express');

const app = express();
const PORT = 3002;
const NAME = 'master2';

app.get('/', (req, res) => {
  res.send(`${NAME}`)
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Listening on port ${PORT}`);
});
