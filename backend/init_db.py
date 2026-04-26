import os
import mysql.connector

# Copy the same credentials used by app.py - adjust if needed
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': "",
    'database': 'hospital_db'
}


def load_sql(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()


def main():
    schema_path = os.path.join(os.path.dirname(__file__), 'db_schema.sql')
    sql = load_sql(schema_path)
    try:
        # Connect without specifying database so CREATE DATABASE works
        conn = mysql.connector.connect(host=db_config['host'], user=db_config['user'], password=db_config['password'])
        cursor = conn.cursor()
        for result in cursor.execute(sql, multi=True):
            try:
                if result.with_rows:
                    result.fetchall()
            except Exception:
                pass
        conn.commit()
        print('Database and tables created successfully.')
    except mysql.connector.Error as err:
        print('Error:', err)
    finally:
        try:
            cursor.close()
            conn.close()
        except Exception:
            pass


if __name__ == '__main__':
    main()
