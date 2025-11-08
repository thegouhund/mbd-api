import pool from "../../config/db.js";

export const getAllCourses = async (request, response) => {
  try {
    const [result] = await pool.query("CALL GetAllCourses()");
    return response.status(200).json({
      message: "Berhasil mengambil daftar course",
      data: result[0],
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const createCourse = async (request, response) => {
  const { title, description, creator_id } = request.body;

  if (!title || !description || !creator_id) {
    return response
      .status(400)
      .json({ message: "Title, description, and creator_id are required" });
  }

  try {
    await pool.query("CALL CreateCourse(?, ?, ?)", [
      title,
      description,
      creator_id,
    ]);
    return response.status(201).json({
      message: "Course berhasil dibuat",
      data: {
        title,
        description,
        creator_id,
      },
    });
  } catch (error) {
    console.log(error);
    if (error.sqlMessage) {
      return response.status(403).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const updateCourse = async (request, response) => {
  const courseId = parseInt(request.params.id);
  const { title, description, creator_id } = request.body;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  if (!title || !description || !creator_id) {
    return response
      .status(400)
      .json({ message: "Title, description, and creator_id are required" });
  }

  try {
    await pool.query("CALL UpdateCourseDetails(?, ?, ?, ?)", [
      courseId,
      title,
      description,
      creator_id,
    ]);
    return response.status(200).json({
      message: "Course berhasil diupdate",
      data: {
        course_id: courseId,
        title,
        description,
      },
    });
  } catch (error) {
    console.log(error);
    if (error.sqlMessage) {
      return response.status(403).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const deleteCourse = async (request, response) => {
  const courseId = parseInt(request.params.id);
  const { creator_id } = request.body;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  if (!creator_id) {
    return response.status(400).json({ message: "creator_id is required" });
  }

  try {
    await pool.query("CALL DeleteCourse(?, ?)", [courseId, creator_id]);
    return response.status(200).json({
      message: "Course berhasil dihapus",
    });
  } catch (error) {
    console.log(error);
    if (error.sqlMessage) {
      return response.status(403).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};
