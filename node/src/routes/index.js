const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  const db = req.app.locals.db;
  
  db.query('CREATE TABLE IF NOT EXISTS visits (count INT)', (err) => {
    if (err) throw err;

    db.query('INSERT INTO visits (count) VALUES (1)', (err) => {
      if (err) throw err;

      db.query('SELECT COUNT(*) as visitCount FROM visits', (err, results) => {
        if (err) throw err;

        res.send(`Olá, mundo! Essa página foi visitada ${results[0].visitCount} vezes.`);
      });
    });
  });
});

module.exports = router;
