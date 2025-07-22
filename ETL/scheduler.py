import schedule
import time
import subprocess

def run_etl_script():
    print("Running ETL script...")
    subprocess.run(["python", "main.py"])


schedule.every().day.at("10:28").do(run_etl_script)

print("Scheduler is running...")

while True:
    schedule.run_pending()
    time.sleep(1)
