from flask import Flask
import os
import psycopg2
from psycopg2 import Error

PGHOST = os.getenv("PGHOST")
PGPORT = os.getenv("PGPORT")
PGDATABASE = os.getenv("PGDATABASE")
PGUSER = os.getenv("PGUSER")
PGPASSWORD = os.getenv("PGPASSWORD")


app = Flask(__name__)

@app.route('/_healthz')
def health():
    return "Okay"

@app.route('/')
def db_demo():
    return get_db_info()

def get_db_info():
    try:
        # Connect to an existing database
        connection = psycopg2.connect(user=PGUSER,
                                    password=PGPASSWORD,
                                    host=PGHOST,
                                    port=PGPORT,
                                    database=PGDATABASE)

        # Create a cursor to perform database operations
        cursor = connection.cursor()
        # Print PostgreSQL details
        print("PostgreSQL server information")
        print(connection.get_dsn_parameters(), "\n")
        # Executing a SQL query
        cursor.execute("SELECT version();")
        # Fetch result
        record = cursor.fetchone()
        return f"You are connected to - {record}"

    except (Exception, Error) as error:
        print("Error while connecting to PostgreSQL", error)
    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
    
