import express from "express";
import {
  addModuleToCourse,
  deleteModule,
  updateModule
} from "../controllers/moduleController.js";
import { isAuthenticated, isInstructor } from "../middleware/auth.js";

const router = express.Router();


router.post("/", [isAuthenticated, isInstructor], addModuleToCourse);
router.put("/:moduleId", [isAuthenticated, isInstructor], updateModule);
router.delete("/:moduleId", [isAuthenticated, isInstructor], deleteModule);

export default router;
