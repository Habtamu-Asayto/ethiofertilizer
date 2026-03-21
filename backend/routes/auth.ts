import express from "express";
import bcrypt from "bcrypt";
import crypto from "crypto";
import jwt from "jsonwebtoken";
import pool from "../config/db";
import { protect } from "../middleware/auth";
import { sendVerificationEmail } from "../utils/mailer";
const router = express.Router();

const cookieOptions = {
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
  sameSite: "Strict",
  maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
};

router.post("/login", async (req, res) => {
  console.log(req.body);

  const { user_email, user_password } = req.body;
  if (!user_email || !user_password) {
    return res
      .status(400)
      .json({ message: "Please provide email and password" });
  }

  try {
    // Fetch user by email, join user_pass table to get hashed password
    const userQuery = await pool.query(
      `SELECT u.user_id, u.user_email, u.is_verified, ui.user_full_name, 
              up.user_password_hashed
       FROM users u
       JOIN user_info ui ON u.user_id = ui.user_id
       JOIN user_pass up ON u.user_id = up.user_id
       WHERE u.user_email = $1`,
      [user_email],
    );

    if (userQuery.rows.length === 0) {
      return res.status(404).json({ message: "User does not exist" });
    }

    const user = userQuery.rows[0];

    // Check password
    const passwordMatch = await bcrypt.compare(
      user_password,
      user.user_password_hashed,
    );
    if (!passwordMatch) {
      return res.status(401).json({ message: "Incorrect password" });
    }

    // Check email verification
    if (!user.is_verified) {
      return res.status(403).json({
        message: "Please verify your email before logging in.",
      });
    }

    // Successful login
    return res.status(200).json({
      status: "success",
      data: {
        user_id: user.user_id,
        user_email: user.user_email,
        user_full_name: user.user_full_name,
      },
      message: "Login successful",
    });
  } catch (err) {
    console.error("Error logging in user:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// Register User
router.post("/register", async (req, res) => {
  console.log(req.body);
  const {
    user_full_name,
    user_email,
    user_phone,
    user_password,
    user_role_id,
  } = req.body;
  if (!user_full_name || !user_email || !user_phone || !user_password) {
    return res.status(400).json({ message: "Please fill required fields" });
  }
  try {
    // Check if email already exists
    const userExists = await pool.query(
      "SELECT * FROM users WHERE user_email = $1",
      [user_email],
    );
    if (userExists.rows.length > 0) {
      return res.status(400).json({
        message: "This email is already associated with another user",
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(user_password, 10);

    // Insert into users table
    const userInsert = await pool.query(
      `INSERT INTO users (user_email, is_verified, created_at)
       VALUES ($1, $2, now())
       RETURNING user_id, user_email`,
      [user_email, false],
    );
    const user_id = userInsert.rows[0].user_id;

    // Insert into user_info
    await pool.query(
      `INSERT INTO user_info (user_id, user_full_name, user_phone)
       VALUES ($1, $2, $3)`,
      [user_id, user_full_name, user_phone],
    );

    // Insert into user_pass
    await pool.query(
      `INSERT INTO user_pass (user_id, user_password_hashed)
       VALUES ($1, $2)`,
      [user_id, hashedPassword],
    );

    // Insert into user_role
    await pool.query(
      `INSERT INTO user_role (user_id, role_name)
       VALUES ($1, $2)`,
      [user_id, user_role_id || 1], // default role_id = 1 if not provided
    );

    // Generate verification token
    const token = crypto.randomBytes(32).toString("hex");
    const hours = parseInt(
      process.env.VERIFICATION_TOKEN_EXPIRES_HOURS || "24",
      10,
    );
    const expires = new Date(Date.now() + hours * 3600 * 1000);

    await pool.query(
      `UPDATE users SET verification_token = $1, verification_token_expires = $2
       WHERE user_id = $3`,
      [token, expires, user_id],
    );

    // Send verification email
    try {
      await sendVerificationEmail(user_email, user_full_name, token);
    } catch (err) {
      console.error("Verification email failed:", err);
    }

    return res.status(201).json({
      user: {
        user_id,
        user_email,
        user_full_name,
      },
      status: "pending_verification",
      message: "Check your email for verification",
    });
  } catch (err) {
    console.error("Error registering user:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

router.post("/verify-email", async (req, res) => {
  const { token, email } = req.body;
  if (!token || !email) {
    return res.status(400).json({ message: "Invalid verification link" });
  }
  try {
    const userResult = await pool.query(
      `SELECT user_id, verification_token_expires FROM users
       WHERE user_email = $1 AND verification_token = $2`,
      [email, token],
    );

    if (userResult.rows.length === 0) {
      return res.status(400).json({ message: "Invalid verification link" });
    }

    const user = userResult.rows[0];
    if (user.verification_token_expires < new Date()) {
      return res.status(400).json({ message: "Verification link has expired" });
    }

    await pool.query(
      `UPDATE users SET is_verified = $1, verification_token = NULL, verification_token_expires = NULL
       WHERE user_id = $2`,
      [true, user.user_id],
    );

    return res.status(200).json({ message: "Email verified successfully!" });
  } catch (err) {
    console.error("Error verifying email:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

export default router;
