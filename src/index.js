import dotenv from "dotenv";
import express from "express";
import { login, register } from "./controllers/userController.js";
import courseRoutes from "./routes/courseRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import moduleRoutes from "./routes/moduleRoutes.js";
import instructorRoutes from "./routes/instructorRoutes.js";

dotenv.config();

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get("/", (request, response) => {
  return response.json({
    message: "Hello",
    subject: "World",
  });
});

app.use("/api/users", userRoutes);
app.use("/api/courses", courseRoutes);
app.use("/api/modules", moduleRoutes);
app.use("/api/instructors", instructorRoutes);
app.post("/api/register", register);
app.post("/api/login", login);

app.listen(PORT, () => {
  console.log(`Running http://localhost:${PORT}`);
});
