import jwt from "jsonwebtoken";
import pool from "../config/db";

export const protect = async (req, res, next) => {
  let token;

  // Get token from cookies
  if (req.cookies && req.cookies.token) {
    token = req.cookies.token;
  }

  if (!token) {
    return res.status(401).json({ message: "Not authorized, no token" });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const { rows } = await pool.query(
      `SELECT ul.user_id, ul.user_email, ul.profile_img, 
              ui.user_full_name, ui.user_phone
       FROM user_login ul
       LEFT JOIN user_info ui ON ui.user_id = ul.user_id
       WHERE ul.user_id = $1`,
      [decoded.id],
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    req.user = rows[0]; // attach user info to request
    next(); // call next handler
  } catch (err) {
    console.error(err);
    res.status(401).json({ message: "Not authorized, token failed" });
  }
};
