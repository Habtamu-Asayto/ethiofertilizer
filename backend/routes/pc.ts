import express from "express";
const router = express.Router();
import pool from "../config/db";

router.get("/allocation", async (req, res) => {
  try {
    const query = await pool.query("SELECT * FROM fert_demand_allocation");

    if (query.rows.length === 0) {
      return res
        .status(404)
        .json({ message: "No fertilizer allocation found" });
    }

    return res.status(200).json({
      data: query.rows,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ message: "Server error" });
  }
});

router.get("/received", async (req, res) => {
  try {
    const query = await pool.query("SELECT * FROM fert_balance");

    if (query.rows.length === 0) {
      return res.status(404).json({ message: "No fertilizer Received" });
    }

    return res.status(200).json({
      data: query.rows,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ message: "Server error" });
  }
});

router.get("/sold", async (req, res) => {
  try {
    const query = await pool.query("SELECT * FROM fertilizer_sold");

    if (query.rows.length === 0) {
      return res.status(404).json({ message: "There is no fertilizer sold" });
    }

    return res.status(200).json({
      data: query.rows,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ message: "Server error" });
  }
});

router.get("/price", async (req, res) => {
  try {
    const query = await pool.query("SELECT * FROM epy_fertilizer_subsidy");

    if (query.rows.length === 0) {
      return res.status(404).json({ message: "There is no price inserted" });
    }

    return res.status(200).json({
      data: query.rows,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ message: "Server error" });
  }
});
export default router;
