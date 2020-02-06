#!/bin/sh

#get all new files
rsync -a --ignore-existing pi@192.168.1.10:/home/pi/logs/*.kismet ./

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

#clean up short sessions
sqlite3 db.sqlite <<EOS
delete from devices where session_time in (select session_time 
    from devices group by 1 having count(*)<1e4);
vacuum;
EOS