import express from "express";
import {
  createCourse,
  deleteCourse,
  enrollUser,
  getAllCourses,
  getCourseStudents,
  unenrollUser,
  updateCourse,
  getCourseById
} from "../controllers/courseController.js";
import { getModulesForCourse } from "../controllers/moduleController.js";
import { isAuthenticated, isInstructor, isStudent } from "../middleware/auth.js";

const router = express.Router();

router.get("/",isAuthenticated, getAllCourses);
router.get("/:id", [isAuthenticated], getCourseById);
router.get("/:id/students", [isAuthenticated, isInstructor], getCourseStudents);

router.post("/", [isAuthenticated, isInstructor], createCourse);
router.put("/:id", [isAuthenticated, isInstructor], updateCourse);
router.delete("/:id", [isAuthenticated, isInstructor], deleteCourse);
router.get("/:courseId/modules", isAuthenticated, getModulesForCourse);

router.post("/:courseId/enroll", [isAuthenticated, isStudent], enrollUser);
router.delete("/:courseId/enroll", [isAuthenticated, isStudent], unenrollUser);

export default router;
