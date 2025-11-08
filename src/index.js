import express from "express";
import dotenv from "dotenv";
import userRoutes from "./routes/userRoutes.js";
import courseRoutes from "./routes/courseRoutes.js";

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

app.listen(PORT, () => {
  console.log(`Running http://localhost:${PORT}`);
});
