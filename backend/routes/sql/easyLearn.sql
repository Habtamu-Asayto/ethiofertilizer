-- Users table 
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL UNIQUE,
    profile_img VARCHAR(255),
    last_seen TIMESTAMP,
    created_at TIMESTAMP DEFAULT now(),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verification_token VARCHAR(128),
    verification_token_expires TIMESTAMP
);

-- Messages table
CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    receiver_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    message TEXT,
    unread BOOLEAN DEFAULT TRUE,
    is_ai BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT now()
);

-- User info table
CREATE TABLE IF NOT EXISTS user_info (
    user_info_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    user_full_name VARCHAR(255) NOT NULL,
    user_phone VARCHAR(255) NOT NULL
);

-- User password table
CREATE TABLE IF NOT EXISTS user_pass (
    user_pass_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    user_password_hashed VARCHAR(255) NOT NULL
);

-- Password reset tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    token_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    reset_token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL
);

-- User roles table
CREATE TABLE IF NOT EXISTS user_role (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    role_name INT NOT NULL
);

-- Chat table
CREATE TABLE IF NOT EXISTS chat (
    chat_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    receiver_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT now()
);