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

export const getCourseById = async (request, response) => {
  const courseId = parseInt(request.params.id);

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  try {
    const [result] = await pool.query("CALL GetCourseById(?)", [courseId]);
    return response.status(200).json({
      message: "Berhasil mengambil course",
      data: result[0][0],
    })
  } catch (error) {
    console.log(error);
    return response;
  }
};

export const createCourse = async (request, response) => {
  const { title, description } = request.body;
  const creator_id = request.user?.user_id;

  if (!title || !description) {
    return response
      .status(400)
      .json({ message: "Title and description are required" });
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
  const { title, description } = request.body;

  const creator_id = request.user?.user_id;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  if (!title || !description) {
    return response
      .status(400)
      .json({ message: "Title dan description harus diisi" });
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
      return response.status(400).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const deleteCourse = async (request, response) => {
  const courseId = parseInt(request.params.id);
  const creator_id = request.user?.user_id;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
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

export const enrollUser = async (request, response) => {
  const courseId = parseInt(request.params.courseId);
  const user_id = request.user?.user_id;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  try {
    await pool.query("CALL EnrollUser(?, ?)", [user_id, courseId]);
    return response.status(201).json({
      message: "User berhasil didaftarkan ke course",
      data: { course_id: courseId, user_id },
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

export const unenrollUser = async (request, response) => {
  const courseId = parseInt(request.params.courseId);
  const user_id = request.user?.user_id;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  if (!user_id) {
    return response.status(400).json({ message: "user_id is required" });
  }

  try {
    await pool.query("CALL UnenrollUser(?, ?)", [user_id, courseId]);
    return response.status(200).json({
      message: "User berhasil dihapus dari course",
      data: { course_id: courseId, user_id },
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

export const getCourseStudents = async (request, response) => {
  const courseId = parseInt(request.params.id || request.params.courseId);
  const creator_id = request.user?.user_id;

  if (isNaN(courseId)) {
    return response.status(400).json({ message: "Invalid course id" });
  }

  try {
    const [result] = await pool.query("CALL GetCourseStudents(?, ?)", [
      creator_id,
      courseId,
    ]);
    return response.status(200).json({
      message: "Berhasil mengambil daftar student untuk course",
      data: result[0],
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

export const getCoursesByCreatorId = async (request, response) => {
  const creator_id = request.user?.user_id;

  try {
    const [result] = await pool.query("CALL GetCoursesByCreatorId(?)", [creator_id]);
    return response.status(200).json({
      message: "Berhasil mengambil daftar course untuk instructor",
      data: result[0],
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