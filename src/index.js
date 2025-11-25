import dotenv from "dotenv";
import express from "express";
import session from "express-session";
import sessionConfig from "../config/session.js";
import { login, logout, register } from "./controllers/userController.js";
import courseRoutes from "./routes/courseRoutes.js";
import userRoutes from "./routes/userRoutes.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(session(sessionConfig));

const PORT = process.env.PORT || 3000;

app.get("/", (request, response) => {
  return response.json({
    message: "Hello",
    subject: "World",
  });
});

app.use("/api/users", userRoutes);
app.use("/api/courses", courseRoutes);
app.post("/api/register", register);
app.post("/api/login", login);
app.post("/api/logout", logout);

app.listen(PORT, () => {
  console.log(`Running http://localhost:${PORT}`);
});
