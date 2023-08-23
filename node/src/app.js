const express = require('express');
const mysql = require('mysql');
const dotenv = require('dotenv');

dotenv.config();

const routes = require('./routes/index');

const app = express();

// Database connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

db.connect((err) => {
  if(err) throw err;
  console.log('Connected to the database.');
});

// Store db connection in app locals to use in routes
app.locals.db = db;

app.use('/', routes);

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

module.exports = app;
