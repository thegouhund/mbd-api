import express from "express";
import {
  getUserCourses
} from "../controllers/userController.js";
import { isAuthenticated, isStudent } from "../middleware/auth.js";

const router = express.Router();

router.get("/courses", [isAuthenticated, isStudent], getUserCourses);

export default router;
