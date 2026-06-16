# 🏥 HealthyDesk — Hospital Management Database System

> A secure, normalized, enterprise-ready relational database back-end for modern hospitals, clinics, and medical centers.

---
<div align="center">

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&duration=3000&pause=800&color=6EE7B7&center=true&vCenter=true&width=540&lines=Digitalizing+Hospital+Administration.;AES-256+Encrypted.+GDPR-Compliant.;Normalized+to+3NF.+Zero+Redundancy.;Built+with+SQL+Server+%26+T-SQL.)](https://git.io/typing-svg)

</div>

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [Security & GDPR Compliance](#security--gdpr-compliance)
- [Programmability](#programmability)
- [CRUD & Analytics](#crud--analytics)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)

---

## Overview

HealthyDesk digitalizes the complete administrative cycle of a healthcare facility — from patient registration and cryptographic data protection, to room/department allocation and precise appointment scheduling.

Key guarantees:
- **100% referential integrity** — no conflicting or logically inconsistent data can be entered
- **GDPR-compliant encryption** — sensitive personal identifiers (EGN/SSN) are never stored in plain text
- **Front-end agnostic** — a clean, stable back-end foundation ready to integrate with any application layer

---

## Tech Stack

| Layer | Technology |
|---|---|
| RDBMS | Microsoft SQL Server |
| IDE | SQL Server Management Studio (SSMS) |
| Language | Transact-SQL (T-SQL) |
| Unicode Support | `NVARCHAR` |
| Temporal Data | `DATE` |
| Encrypted Storage | `VARBINARY(MAX)` |
| Primary Keys | `IDENTITY(1,1)` auto-increment |

---

## Database Schema

The database is normalized to **Third Normal Form (3NF)** and consists of five core tables:

```
Patients ──────────────────────────────────────────┐
  PK: PatientID (IDENTITY)                          │
  Fields: Name, Diagnosis, EncryptedEGN (VARBINARY) │
                                                    ├──► Appointments (Junction Table)
Doctors ───────────────────────────────────────────┤     PK: AppointmentID (IDENTITY)
  PK: DoctorID (IDENTITY)                           │     FK: PatientID → Patients
  Fields: Name, Specialty                           │     FK: DoctorID → Doctors
                                                    │     Fields: Date, Status
RoomTypes ──────────────────────────────────────────┘
  PK: RoomTypeID (IDENTITY)        1
  Fields: TypeName (VIP, ICU…)     │
          └──────────────────────── N
                                 Rooms
                                   PK: RoomID (IDENTITY)
                                   FK: RoomTypeID → RoomTypes
                                   Fields: Floor, Department
```

**Relationships at a glance:**
- `RoomTypes` → `Rooms` — **1:N** (one type, many rooms)
- `Patients` ↔ `Doctors` via `Appointments` — **N:M** (many-to-many, resolved through junction table)

---

## Security & GDPR Compliance

The National ID (EGN/SSN) is treated as highly sensitive data and stored exclusively as encrypted ciphertext using a **three-layered column-level encryption architecture**:

```
[Database Master Key (DMK)]
        │  password-protected, secures the entire hierarchy
        ▼
[Certificate — PatientCert]
        │  issued specifically for patient identity protection
        ▼
[Symmetric Key — PatientEgnKey]
        │  AES_256 encryption (bank & government standard)
        ▼
[VARBINARY column — EncryptedEGN]
        only decryptable by authorized personnel
```

> ⚠️ Plain-text EGN values are **never** persisted to disk at any point in the data lifecycle.

---

## Programmability

Complex business logic is encapsulated at the server level to maximize performance and simplify integration.

### 🔍 View — `vw_AppointmentDetails`
Abstracts a three-table join (`Patients`, `Doctors`, `Appointments`) into a single clean, denormalized scheduling dashboard. Follows the **DRY principle** — one definition, used everywhere.

```sql
SELECT * FROM vw_AppointmentDetails;
```

### ⚙️ Stored Procedure — `sp_GetDoctorSchedule`
Dynamically filters a doctor's schedule by name and appointment status. Uses parameterized inputs to prevent **SQL Injection** and benefits from **cached execution plans**.

```sql
EXEC sp_GetDoctorSchedule @DoctorName = 'Dr. Ivanova', @Status = 'Planned';
```

### 📅 Scalar Function — `fn_DaysUntilAppointment`
Calculates the exact number of days remaining until an upcoming appointment using `DATEDIFF` and `GETDATE()`. Designed for integration with automated patient notification modules.

```sql
SELECT dbo.fn_DaysUntilAppointment(AppointmentID) AS DaysLeft
FROM Appointments;
```

---

## CRUD & Analytics

The system includes a full set of **DML operations** (Create, Read, Update, Delete) for safe data lifecycle management, as well as advanced analytical queries:

| Capability | T-SQL Features Used |
|---|---|
| Appointment statistics | `COUNT`, `GROUP BY`, `HAVING` |
| Patient history filtering | `LIKE`, `AND/OR` |
| Department capacity analysis | Aggregate joins across Rooms & Appointments |
| Completed visit tracking | Status-filtered `GROUP BY` queries |

---

## Getting Started

### Prerequisites
- Microsoft SQL Server (2019 or later recommended)
- SQL Server Management Studio (SSMS)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/HealthyDesk.git
   cd HealthyDesk
   ```

2. **Run the scripts in order**
   ```
   01_create_database.sql       — Creates the HealthyDesk database
   02_create_tables.sql         — Defines all tables and foreign keys
   03_encryption_setup.sql      — Sets up DMK, certificate, and symmetric key
   04_views_procedures.sql      — Creates views, stored procedures, and functions
   05_seed_data.sql             — Inserts sample data for testing
   ```

3. **Open in SSMS**, connect to your SQL Server instance, and execute the scripts against the `HealthyDesk` database.

---

## Project Structure

```
HealthyDesk/
├── schema/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_encryption_setup.sql
├── programmability/
│   ├── vw_AppointmentDetails.sql
│   ├── sp_GetDoctorSchedule.sql
│   └── fn_DaysUntilAppointment.sql
├── data/
│   └── 05_seed_data.sql
├── queries/
│   └── analytics.sql
└── README.md
```

---

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.
