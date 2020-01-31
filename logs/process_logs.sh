#!/bin/bash
shopt -s nullglob

for file in ./*.kismet; do
    #sanitize it
    sqlite3 "$file" < cleandata.sql
    #merge it
    sqlite3 db.sqlite <<EOS
    attach database '$file' as dba;
    insert into devices
        select (select min(first_time) from dba.devices_xform) session_time,
            * 
        from dba.devices_xform;
    vacuum;
EOS
done