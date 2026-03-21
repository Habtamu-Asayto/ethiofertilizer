import pool from "../config/db";
import express from "express";
import fs from "fs";
import path from "path";

const router = express.Router();

router.get("/install", async (req, res) => {
  const queryfile = path.join(__dirname, "sql/easyLearn.sql");

  let queries: string[] = [];
  let tempLine = "";

  const lines = fs.readFileSync(queryfile, "utf-8").split("\n");

  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.startsWith("--") || trimmed === "") continue;

    tempLine += line + " ";
    if (trimmed.endsWith(";")) {
      queries.push(tempLine.trim());
      tempLine = "";
    }
  }

  const finalMessage: { message?: any; status?: number } = {};

  for (const query of queries) {
    try {
      await pool.query(query);
      console.log("Table created");
    } catch (err) {
      console.error("Error executing query:", err);
      finalMessage.message = err;
    }
  }

  if (!finalMessage.message) {
    finalMessage.message = "All tables are created";
    finalMessage.status = 200;
  } else {
    finalMessage.status = 500;
  }

  return res
    .status(finalMessage.status)
    .json({ message: finalMessage.message });
});

export default router;
