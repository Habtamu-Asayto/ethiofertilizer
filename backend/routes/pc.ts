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

router.post("/add_sell", async (req, res) => {
  try {
    const {
      farmer_name,
      f_father_name,
      f_gf_name,
      phone,
      land_size,
      dap_quantity,
      urea_quantity,
      sex,
    } = req.body;

    if (!farmer_name || !f_father_name || !f_gf_name || !phone || !land_size) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const year = new Date().getFullYear().toString();

    // 🔹 Generate transaction_code
    const lastTxn = await pool.query(
      `SELECT transaction_code FROM fertilizer_sold 
       WHERE year = $1 ORDER BY fsid DESC LIMIT 1`,
      [year],
    );

    let nextNumber = 1;

    if (lastTxn.rows.length > 0) {
      const lastNum = parseInt(lastTxn.rows[0].transaction_code.split("-")[2]);
      nextNumber = lastNum + 1;
    }

    const tran_code = `TXN-${year}-${String(nextNumber).padStart(4, "0")}`;

    // 🔹 Generate bank_transaction_id
    const lastBank = await pool.query(
      `SELECT bank_transaction_id FROM fertilizer_sold 
       ORDER BY fsid DESC LIMIT 1`,
    );

    let nextBank = 1;

    if (lastBank.rows.length > 0) {
      const lastNum = parseInt(
        lastBank.rows[0].bank_transaction_id.split("-")[2],
      );
      nextBank = lastNum + 1;
    }

    const tran_id = `BANK-TXN-${String(nextBank).padStart(4, "0")}`;

    // 🔹 Today
    const sold_date = new Date().toISOString();
    const total_fert = Number(dap_quantity) + Number(urea_quantity);
    const query = `
      INSERT INTO fertilizer_sold
      (transaction_code, year, farmer_name, f_father_name, f_gf_name, mobile, farm_area_ha, fert_amount_DAP, fert_amount_UREA, sex, fert_amount_total, sold_date, bank_transaction_id)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
      RETURNING *;
    `;

    const values = [
      tran_code,
      year,
      farmer_name,
      f_father_name,
      f_gf_name,
      phone,
      land_size,
      dap_quantity || null,
      urea_quantity || null,
      sex,
      total_fert,
      sold_date,
      tran_id,
    ];

    const result = await pool.query(query, values);

    return res.status(201).json({
      message: "Sell recorded successfully",
      data: result.rows[0],
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
