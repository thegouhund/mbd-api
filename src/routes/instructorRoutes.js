import express from "express";
import { getCoursesByCreatorId } from "../controllers/courseController.js";
import { isAuthenticated, isInstructor } from "../middleware/auth.js";

const router = express.Router();

router.get("/courses", [isAuthenticated, isInstructor], getCoursesByCreatorId);

export default router;
