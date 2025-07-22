import requests
import sqlite3
import json

url = "https://jsonplaceholder.typicode.com/users"
response = requests.get(url)
if response.status_code == 200:
    users = response.json()

else:
    print("Error Fetching data", response.status_code)
    exit()

conn = sqlite3.connect("users.db")
cursor = conn.cursor()

#Creating table is not exists
cursor.execute(
    '''CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY,
    name TEXT,
    username TEXT,
    email TEXT,
    address TEXT,
    phone TEXT,
    website TEXT,
    company TEXT
)
'''
)

#Inserting data into the table
for user in users:
    cursor.execute('SELECT 1 FROM users WHERE id = ?', (user['id'],))
    exists = cursor.fetchone()

    if not exists:
        cursor.execute(
            '''INSERT INTO users(id, name, username, email, address, phone, website, company)
            VALUES(?, ?, ?, ?, ?, ?, ?, ?)''',
            (
                user['id'],
                user['name'],
                user['username'],
                user['email'],
                json.dumps(user['address']),
                user['phone'],
                user['website'],
                json.dumps(user['company'])
            )
        )

conn.commit()
conn.close()
print("Data Inserted Successfully!!!")
