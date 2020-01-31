CREATE TABLE devices(
  session_time,
  first_time INT,
  last_time INT,
  phyname TEXT,
  devmac_hash,
  strongest_signal INT,
  type TEXT
);
CREATE UNIQUE INDEX i1 on devices(session_time, devmac_hash, type);
