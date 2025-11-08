import express from "express";
import {
  getAllCourses,
  createCourse,
  updateCourse,
  deleteCourse,
  enrollUser,
  unenrollUser,
  getCourseStudents,
} from "../controllers/courseController.js";
import moduleRoutes from "./moduleRoutes.js";

const router = express.Router();

router.get("/", getAllCourses);
router.get("/:id/students", getCourseStudents);
router.post("/", createCourse);
router.put("/:id", updateCourse);
router.delete("/:id", deleteCourse);

router.use("/:courseId/modules", moduleRoutes);

// Enrollment endpoints
router.post("/:courseId/enroll", enrollUser);
router.delete("/:courseId/enroll", unenrollUser);

export default router;
