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

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });
};

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

    // Optionally generate JWT and set cookie
    const jwtToken = generateToken(user_id); // implement generateToken()
    res.cookie("token", jwtToken, {
      httpOnly: true,
      maxAge: hours * 3600 * 1000,
    });

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

//Login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: "Please fill in all fields" });
  }
  const user = await pool.query("SELECT * FROM users WHERE email = $1", [
    email,
  ]);
  if (user.rows.length === 0) {
    return res.status(400).json({ message: "Invalid email credentials" });
  }
  const userData = user.rows[0];
  const isMatch = await bcrypt.compare(password, userData.password);
  if (!isMatch) {
    return res.status(400).json({ message: "Invalid credentials, PWD" });
  }
  const token = generateToken(userData.id);
  res.cookie("token", token, cookieOptions);
  res.json({
    user: {
      id: userData.id,
      name: userData.name,
      email: userData.email,
    },
  });
});

router.get("/me", protect, async (req, res) => {
  const token = req.cookies.token;
  if (!token) {
    return res.status(401).json({ message: "Not authorized" });
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await pool.query(
      "SELECT id, name, email FROM users WHERE id = $1",
      [decoded.id],
    );
    if (user.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ user: user.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(401).json({ message: "Not authorized" });
  }
});

router.get("/logout", (req, res) => {
  res.clearCookie("token", cookieOptions); // Clear the cookie with the same options
  // res.cookie("token", "", {...cookieOptions, maxAge:1}); // Set the cookie to expire immediately
  res.json({ message: "Logged out successfully" });
});

export default router;
