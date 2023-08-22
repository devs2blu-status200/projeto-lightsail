const express = require('express');
const routes = require('./routes/index');

const app = express();

app.use('/', routes);

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

module.exports = app;
