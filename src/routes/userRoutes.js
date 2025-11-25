import express from "express";
import {
  getAllUsers,
  getUserById,
  getUserCourses,
} from "../controllers/userController.js";
import { isAuthenticated, isInstructor } from "../middleware/auth.js";

const router = express.Router();

router.get("/", isInstructor, getAllUsers);
router.get("/:id", isAuthenticated, getUserById);
router.get("/:id/courses", isAuthenticated, getUserCourses);

export default router;
