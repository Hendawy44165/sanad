import { app } from "./app.js";
import { connectDatabase } from "./config/db.js";
import { env } from "./config/env.js";
import { startSchedulers } from "./services/scheduler.js";

async function bootstrap() {
  await connectDatabase(env.MONGODB_URI);
  startSchedulers();

  app.listen(env.PORT, () => {
    console.log(`Sanad backend listening on port ${env.PORT}`);
  });
}

bootstrap().catch((error) => {
  console.error("Fatal startup error:", error);
  process.exit(1);
});
