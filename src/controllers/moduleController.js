import pool from "../../config/db.js";

export const getModulesForCourse = async (request, response) => {
  try {
    const { courseId } = request.params;
    const userId = request.session?.user?.user_id;

    const [result] = await pool.query("CALL GetModulesForCourse(?, ?)", [
      courseId,
      userId,
    ]);

    return response.status(200).json({
      message: "Berhasil mengambil daftar modul",
      data: result[0],
    });
  } catch (error) {
    if (error.sqlMessage) {
      return response.status(400).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};

export const addModuleToCourse = async (request, response) => {
  try {
    const { title, content, course_id } = request.body;

    await pool.query("CALL AddModuleToCourse(?, ?, ?)", [
      course_id,
      title,
      content,
    ]);

    return response.status(201).json({
      message: "Berhasil menambahkan modul ke course",
    });
  } catch (error) {
    if (error.sqlMessage) {
      return response.status(400).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const updateModule = async (request, response) => {
  try {
    const { moduleId } = request.params;
    const { title, content, creatorId } = request.body;

    await pool.query("CALL UpdateModule(?, ?, ?, ?)", [
      moduleId,
      title,
      content,
      creatorId,
    ]);

    return response.status(200).json({
      message: "Berhasil mengupdate modul",
    });
  } catch (error) {
    if (error.sqlMessage) {
      return response.status(400).json({ message: error.sqlMessage });
    }

    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};

export const deleteModule = async (request, response) => {
  try {
    const { moduleId } = request.params;
    const creator_id = request.session?.user?.user_id;

    await pool.query("CALL DeleteModule(?, ?)", [moduleId, creator_id]);

    return response.status(200).json({
      message: "Berhasil menghapus modul",
    });
  } catch (error) {
    if (error.sqlMessage) {
      return response.status(400).json({ message: error.sqlMessage });
    }
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};
