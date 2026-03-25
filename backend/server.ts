import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import cors from "cors";
import authRoutes from "./routes/auth";
import installRoutes from "./routes/install";
import primaryCooperative from "./routes/pc";

dotenv.config();
// --- Express App ---
const app = express();
// --- Middleware ---
app.use(
  cors({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true,
  }),
);
app.use(express.json());
app.use(cookieParser());

// Test
// app.get("/", (req, res) => {
//   res.send("Hello World!");
// } );

app.use("/api/auth", authRoutes);
app.use("/api", installRoutes);
app.use("/api/pc",primaryCooperative)

const PORT = process.env.PORT || 5000;
// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}`);
// });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
