import express from "express";
import {
  createCourse,
  deleteCourse,
  enrollUser,
  getAllCourses,
  getCourseStudents,
  unenrollUser,
  updateCourse,
} from "../controllers/courseController.js";
import { getModulesForCourse } from "../controllers/moduleController.js";
import { isAuthenticated, isInstructor, isStudent } from "../middleware/auth.js";
import moduleRoutes from "./moduleRoutes.js";

const router = express.Router();

router.get("/",isAuthenticated, getAllCourses);
router.get("/:id/students", isAuthenticated, getCourseStudents);

router.post("/", isInstructor, createCourse);
router.put("/:id", isInstructor, updateCourse);
router.delete("/:id", isInstructor, deleteCourse);
router.get("/:courseId/modules", getModulesForCourse);

router.post("/:courseId/enroll", isStudent, enrollUser);
router.delete("/:courseId/enroll", isStudent, unenrollUser);

export default router;
