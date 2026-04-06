#!/bin/bash
cd /home/site/wwwroot/UI || { echo 'Error: UI directory not found'; exit 1; }
gunicorn --bind=0.0.0.0 --timeout 600 server:app