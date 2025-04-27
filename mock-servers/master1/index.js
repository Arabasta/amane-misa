const express = require('express');

const app = express();
const PORT = 3001;
const NAME = 'master1';

// todo: have registration endpoint for nodes

// todo: have endpoint to get all nodes

// todo: have endpoint for execution of a command on a node

app.get('/', (req, res) => {
  res.send(`${NAME}`)
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Listening on port ${PORT}`);
});
