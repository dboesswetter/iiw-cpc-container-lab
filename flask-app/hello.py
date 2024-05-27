from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/health")
def health_check():
    return "OK"

@app.route("/stress")
def stress():
    os.system("dd bs=4096 if=/dev/urandom count=10 | gzip -c > /dev/null")
    return "Wow, that was stressful"
