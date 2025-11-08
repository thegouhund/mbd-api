import pool from "../../config/db.js";

export const getAllUsers = async (request, response) => {
  try {
    const [result] = await pool.query("CALL GetAllUsers()");
    return response.status(200).json({
      message: "Berhasil mengambil data pengguna",
      data: result[0],
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const getUserById = async (request, response) => {
  const userId = parseInt(request.params.id);
  if (isNaN(userId)) {
    return response.status(400).json({ message: "Invalid user id" });
  }

  try {
    const [result] = await pool.query("CALL GetUserByID(?)", [userId]);
    const user = result && result[0] && result[0][0] ? result[0][0] : null;

    if (!user) {
      return response.status(404).json({ message: "User not found" });
    }

    return response.status(200).json({
      message: "Berhasil mengambil data pengguna",
      data: user,
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const register = async (request, response) => {
  const { username, password, role } = request.body;

  if (!username || !password || !role) {
    return response
      .status(400)
      .json({ message: "Username, password, and role are required" });
  }

  if (!["student", "instructor"].includes(role)) {
    return response
      .status(400)
      .json({ message: "Role must be either 'student' or 'instructor'" });
  }

  try {
    const [result] = await pool.query("CALL Register(?, ?, ?)", [
      username,
      password,
      role,
    ]);
    const registerResult =
      result && result[0] && result[0][0] ? result[0][0] : null;

    if (!registerResult) {
      return response
        .status(500)
        .json({ message: "Terjadi kesalahan pada server" });
    }

    if (registerResult.status === "ERROR") {
      return response.status(409).json({ message: registerResult.message });
    }

    return response.status(201).json({
      message: registerResult.message,
      data: {
        username: registerResult.username,
        role: registerResult.role,
      },
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const login = async (request, response) => {
  const { username, password } = request.body;

  if (!username || !password) {
    return response
      .status(400)
      .json({ message: "Username and password are required" });
  }

  try {
    const [result] = await pool.query("CALL Login(?, ?)", [username, password]);
    const loginResult =
      result && result[0] && result[0][0] ? result[0][0] : null;

    if (!loginResult) {
      return response
        .status(500)
        .json({ message: "Terjadi kesalahan pada server" });
    }

    if (loginResult.status === "ERROR") {
      return response.status(401).json({ message: loginResult.message });
    }

    return response.status(200).json({
      message: loginResult.message,
      data: {
        user_id: loginResult.user_id,
        username: loginResult.username,
        role: loginResult.role,
      },
    });
  } catch (error) {
    console.log(error);
    return response
      .status(500)
      .json({ message: "Terjadi kesalahan pada server" });
  }
};

export const getUserCourses = async (request, response) => {
  const userId = parseInt(request.params.id);

  if (isNaN(userId)) {
    return response.status(400).json({ message: "Invalid user id" });
  }

  try {
    const [result] = await pool.query("CALL GetStudentCourses(?)", [userId]);
    return response.status(200).json({
      message: "Berhasil mengambil daftar course untuk user",
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
