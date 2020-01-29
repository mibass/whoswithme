#!/bin/sh
shopt -s nullglob

for file in ./*.kismet; do
    sqlite3 "$file" < cleandata.sql
done