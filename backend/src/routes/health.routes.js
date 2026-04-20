import { Router } from "express";

import { sendSuccess } from "../utils/apiResponse.js";

const healthRouter = Router();

healthRouter.get("/", (_req, res) => {
  return sendSuccess(res, {
    service: "sanad-backend",
    status: "ok",
    timestamp: new Date().toISOString(),
  });
});

export { healthRouter };
