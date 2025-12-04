import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET

export const isAuthenticated = (request, response, next) => {
  try {
    const authHeader = request.headers["authorization"];
    if (!authHeader || typeof authHeader !== "string") {
      return response.status(401).json({ message: "Unauthorized. Silakan login terlebih dahulu" });
    }

    const parts = authHeader.split(" ");
    if (parts.length !== 2 || parts[0] !== "Bearer") {
      return response.status(401).json({ message: "Unauthorized. Token malformed" });
    }

    const token = parts[1];
    const decoded = jwt.verify(token, JWT_SECRET);
    request.user = decoded;
    return next();
  } catch (err) {
    return response.status(401).json({ message: "Unauthorized. Token invalid or expired" });
  }
};

export const isInstructor = (request, response, next) => {
  if (request.user && request.user.role === "instructor") {
    return next();
  }
  return response.status(403).json({ message: "Forbidden. Hanya instructor yang dapat mengakses" });
};  

export const isStudent = (request, response, next) => {
  if (request.user && request.user.role === "student") {
    return next();
  }
  return response.status(403).json({ message: "Forbidden. Hanya student yang dapat mengakses" });
};
