#!/usr/bin/env python
# encoding:utf-8

from flask import Flask
app = Flask(__name__)


@app.route('/')
def index():
    return "Hello enrico for Docker-flask with Python3.6 !"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
