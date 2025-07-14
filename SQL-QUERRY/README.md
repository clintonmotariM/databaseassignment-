# 🎓 University Community System – SQLite Project

Welcome to the **University Community System** database project! This project models a realistic university structure with students, staff, courses, and learning resources using SQLite.

---

## 📦 What’s Inside?

- `university_system.sql` — the full schema & sample data script
- `university.db` — the SQLite database file (generated after running the script)
- `README.md` — usage guide (this file!)

---

## 🛠 Requirements

- **SQLite3** installed  
  You can get it from: https://www.sqlite.org/download.html  
  _(Morty has it in: `D:\database\sqlIte\sqlite3.exe`)_

- A terminal (like PowerShell or Command Prompt)

---

## 🚀 How to Set It Up

> 📁 First, make sure you're in the project directory:

```powershell
cd "D:\programing\database_assignment"



# RUN THE SCRUPT BLD IN THE DATABSE 
& "D:\database\sqlIte\sqlite3.exe" university.db

# ONCE INSIDE SQL RN
.read 'D:/programing/database_assignment/university_system.sql'

# TO VERUFY TABLES 
.tables

#  TO EXIT SQLITE 
.quit 