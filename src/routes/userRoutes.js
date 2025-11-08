import express from "express";
import {
  getAllUsers,
  getUserById,
  getUserCourses,
  register,
  login,
} from "../controllers/userController.js";

const router = express.Router();

router.get("/", getAllUsers);
router.get("/:id", getUserById);
router.get("/:id/courses", getUserCourses);
router.post("/register", register);
router.post("/login", login);

export default router;
