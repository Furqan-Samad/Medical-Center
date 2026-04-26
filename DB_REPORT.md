# Database Code Report — Medical Center

## Files inspected
- `backend/db_schema.sql` — schema definitions
- `backend/init_db.py` — script to execute the schema
- `backend/app.py` — application DB usage and queries

## Schema Summary
Tables found:
- `users` — stores accounts and roles
- `patients` — patient records, billing, prescription, file name
- `lab_reports` — test reports linked to patients
- `appointments` — scheduled appointments

Charset: `utf8mb4` (good for emoji + wide charset support)

## Issues & Findings
1. Database name mismatch:
   - `db_schema.sql` creates `hospital_db` but executes `USE hospital1_db`. This appears to be a typo and will cause `init_db.py` to create the wrong DB or fail. Change `USE hospital1_db;` to `USE hospital_db;`.

2. Roles enum mismatch:
   - `users.role` ENUM is `('admin','doctor','lab','staff')`. The app expects roles like `reception` and uses lowercase comparisons (`session.get('role')`). Add `reception` to the enum or normalize app role checks.

3. Password handling:
   - The seed `INSERT` stores a plaintext password (`'hospital123'`) into `password_hash`. The app also compares plaintext. Replace with a proper password-hashing strategy (bcrypt/argon2) and remove plaintext seed from production.

4. Referential and index suggestions:
   - Add explicit index on `lab_reports.patient_id` for faster joins.
   - Consider adding `created_at` indexes for large tables used in time-range queries.
   - `patients.assigned_doctor` is a VARCHAR; consider normalizing to reference `users(id)` (doctors) with a foreign key.

5. Safety & privileges:
   - Use a DB user with limited privileges (not `root`) for the app.
   - Enable TLS/SSL between app and DB if connecting remotely.

6. Migration & tooling:
   - Current `init_db.py` is fine for quick setup but lacks idempotent migrations. Adopt Alembic / Flask-Migrate for schema changes over time.

7. Data types & constraints:
   - `phone` VARCHAR(50) is acceptable but consider length based on E.164 (max 15) if normalized.
   - Add NOT NULL / DEFAULT constraints where appropriate to avoid NULL confusion.

## Recommended quick fixes (SQL)

1) Fix database use and add role + index and patient FK suggestion:

```sql
-- Change USE to correct DB
USE hospital_db;

-- Add 'reception' role (drop+recreate or ALTER depending on environment)
ALTER TABLE users MODIFY role ENUM('admin','doctor','lab','staff','reception') NOT NULL DEFAULT 'admin';

-- Add index on lab_reports.patient_id
ALTER TABLE lab_reports ADD INDEX idx_patient_id (patient_id);

-- Optional: make assigned_doctor reference users(id)
-- ALTER TABLE patients ADD COLUMN assigned_doctor_id INT NULL;
-- UPDATE patients SET assigned_doctor_id = (SELECT id FROM users WHERE users.username = patients.assigned_doctor LIMIT 1);
-- ALTER TABLE patients ADD CONSTRAINT fk_assigned_doctor FOREIGN KEY (assigned_doctor_id) REFERENCES users(id) ON DELETE SET NULL;
```

## Operational guidance
- Run `python backend/init_db.py` after fixing `USE` to initialize schema locally.
- Use environment variables for DB credentials; update `backend/app.py` and `init_db.py` to read them.
- Backup strategy: automate daily SQL dumps and store offsite.

## Security checklist
- Migrate plain-text passwords to hashed values (bcrypt).
- Rotate the WhatsApp token and move tokens to env vars.
- Limit DB user privileges; do not use `root` in production.

## Next improvements
- Add a small migration script and test fixtures.
- Create unit tests around DB access functions.
- Add database connection pooling and handle reconnection gracefully.

---

If you want, I can patch `db_schema.sql` with the `USE` fix and add the `reception` enum entry for you now, and run `init_db.py` locally (I will not push to GitHub without your confirmation).