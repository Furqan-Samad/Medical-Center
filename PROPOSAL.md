# Medical Center — Project Proposal

## Project Title
Medical Center (MedPro AI System)

## Overview
MedPro is a lightweight hospital management system providing patient management, laboratory reporting, billing, scheduling, and basic role-based access. The backend is a Flask app (backend/app.py) with server-side rendered templates and PDF report generation.

## Objectives
- Provide an easy-to-use admin/doctor dashboard to view patients, alerts and revenue.
- Manage lab tests and upload results with critical-alert notifications.
- Generate and share PDF medical reports and invoices.
- Support role-based access for admin, doctors, lab staff, reception, and other staff.

## Key Features
- Authentication and session management
- Patient CRUD with soft-delete and archive
- Lab management: add tests, upload results, critical alerts
- PDF generation for invoices and medical reports (FPDF)
- Simple appointments scheduling
- File uploads stored in `static/uploads/reports`
- WhatsApp PDF sending integration (tokenized API)

## Tech Stack
- Python 3.x, Flask
- MySQL (mysql-connector-python)
- FPDF for PDF generation
- Jinja2 templates (server-side UI in `backend/templates`)
- Static assets in `static/`

## Architecture
- `backend/app.py`: main Flask application and route handlers
- `backend/db_schema.sql` & `backend/init_db.py`: database schema + initializer
- `static/uploads/reports`: stored PDF and image uploads
- Templates generate server-side pages (dashboard, lab, reports)

## Installation & Run (local)
1. Create a Python virtualenv and install dependencies:

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

2. Configure environment variables (recommended):
- `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`
- `WHATSAPP_TOKEN`, `PHONE_NUMBER_ID`, `FLASK_SECRET_KEY`

3. Initialize the database:

```bash
python backend/init_db.py
```

4. Run the app:

```bash
python backend/app.py
```

## Security & Operational Notes
- Do NOT commit secrets (WhatsApp token, DB password). Move them to environment variables.
- The current `users.password_hash` stores plaintext in the seed; implement bcrypt/argon2 hashing.
- Run the app behind a reverse proxy for production and enable HTTPS.

## Next Steps & Improvements
- Add proper password hashing and password reset flows.
- Add API endpoints and token-based auth for SPA or mobile clients.
- Replace raw SQL initialization with migrations (Flask-Migrate / Alembic).
- Add tests, CI, and containerization (Docker) for easier deployments.

## Repository & Push
I can help push these files to your GitHub. Your repo: https://github.com/Furqan-Samad/Medical-Center

Suggested commands to push local changes:

```bash
git add .
git commit -m "Add project proposal and DB report"
git remote add origin https://github.com/Furqan-Samad/Medical-Center.git
git branch -M main
git push -u origin main
```

---

If you want, I can: (a) open a PR in the linked GitHub repo, (b) prepare a `README.md` instead, or (c) commit & push these changes for you (requires credentials/access).