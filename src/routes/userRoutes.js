import express from "express";
import {
  getAllUsers,
  getUserById,
  register,
  login,
} from "../controllers/userController.js";

const router = express.Router();

router.get("/", getAllUsers);
router.get("/:id", getUserById);
router.post("/register", register);
router.post("/login", login);

export default router;
