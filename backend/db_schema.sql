-- Schema for hospital_db
CREATE DATABASE IF NOT EXISTS hospital_db CHARACTER SET = 'utf8mb4' COLLATE = 'utf8mb4_unicode_ci';
USE hospital_db;

-- Users table (simple roles)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','doctor','lab','staff','reception') NOT NULL DEFAULT 'admin',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Patients table
CREATE TABLE IF NOT EXISTS patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  phone VARCHAR(50),
  age INT,
  gender VARCHAR(20),
  disease_summary TEXT,
  total_bill DECIMAL(10,2) DEFAULT 0.00,
  assigned_doctor VARCHAR(200),
  is_active TINYINT(1) DEFAULT 1,
  lab_result_file VARCHAR(255),
  doctor_notes TEXT,
  prescription TEXT,
  department VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX(idx_assigned_doctor (assigned_doctor)),
  INDEX(idx_is_active (is_active))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lab reports table
CREATE TABLE IF NOT EXISTS lab_reports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  test_name VARCHAR(200) NOT NULL,
  test_result TEXT,
  reference_range VARCHAR(200),
  status ENUM('Pending','Normal','Critical') DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
  INDEX(idx_status (status))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_name VARCHAR(200) NOT NULL,
  appointment_time DATETIME,
  reason TEXT,
  type VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed an admin user (app currently compares plaintext password)
INSERT IGNORE INTO users (username, password_hash, role) VALUES ('admin', 'hospital123', 'admin');
