drop table if exists snapshots;
drop table if exists alerts;
drop table if exists data;
drop table if exists datasources;
drop table if exists messages;
drop table if exists KISMET;
drop table if exists packets;


create table if not exists devices_xform as
    select first_time,
            last_time,
            devkey,
            phyname,
            devmac,
            strongest_signal,
            type
    from devices
;

drop table if exists devices;