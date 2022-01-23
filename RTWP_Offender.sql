--
-- week_offender
--
--
DROP TABLE IF EXISTS temptable;
CREATE TABLE temptable AS
SELECT
w.PLMN_id, w.Prefijo, w.UARFCN, w.Banda, w.Region, w.Depto, w.Mun, w.LocalidadCRC, w.Cluster,
r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid, AVG(r.AvgRTWP) AS Avg1RTWP, MAX(r.AvgRTWP) AS Max1RTWP, AVG(r.AvgCS_ERL) AS AvgCS_ERL,
AVG(r.AvgMaxHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.AvgPrach) AS AvgPrach
FROM RTWPU r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-1 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE)
GROUP BY r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid
ORDER BY MAX(AvgRTWP) DESC;
--
DROP TABLE IF EXISTS rtwp1daydif;
CREATE TABLE rtwp1daydif AS
SELECT
PLMN_id, Prefijo, UARFCN, Banda, Region, Depto, Mun, LocalidadCRC, Cluster, RNCname, WBTSname, WBTSid, WCELname, WCELid,
Avg1RTWP, Max1RTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach
FROM temptable;
--
DROP TABLE IF EXISTS temptable;
CREATE TABLE temptable AS
SELECT
w.PLMN_id, w.Prefijo, w.UARFCN, w.Banda, w.Region, w.Depto, w.Mun, w.LocalidadCRC, w.Cluster,
r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid, AVG(r.AvgRTWP) AS AvgRTWP, MAX(r.AvgRTWP) AS MaxRTWP, AVG(r.AvgCS_ERL) AS AvgCS_ERL,
AVG(r.AvgMaxHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.AvgPrach) AS AvgPrach, t.Max1RTWP AS Last_RTWP
FROM (RTWPU r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE)
LEFT JOIN rtwp1daydif t ON r.WCELname = t.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-7 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE)
GROUP BY r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid
ORDER BY MAX(AvgRTWP) DESC;
--
DROP TABLE IF EXISTS rtwpf7day;
CREATE TABLE rtwpf7day AS
SELECT
WCELname, AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach, Last_RTWP
FROM temptable
ORDER BY Last_RTWP DESC;
--
DROP TABLE IF EXISTS rtwp7day;
CREATE TABLE rtwp7day AS
SELECT
RNCname, WBTSname, WBTSid, WCELname, WCELid, MaxRTWP, AvgCS_ERL, AvgRTWP, Last_RTWP, AvgMaxHSDPAusers , AvgPrach
FROM temptable
WHERE AvgRTWP > -90 AND MaxRTWP > -90 AND Last_RTWP > -90
ORDER BY Last_RTWP DESC
LIMIT 40;
--
DROP TABLE IF EXISTS rtwpuofdr;
CREATE TABLE rtwpuofdr AS
SELECT
WCELname, AvgMaxHSDPAusers, AvgRTWP, Last_RTWP
FROM temptable
ORDER BY Last_RTWP DESC;
--
--
DROP TABLE IF EXISTS temptable;
CREATE TABLE temptable AS
SELECT
lp.PLMN_id, r.MRBTSname, r.LNBTSname, r.LNCELname, lp.Prefijo, lp.Sector, lp.earfcnDL, lp.Banda, lp.MRBTS_id, lp.LNBTS_id, lp.LNCEL_id,
lp.Estado, lp.Region, lp.Depto, lp.Mun, lp.LocalidadCRC, lp.Cluster, AVG(r.AvgRWTP1) AS AvgRWTP1, AVG(r.AvgRWTP2) AS AvgRWTP2,
AVG(r.AvgRWTP3) AS AvgRWTP3, AVG(r.AvgRWTP4) AS AvgRWTP4, AVG(r.AvgUEdist) AS AvgUEdist, (AVG(r.DL_PRB))/10 AS AVG_DL_PRB,
(AVG(r.Data_Vol))/1000000 AS AVG_Data_VolMb, AVG(r.RRC_Users_Max) AS AVG_RRC_Users_Max, AVG(r.AvgRWTP) AS AvgRWTP,
AVG(r.PortMeas) AS AVG_PortMeas, AVG(r.DiffRWTP) AS AVG_DiffRWTP
FROM RWTPL r LEFT JOIN lte_param lp ON r.LNCELname =lp.LNCELname COLLATE NOCASE
WHERE (r.Day > (SELECT DATETIME('now', '-1 day', 'localtime')) AND Region = 'NOROCCIDENTE' COLLATE NOCASE)
GROUP BY r.MRBTSname, r.LNBTSname, r.LNCELname
ORDER BY MAX(r.DiffRWTP) DESC;
--
DROP TABLE IF EXISTS rtwp1dayldif;
CREATE TABLE rtwp1dayldif AS
SELECT
PLMN_id, LNBTSname, LNBTS_id, LNCELname, LNCEL_id, AvgRWTP, AVG_PortMeas, AVG_DiffRWTP, AvgRWTP1, AvgRWTP2, AvgRWTP3, AvgRWTP4, AvgUEdist, AVG_DL_PRB, AVG_Data_VolMb,
AVG_RRC_Users_Max, MRBTSname,  Prefijo, Sector, earfcnDL, Banda, MRBTS_id,  Estado, Region, Depto, Mun,
LocalidadCRC, Cluster
FROM temptable;
--
DROP TABLE IF EXISTS temptable;
CREATE TABLE temptable AS
SELECT
lp.PLMN_id, r.MRBTSname, r.LNBTSname, r.LNCELname, lp.Prefijo, lp.Sector, lp.earfcnDL, lp.Banda, lp.MRBTS_id, lp.LNBTS_id, lp.LNCEL_id,
lp.Estado, lp.Region, lp.Depto, lp.Mun, lp.LocalidadCRC, lp.Cluster, AVG(r.AvgRWTP1) AS AvgRWTP1, AVG(r.AvgRWTP2) AS AvgRWTP2,
AVG(r.AvgRWTP3) AS AvgRWTP3, AVG(r.AvgRWTP4) AS AvgRWTP4, AVG(r.AvgUEdist) AS AvgUEdist, (AVG(r.DL_PRB))/10 AS AVG_DL_PRB,
(AVG(r.Data_Vol))/1000000 AS AVG_Data_VolMb, AVG(r.RRC_Users_Max) AS AVG_RRC_Users_Max, AVG(r.AvgRWTP) AS AvgRWTP, AVG(r.PortMeas) AS AVG_PortMeas,
AVG(r.DiffRWTP) AS AVG_DiffRWTP, l.AvgRWTP AS Last_AvgRWTP, l.AVG_PortMeas AS Last_AVG_PortMeas, l.AVG_DiffRWTP AS Last_AVG_DiffRWTP
FROM (RWTPL r LEFT JOIN lte_param lp ON r.LNCELname =lp.LNCELname COLLATE NOCASE)
LEFT JOIN rtwp1dayldif l ON r.LNCELname =l.LNCELname COLLATE NOCASE
WHERE (r.Day > (SELECT DATETIME('now', '-7 day', 'localtime')))
GROUP BY r.MRBTSname, r.LNBTSname, r.LNCELname
ORDER BY MAX(r.AvgRWTP) DESC;
--
DROP TABLE IF EXISTS rtwp7dayl;
CREATE TABLE rtwp7dayl AS
SELECT
PLMN_id, LNBTSname, LNBTS_id, LNCELname, LNCEL_id, AVG_PortMeas, AVG_DiffRWTP, AvgRWTP, Last_AvgRWTP, AvgRWTP1, AvgRWTP2, AvgRWTP3, AvgRWTP4, AvgUEdist,
AVG_DL_PRB, AVG_Data_VolMb, AVG_RRC_Users_Max, MRBTSname,  Prefijo, Sector, earfcnDL, Banda, MRBTS_id,  Estado, Region, Depto, Mun,
LocalidadCRC, Cluster
FROM temptable
WHERE AvgRWTP > -90 AND Last_AvgRWTP > -90 AND Region = 'NOROCCIDENTE'
ORDER BY Last_AvgRWTP DESC
LIMIT 40;
--
DROP TABLE IF EXISTS rtwp7daylport;
CREATE TABLE rtwp7daylport AS
SELECT
PLMN_id, LNBTSname, LNBTS_id, LNCELname, LNCEL_id, AvgRWTP, AVG_DiffRWTP, AVG_PortMeas, Last_AVG_PortMeas, AvgRWTP1, AvgRWTP2, AvgRWTP3, AvgRWTP4,
AvgUEdist, AVG_DL_PRB, AVG_Data_VolMb, AVG_RRC_Users_Max, MRBTSname,  Prefijo, Sector, earfcnDL, Banda, MRBTS_id,  Estado, Region, Depto, Mun,
LocalidadCRC, Cluster
FROM temptable
WHERE (AVG_PortMeas % 2) != 0 AND (Last_AVG_PortMeas % 2) != 0 AND Region = 'NOROCCIDENTE'
ORDER BY LNCELname;
--
DROP TABLE IF EXISTS rtwp7dayldif;
CREATE TABLE rtwp7dayldif AS
SELECT
PLMN_id, LNBTSname, LNBTS_id, LNCELname, LNCEL_id, AvgRWTP, AVG_PortMeas, AVG_DiffRWTP, Last_AVG_DiffRWTP, AvgRWTP1, AvgRWTP2, AvgRWTP3, AvgRWTP4, AvgUEdist, AVG_DL_PRB, AVG_Data_VolMb,
AVG_RRC_Users_Max, MRBTSname,  Prefijo, Sector, earfcnDL, Banda, MRBTS_id,  Estado, Region, Depto, Mun,
LocalidadCRC, Cluster
FROM temptable
WHERE AVG_DiffRWTP > 3 AND Last_AVG_DiffRWTP > 3 AND Region = 'NOROCCIDENTE'
ORDER BY Last_AVG_DiffRWTP DESC
LIMIT 40;
--
DROP TABLE IF EXISTS rwtplofdr;
CREATE TABLE rwtplofdr AS
SELECT
LNCELname, AVG_RRC_Users_Max, AvgRWTP, AVG_DiffRWTP, Last_AvgRWTP, Last_AVG_PortMeas, Last_AVG_DiffRWTP
FROM temptable
WHERE Region = 'NOROCCIDENTE'
ORDER BY Last_AvgRWTP DESC;
--
DROP TABLE IF EXISTS rwtpf7dayl;
CREATE TABLE rwtpf7dayl AS
SELECT
LNCELname, AvgUEdist, AVG_DL_PRB, AVG_Data_VolMb, AVG_RRC_Users_Max, AvgRWTP,
AVG_PortMeas, AVG_DiffRWTP, Last_AvgRWTP, Last_AVG_PortMeas, Last_AVG_DiffRWTP
FROM temptable
WHERE Region = 'NOROCCIDENTE'
ORDER BY Last_AvgRWTP DESC;
--
--
-- end of week info
--
