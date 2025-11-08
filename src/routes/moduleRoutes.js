import express from "express";
import {
  getModulesForCourse,
  addModuleToCourse,
  updateModule,
  deleteModule,
} from "../controllers/moduleController.js";

const router = express.Router({ mergeParams: true });

router.get("/", getModulesForCourse);
router.post("/", addModuleToCourse);
router.put("/:moduleId", updateModule);
router.delete("/:moduleId", deleteModule);

export default router;
