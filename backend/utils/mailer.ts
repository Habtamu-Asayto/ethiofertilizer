// utils/mailer.ts
import nodemailer from "nodemailer";
import dotenv from "dotenv";

dotenv.config();

const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true, // SSL
  auth: {
    user: process.env.EMAIL_USER, // Your Gmail address
    pass: process.env.EMAIL_PASS, // Gmail App Password
  },
});

transporter.verify((err, success) => {
  if (err) {
    console.error("SMTP Connection Failed:", err);
  } else {
    console.log("SMTP is ready to send messages");
  }
});

export async function sendVerificationEmail(
  toEmail: string,
  user_full_name: string,
  token: string,
) {
  const frontendUrl = process.env.CLIENT_URL || "http://localhost:3000";
  const link = `${frontendUrl}/verify-email?token=${encodeURIComponent(token)}&email=${encodeURIComponent(toEmail)}`;

  const html = `
    <!DOCTYPE html>
    <html lang="en">
      <head><meta charset="UTF-8"><title>Verify your account</title></head>
      <body style="font-family: sans-serif; line-height: 1.6;">
        <h2>Hello ${user_full_name},</h2>
        <p>Please confirm your email by clicking below:</p>
        <a href="${link}" style="padding: 12px 25px; background: #36D1DC; color: white; border-radius: 8px; text-decoration: none;">Verify Email</a>
        <p>If you didn’t request this, you can ignore this email.</p>
      </body>
    </html>
  `;

  const mailOptions = {
    from: process.env.EMAIL_FROM || process.env.EMAIL_USER,
    to: toEmail,
    subject: "Verify your email",
    html,
  };

  return transporter.sendMail(mailOptions);
}
