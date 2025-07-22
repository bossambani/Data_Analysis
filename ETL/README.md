# 🛠️ ETL Script: Pull Users from API into SQLite Database

This project is a simple ETL (Extract, Transform, Load) script written in Python. It fetches user data from a public API and stores it in a local SQLite database.

---

## 📌 Features

- Extracts user data from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/users)
- Parses JSON responses into structured Python objects
- Transforms complex nested fields (`address`, `company`) into JSON strings
- Loads data into a local SQLite database (`users.db`)


---

## 🧪 Requirements

- Python 3.x
- `requests` library

Install requirements using:

```bash
pip install requests
