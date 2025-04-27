const express = require('express');

const app = express();
const PORT = 3001;
const NAME = 'master1';

app.get('/', (req, res) => {
  res.send(`${NAME}`)
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Listening on port ${PORT}`);
});
