import { Router } from "express";

import { requestIdMiddleware } from "../middleware/requestId.js";
import { healthRouter } from "./health.routes.js";
import { profileRouter } from "./profile.routes.js";
import { jobsRouter } from "./jobs.routes.js";
import { adminJobsRouter } from "./admin.jobs.routes.js";
import { productsRouter } from "./products.routes.js";
import { adminProductsRouter } from "./admin.products.routes.js";
import { cvRouter } from "./cv.routes.js";
import { doctorsRouter } from "./doctors.routes.js";
import { adminDoctorsRouter } from "./admin.doctors.routes.js";
import { doctorBookingsRouter } from "./doctor-bookings.routes.js";
import { adminUploadsRouter } from "./admin.uploads.routes.js";
import { userUploadsRouter } from "./user.uploads.routes.js";
import { adminAuthRouter } from "./admin-auth.routes.js";

const apiRouter = Router();

apiRouter.use(requestIdMiddleware);
apiRouter.use("/health", healthRouter);
apiRouter.use("/auth", profileRouter);
apiRouter.use("/profile", profileRouter);
apiRouter.use("/jobs", jobsRouter);
apiRouter.use("/admin/jobs", adminJobsRouter);
apiRouter.use("/store/products", productsRouter);
apiRouter.use("/admin/store/products", adminProductsRouter);
apiRouter.use("/cv", cvRouter);
apiRouter.use("/doctors", doctorsRouter);
apiRouter.use("/admin/doctors", adminDoctorsRouter);
apiRouter.use("/doctor-bookings", doctorBookingsRouter);
apiRouter.use("/admin/uploads", adminUploadsRouter);
apiRouter.use("/uploads", userUploadsRouter);
apiRouter.use("/admin-auth", adminAuthRouter);

export { apiRouter };
