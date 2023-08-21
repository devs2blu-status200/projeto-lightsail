import express from 'express';
import routes from './routes/index';

const app = express();

app.use('/', routes);

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

export default app;
