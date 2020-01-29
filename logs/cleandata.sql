drop table if exists snapshots;
drop table if exists alerts;
drop table if exists data;
drop table if exists datasources;
drop table if exists messages;
drop table if exists KISMET;
drop table if exists packets;

/*from https://github.com/breenie/SqliteExtensions */
/*compile with gcc -bundle -fPIC -Isqlite3 -o digest.so digest.c */
select load_extension('digest.so');

create table if not exists devices_xform as
    select first_time,
            last_time,
            phyname,
            sha1(devmac) devmac_hash,
            strongest_signal,
            type
    from devices
;

drop table if exists devices;
vacuum;