-- UMTS
--
-- NQI_wk
--
DROP TABLE IF EXISTS uweek;
-- INCLUDES MAX OF MAXIMUM_PTXTOTAL/PTXCELLMAX Ratio
CREATE TABLE uweek AS
SELECT
w.PLMN_id, w.Prefijo, w.UARFCN, w.Banda, w.Region, w.Depto, w.Mun, w.LocalidadCRC, w.Cluster,
r.RNCname, r.WBTSname, r.WBTSid, r.WCELname, r.WCELid, AVG(r.AvgRTWP) AS AvgRTWP, AVG(r.CStrafficErl) AS AvgCS_ERL,
AVG(r.MaxSimultHSDPAusers) AS AvgMaxHSDPAusers , AVG(r.avgprachdelay) AS AvgPrach, AVG(r.MAXIMUM_PTXTOTAL) AS AvgMaxPtx,
100*(MAX(powp(10,r.MAXIMUM_PTXTOTAL/10.0)/1000)/(powp(10,w.PtxCellMax/100.0)/1000)) AS MaxPtxTotRatio, w.CpichPwrRatio,
w.PtxPrimaryCPICH, w.PtxCellMax, w.MaxDLPowerCapability, 10*log10p((powp(10,w.PtxPrimaryCPICH/100.0)/8)*100) AS PtxMax8
FROM UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-7 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE)
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) and r.CellAvail<95 AND r.dendenied IS NOT NULL)
GROUP BY r.WCELname
ORDER BY Avail_Cnt DESC
;
-- Avail for latest day
--
DROP TABLE IF EXISTS Avail_Lst;
CREATE TABLE Avail_Lst AS
SELECT
r.WCELname, r.CellAvail AS AvailLast, r.avgprachdelay AS AvgPrachLast
FROM UMTS r
WHERE Day > (SELECT DATETIME('now', '-2 day', 'localtime'));
--
DROP TABLE IF EXISTS Avail_All;
CREATE TABLE Avail_All AS
SELECT
w.Cluster, w.Prefijo, r.WCELname, AVG(r.CellAvail) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast, AVG(r.avgprachdelay) AS AvgPrach,
l.AvgPrachLast
FROM ((UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.WCELname = a.WCELname) LEFT JOIN Avail_Lst l ON r.WCELname = l.WCELname
WHERE Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
GROUP BY r.WCELname;
--
DROP TABLE IF EXISTS Avail_2wkago;
CREATE TABLE Avail_2wkago AS
SELECT
w.Cluster, w.Prefijo, r.WCELname, AVG(r.CellAvail) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast, AVG(r.avgprachdelay) AS AvgPrach,
l.AvgPrachLast
FROM ((UMTS r LEFT JOIN wcel_param w ON r.WCELname = w.WCELName COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.WCELname = a.WCELname) LEFT JOIN Avail_Lst l ON r.WCELname = l.WCELname
WHERE Day > (SELECT DATETIME('now', '-15 day', 'localtime')) AND Day < (SELECT DATETIME('now', '-7 day', 'localtime'))
AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
GROUP BY r.WCELname;
--
--
-- latest avail <97, count LT95% > 1, avg avail <95
--
DROP TABLE IF EXISTS Avail_Rural;
CREATE TABLE Avail_Rural AS
SELECT
r.Cluster, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach,
r.AvgPrachLast
FROM Avail_All r
WHERE (r.Prefijo = 'ANT' OR r.Prefijo = 'RIS' OR r.Prefijo = 'CAD' OR r.Prefijo = 'CHO' OR r.Prefijo = 'QUI' OR r.Prefijo = 'CUN')
AND r.AvailLast < 97 AND r.Avail_Days_LT95 IS NOT NULL AND r.Avg_Cell_Avail < 95
ORDER BY Avg_Cell_Avail;
--
DROP TABLE IF EXISTS Avail_Urban;
CREATE TABLE Avail_Urban AS
SELECT
r.Cluster, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach,
r.AvgPrachLast
FROM Avail_All r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.AvailLast < 97 AND r.Avail_Days_LT95 IS NOT NULL AND r.Avg_Cell_Avail < 95
ORDER BY Avg_Cell_Avail;
--
--
DROP TABLE IF EXISTS Prach_Delta;
CREATE TABLE Prach_Delta AS
SELECT
r.Cluster, r.Prefijo, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach AS AvgPrach2,
l.AvgPrach AS AvgPrach1, r.AvgPrachLast,
CASE WHEN r.AvgPrach<>0 THEN abs(100*(r.AvgPrach-l.AvgPrach)/r.AvgPrach) ELSE 0 END AS Delta_Prach,
CASE WHEN (r.AvgPrach-l.AvgPrach) >0 THEN 0 ELSE 1 END AS Delta
FROM Avail_2wkago r INNER JOIN Avail_All l ON r.WCELname = l.WCELName COLLATE NOCASE;
--
DROP TABLE IF EXISTS Prach_DeltaU;
CREATE TABLE Prach_DeltaU AS
SELECT
r.Cluster, r.Prefijo, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach2,
r.AvgPrach1, r.AvgPrachLast, round(r.Delta_Prach,1) AS DeltaPRACH, r.Delta
FROM Prach_Delta r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.Delta_Prach > 10
ORDER BY DeltaPRACH DESC;
--
DROP TABLE IF EXISTS Prach_GT1500U;
CREATE TABLE Prach_GT1500U AS
SELECT
r.Cluster, r.Prefijo, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach2,
r.AvgPrach1, r.AvgPrachLast, round(r.Delta_Prach,1) AS DeltaPRACH, r.Delta
FROM Prach_Delta r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.AvgPrach1 > 1500
ORDER BY r.AvgPrach1 DESC;
--
DROP TABLE IF EXISTS Prach_DeltaR;
CREATE TABLE Prach_DeltaR AS
SELECT
r.Cluster, r.Prefijo, r.WCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast, r.AvgPrach2,
r.AvgPrach1, r.AvgPrachLast, r.Delta_Prach, r.Delta
FROM Prach_Delta r
WHERE (r.Prefijo = 'ANT' OR r.Prefijo = 'RIS' OR r.Prefijo = 'CAD' OR r.Prefijo = 'CHO' OR r.Prefijo = 'QUI' OR r.Prefijo = 'CUN')
AND r.Delta_Prach > 10
ORDER BY r.Delta_PRACH DESC;
--
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND(w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
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
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.WCELname
HAVING  num_drop_CS > 10
ORDER BY Avg_Drop_CS DESC
Limit 30;
--
-- End of offender info
--
--
