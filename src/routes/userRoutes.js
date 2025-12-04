import express from "express";
import {
  getAllUsers,
  getUserById,
  getUserCourses,
} from "../controllers/userController.js";
import { isAuthenticated, isStudent } from "../middleware/auth.js";

const router = express.Router();

router.get("/", isAuthenticated, getAllUsers);
router.get("/:id", isAuthenticated, getUserById);
router.get("/courses", [isAuthenticated, isStudent], getUserCourses);

export default router;
