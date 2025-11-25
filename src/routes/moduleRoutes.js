import express from "express";
import {
  getModulesForCourse,
  addModuleToCourse,
  updateModule,
  deleteModule,
} from "../controllers/moduleController.js";
import { isInstructor } from "../middleware/auth.js";

const router = express.Router();


router.post("/", isInstructor, addModuleToCourse);
router.put("/:moduleId", isInstructor, updateModule);
router.delete("/:moduleId", isInstructor, deleteModule);

export default router;
