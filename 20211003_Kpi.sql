-- UMTS
--
-- NQI_wk
--
DROP TABLE IF EXISTS uweek;
CREATE TABLE uweek AS
SELECT
w.PLMN_id, w.Prefijo, w.UARFCN, w.Banda, w.Region, w.Depto, w.Mun, w.LocalidadCRC, w.Cluster,
r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid, AVG(r.AvgRTWP) AS AvgRTWP, AVG(r.CStrafficErl) AS AvgCS_ERL,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-7 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE)
GROUP BY r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid
ORDER BY MAX(AvgRTWP) DESC;
--
--
--
-- Offender info start
--
-- Avail_Count <95%
--
DROP TABLE IF EXISTS Avail_Count;
CREATE TABLE Avail_Count AS
SELECT
r.WCELname, Count(r.CellAvail) AS Avail_Cnt
FROM UMTS r
WHERE (Day > (SELECT DATETIME('now', '-8 day')) and r.CellAvail<95 AND r.dendenied IS NOT NULL)
GROUP BY r.WCELname
ORDER BY Avail_Cnt DESC
;
--
-- Avail for latest day
--
DROP TABLE IF EXISTS Avail_Lst;
CREATE TABLE Avail_Lst AS
SELECT
r.WCELname, r.CellAvail AS AvailLast
FROM UMTS r
WHERE Day > (SELECT DATETIME('now', '-2 day'))
;
--
-- latest avail <97, count LT95% > 1, avg avail <95
--
DROP TABLE IF EXISTS Avail_Rural;
CREATE TABLE Avail_Rural AS
SELECT
w.Cluster, r.WCELname, AVG(r.CellAvail) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast
FROM ((UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.WCELname = a.WCELname) LEFT JOIN Avail_Lst l ON r.WCELname = l.WCELname
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS' OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN')
AND l.AvailLast < 97)
GROUP BY r.WCELname
HAVING Avail_Days_LT95 IS NOT NULL AND Avg_Cell_Avail < 95
ORDER BY Avg_Cell_Avail
;
--
DROP TABLE IF EXISTS Avail_Urban;
CREATE TABLE Avail_Urban AS
SELECT
w.Cluster, r.WCELname, AVG(r.CellAvail) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast
FROM ((UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.WCELname = a.WCELname) LEFT JOIN Avail_Lst l ON r.WCELname = l.WCELname
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER' OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB')
AND l.AvailLast < 97)
GROUP BY r.WCELname
HAVING Avail_Days_LT95 IS NOT NULL AND Avg_Cell_Avail < 95
ORDER BY Avg_Cell_Avail
;
--
-- worst 30 cells for ACDL
--
DROP TABLE IF EXISTS Pwr_Fail_Rural;
CREATE TABLE Pwr_Fail_Rural AS
SELECT
w.Cluster, r.WCELname, AVG(r.RRCCONN_STPFL_AC_DL) AS Avg_FL_ACDL, AVG(r.denied_hsdpa) AS Avg_HSDPA_Denied,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach,
AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability, w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.WCELname
ORDER BY Avg_FL_ACDL DESC
Limit 30;
--
DROP TABLE IF EXISTS Pwr_Fail_Urban;
CREATE TABLE Pwr_Fail_Urban AS
SELECT
w.Cluster, r.WCELname, AVG(r.RRCCONN_STPFL_AC_DL) AS Avg_FL_ACDL, AVG(r.denied_hsdpa) AS Avg_HSDPA_Denied,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach,
AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability, w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.WCELname
ORDER BY Avg_FL_ACDL DESC
Limit 30;
--
-- worst 30 Denied_HS cells having num_acc_hsdpa > 100 and AvgMaxHSDPAusers >5
--
DROP TABLE IF EXISTS Denied_HS_Rural;
CREATE TABLE Denied_HS_Rural AS
SELECT
w.Cluster, r.WCELname, AVG(r.denied_hsdpa) AS Avg_HSDPA_Denied, AVG(r.num_access_hsdpa) AS num_acc_hsdpa,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach,
AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability, w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.WCELname
HAVING  num_acc_hsdpa > 100 and AvgMaxHSDPAusers >5
ORDER BY Avg_HSDPA_Denied DESC
Limit 30;
--
DROP TABLE IF EXISTS Denied_HS_Urban;
CREATE TABLE Denied_HS_Urban AS
SELECT
w.Cluster, r.WCELname, AVG(r.denied_hsdpa) AS Avg_HSDPA_Denied, AVG(r.num_access_hsdpa) AS num_acc_hsdpa,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach,
AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability, w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.WCELname
HAVING  num_acc_hsdpa > 100 and AvgMaxHSDPAusers >5
ORDER BY Avg_HSDPA_Denied DESC
Limit 30;
--
-- worst 30 Acc_CS cells having num_denied_CS > 1000
--
DROP TABLE IF EXISTS Acc_CS;
DROP TABLE IF EXISTS Acc_CS_Rural;
CREATE TABLE Acc_CS_Rural AS
SELECT
w.Cluster, r.WCELname, 100*AVG(r.numdenied/r.dendenied) AS Avg_Acc_CS, AVG(r.numdenied) AS num_denied_CS,
AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability,
w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.WCELname
HAVING  num_denied_CS > 1000
ORDER BY Avg_Acc_CS
Limit 30;
--
DROP TABLE IF EXISTS Acc_CS_Urban;
CREATE TABLE Acc_CS_Urban AS
SELECT
w.Cluster, r.WCELname, 100*AVG(r.numdenied/r.dendenied) AS Avg_Acc_CS, AVG(r.numdenied) AS num_denied_CS,
AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability,
w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.WCELname
HAVING  num_denied_CS > 1000
ORDER BY Avg_Acc_CS
Limit 30;
--
-- worst 30 Drop_CS cells having num_drop_CS > 10
DROP TABLE IF EXISTS Drop_CS_Rural;
CREATE TABLE Drop_CS_Rural AS
SELECT
w.Cluster, r.WCELname, 100*AVG(r.numdrop/r.dendrop) AS Avg_Drop_CS, AVG(r.numdrop) AS num_drop_CS,
AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability,
w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.WCELname
HAVING  num_drop_CS > 10
ORDER BY Avg_Drop_CS DESC
Limit 30;
--
DROP TABLE IF EXISTS Drop_CS_Urban;
CREATE TABLE Drop_CS_Urban AS
SELECT
w.Cluster, r.WCELname, 100*AVG(r.numdrop/r.dendrop) AS Avg_Drop_CS, AVG(r.numdrop) AS num_drop_CS,
AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx, w.MaxDLPowerCapability,
w.PtxCellMax, w.PtxPrimaryCPICH
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.WCELname
HAVING  num_drop_CS > 10
ORDER BY Avg_Drop_CS DESC
Limit 30;
--
-- End of offender info
--
--
--
