import pool from "../../config/db.js";

export const getModulesForCourse = async (request, response) => {
  try {
    const { courseId } = request.params;
    const [result] = await pool.query("CALL GetModulesForCourse(?)", [
      courseId,
    ]);
    return response.status(200).json({
      message: "Berhasil mengambil daftar modul",
      data: result[0],
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};

export const addModuleToCourse = async (request, response) => {
  try {
    const { courseId } = request.params;
    const { title, content } = request.body;

    await pool.query("CALL AddModuleToCourse(?, ?, ?)", [
      courseId,
      title,
      content,
    ]);

    return response.status(201).json({
      message: "Berhasil menambahkan modul ke course",
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
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
    console.log(error);
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};

export const deleteModule = async (request, response) => {
  try {
    const { moduleId } = request.params;
    const { creatorId } = request.body;

    await pool.query("CALL DeleteModule(?, ?)", [moduleId, creatorId]);

    return response.status(200).json({
      message: "Berhasil menghapus modul",
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: error.sqlMessage || "Terjadi kesalahan pada server" });
  }
};
