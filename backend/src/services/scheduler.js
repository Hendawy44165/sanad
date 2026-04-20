import cron from "node-cron";

import { env } from "../config/env.js";

async function runLinkedInIngestionStub() {
  console.log("[scheduler] LinkedIn ingestion run started");
  console.log(
    "[scheduler] Stub run complete. Implement scraper + Gemini filter next.",
  );
}

export function startSchedulers() {
  if (!env.ENABLE_INGESTION_SCHEDULER) {
    console.log("[scheduler] disabled");
    return;
  }

  cron.schedule(env.INGESTION_CRON, async () => {
    try {
      await runLinkedInIngestionStub();
    } catch (error) {
      console.error("[scheduler] ingestion failed", error);
    }
  });

  console.log(`[scheduler] enabled with cron ${env.INGESTION_CRON}`);
}
