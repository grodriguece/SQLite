DROP TABLE IF EXISTS lweek1;
CREATE TABLE lweek1 AS
SELECT
r.Day, lp.PLMN_id, r.MRBTSname, r.LNBTSname, r.LNCELname, lp.Prefijo, lp.Sector, lp.earfcnDL, lp.Banda, lp.MRBTS_id, lp.LNBTS_id, lp.LNCEL_id,
lp.Estado, lp.Region, lp.Depto, lp.Mun, lp.LocalidadCRC, lp.Cluster,
1.0*r.SAMPLES_CELL_AVAIL/(CASE WHEN 1.0*r.DENOM_CELL_AVAIL = 0 THEN 1 ELSE 1.0*r.DENOM_CELL_AVAIL END) AS CELL_AVAIL,
r.RACH_STP_COMPLETIONS/(CASE WHEN (r.RACH_STP_ATT_SMALL_MSG + r.RACH_STP_ATT_LARGE_MSG + r.RACH_STP_ATT_DEDICATED) = 0 THEN 1
ELSE (r.RACH_STP_ATT_SMALL_MSG + r.RACH_STP_ATT_LARGE_MSG + r.RACH_STP_ATT_DEDICATED) END) AS RACH_SR,
(r.IP_TPUT_VOL_DL_QCI_5 + r.IP_TPUT_VOL_DL_QCI_6 + r.IP_TPUT_VOL_DL_QCI_7 + r.IP_TPUT_VOL_DL_QCI_8 + r.IP_TPUT_VOL_DL_QCI_9)/
(CASE WHEN (r.IP_TPUT_TIME_DL_QCI_5 + r.IP_TPUT_TIME_DL_QCI_6 + r.IP_TPUT_TIME_DL_QCI_7 + r.IP_TPUT_TIME_DL_QCI_8 + r.IP_TPUT_TIME_DL_QCI_9) = 0 THEN 1
ELSE (r.IP_TPUT_TIME_DL_QCI_5 + r.IP_TPUT_TIME_DL_QCI_6 + r.IP_TPUT_TIME_DL_QCI_7 + r.IP_TPUT_TIME_DL_QCI_8 + r.IP_TPUT_TIME_DL_QCI_9) END)
AS Usr_thr_DL_kbps,
r.AVG_RTWP_RX_ANT_1/10 AS RTWP1, r.AVG_RTWP_RX_ANT_2/10 AS RTWP2,
r.AVG_RTWP_RX_ANT_3/10 AS RTWP3, r.AVG_RTWP_RX_ANT_4/10 AS RTWP4, r.AvgUEdistance,
(10*DL_PRB_UTIL_TTI_LEVEL_1+20*DL_PRB_UTIL_TTI_LEVEL_2+30*DL_PRB_UTIL_TTI_LEVEL_3+40*DL_PRB_UTIL_TTI_LEVEL_4+50*DL_PRB_UTIL_TTI_LEVEL_5+
60*DL_PRB_UTIL_TTI_LEVEL_6+70*DL_PRB_UTIL_TTI_LEVEL_7+80*DL_PRB_UTIL_TTI_LEVEL_8+90*DL_PRB_UTIL_TTI_LEVEL_9+100*DL_PRB_UTIL_TTI_LEVEL_10) /
(CASE WHEN (DL_PRB_UTIL_TTI_LEVEL_1 + DL_PRB_UTIL_TTI_LEVEL_2 + DL_PRB_UTIL_TTI_LEVEL_3 + DL_PRB_UTIL_TTI_LEVEL_4 + DL_PRB_UTIL_TTI_LEVEL_5 +
DL_PRB_UTIL_TTI_LEVEL_6 + DL_PRB_UTIL_TTI_LEVEL_7 + DL_PRB_UTIL_TTI_LEVEL_8 + DL_PRB_UTIL_TTI_LEVEL_9 + DL_PRB_UTIL_TTI_LEVEL_10) = 0
THEN 1
ELSE (DL_PRB_UTIL_TTI_LEVEL_1 + DL_PRB_UTIL_TTI_LEVEL_2 + DL_PRB_UTIL_TTI_LEVEL_3 + DL_PRB_UTIL_TTI_LEVEL_4 + DL_PRB_UTIL_TTI_LEVEL_5 +
DL_PRB_UTIL_TTI_LEVEL_6 + DL_PRB_UTIL_TTI_LEVEL_7 + DL_PRB_UTIL_TTI_LEVEL_8 + DL_PRB_UTIL_TTI_LEVEL_9 + DL_PRB_UTIL_TTI_LEVEL_10)
END) AS DL_PRB,
r.PDCP_SDU_VOL_DL/1000000 AS Data_VolMb, r.RRC_CONNECTED_UE_MAX
FROM LTE r LEFT JOIN lte_param lp ON r.LNCELname =lp.LNCELname COLLATE NOCASE
WHERE (r.Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND Region = 'NOROCCIDENTE');
--
DROP TABLE IF EXISTS lweek;
CREATE TABLE lweek AS
SELECT
r.PLMN_id, r.MRBTSname, r.LNBTSname, r.LNCELname, r.Prefijo, r.Sector, r.earfcnDL, r.Banda, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id,
r.Estado, r.Region, r.Depto, r.Mun, r.LocalidadCRC, r.Cluster,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.RACH_SR) AS AvgRACH_SR, AVG(r.Usr_thr_DL_kbps) AS AvgUsr_thr_DL_kbps,
AVG(r.RTWP1) AS AvgRTWP1, AVG(r.RTWP2) AS AvgRTWP2,
AVG(r.RTWP3) AS AvgRTWP3, AVG(r.RTWP4) AS AvgRTWP4, AVG(r.AvgUEdistance) AS AvgUEdist,
AVG(r.DL_PRB) AS AVG_DL_PRB, AVG(r.Data_VolMb) AS AVG_Data_VolMb, AVG(r.RRC_CONNECTED_UE_MAX) AS AVG_RRC_CONNECTED_UE_Max
FROM lweek1 r
GROUP BY r.MRBTSname, r.LNBTSname, r.LNCELname;
--
--
-- Offender info start
--
-- Avail_Count <95%
--
DROP TABLE IF EXISTS Avail_Count;
CREATE TABLE Avail_Count AS
SELECT
r.LNCELname, Count(r.CELL_AVAIL) AS Avail_Cnt
FROM lweek1 r
WHERE r.CELL_AVAIL<0.95
GROUP BY r.LNCELname
ORDER BY Avail_Cnt DESC
;
--
--
--
-- Avail for latest day
--
DROP TABLE IF EXISTS Avail_Lst;
CREATE TABLE Avail_Lst AS
SELECT
r.LNCELname, r.CELL_AVAIL AS AvailLast, r.AvgUEdistance AS AvgUEdistLast
FROM lweek1 r
WHERE Day > (SELECT DATETIME('now', '-2 day', 'localtime'))
;
--
-- Avail_full
--
--
DROP TABLE IF EXISTS Avail_AllL;
CREATE TABLE Avail_AllL AS
SELECT
w.Prefijo, w.Cluster, r.LNCELname, AVG(r.CELL_AVAIL) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast,
AVG(r.AvgUEdistance) AS AvgUEdist, l.AvgUEdistLast
FROM ((lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.LNCELname = a.LNCELname) LEFT JOIN Avail_Lst l ON r.LNCELname = l.LNCELname
WHERE Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
GROUP BY r.LNCELname;
--
-- Info two weeks before
--
DROP TABLE IF EXISTS Avail_2wkagoL;
CREATE TABLE Avail_2wkagoL AS
SELECT
w.Prefijo, w.Cluster, r.LNCELname, AVG(r.CELL_AVAIL) AS Avg_Cell_Avail, a.Avail_Cnt AS Avail_Days_LT95, l.AvailLast,
AVG(r.AvgUEdistance) AS AvgUEdist, l.AvgUEdistLast
FROM ((lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE)
LEFT JOIN Avail_Count a ON r.LNCELname = a.LNCELname) LEFT JOIN Avail_Lst l ON r.LNCELname = l.LNCELname
WHERE Day > (SELECT DATETIME('now', '-15 day', 'localtime')) AND Day < (SELECT DATETIME('now', '-7 day', 'localtime'))
AND a.Avail_Cnt > 1 AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE
GROUP BY r.LNCELname;
--
-- latest avail <97, count LT95% > 1, avg avail <95
--
DROP TABLE IF EXISTS Avail_Rural;
CREATE TABLE Avail_Rural AS
SELECT
r.Cluster, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist, r.AvgUEdistLast
FROM Avail_AllL r
WHERE (r.Prefijo = 'ANT' OR r.Prefijo = 'RIS' OR r.Prefijo = 'CAD' OR r.Prefijo = 'CHO' OR r.Prefijo = 'QUI' OR r.Prefijo = 'CUN')
AND r.AvailLast < 0.97 AND r.Avail_Days_LT95 IS NOT NULL AND r.Avg_Cell_Avail < 0.95
ORDER BY Avg_Cell_Avail;
--
DROP TABLE IF EXISTS Avail_Urban;
CREATE TABLE Avail_Urban AS
SELECT
r.Cluster, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist, r.AvgUEdistLast
FROM Avail_AllL r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.AvailLast < 0.97 AND r.Avail_Days_LT95 IS NOT NULL AND r.Avg_Cell_Avail < 0.95
ORDER BY Avg_Cell_Avail;
--
--
DROP TABLE IF EXISTS UEdist_Delta;
CREATE TABLE UEdist_Delta AS
SELECT
r.Cluster, r.Prefijo, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist AS AvgUEdist2, l.AvgUEdist AS AvgUEdist1, r.AvgUEdistLast,
CASE WHEN r.AvgUEdist<>0 THEN abs(100*(r.AvgUEdist-l.AvgUEdist)/r.AvgUEdist) ELSE 0 END AS Delta_UEdist,
CASE WHEN (r.AvgUEdist-l.AvgUEdist) >0 THEN 0 ELSE 1 END AS Delta
FROM Avail_2wkagoL r INNER JOIN Avail_AllL l ON r.LNCELname = l.LNCELname COLLATE NOCASE;
--
DROP TABLE IF EXISTS UEdist_DeltaU;
CREATE TABLE UEdist_DeltaU AS
SELECT
r.Cluster, r.Prefijo, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist2, r.AvgUEdist1, r.AvgUEdistLast, round(r.Delta_UEdist,1) AS DeltaUEdist, r.Delta
FROM UEdist_Delta r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.Delta_UEdist > 10
ORDER BY DeltaUEdist DESC;
--
DROP TABLE IF EXISTS UEdist_DeltaR;
CREATE TABLE UEdist_DeltaR AS
SELECT
r.Cluster, r.Prefijo, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist2, r.AvgUEdist1, r.AvgUEdistLast, round(r.Delta_UEdist,1) AS DeltaUEdist, r.Delta
FROM UEdist_Delta r
WHERE (r.Prefijo = 'ANT' OR r.Prefijo = 'RIS' OR r.Prefijo = 'CAD' OR r.Prefijo = 'CHO' OR r.Prefijo = 'QUI' OR r.Prefijo = 'CUN')
AND r.Delta_UEdist > 10
ORDER BY DeltaUEdist DESC;
--
DROP TABLE IF EXISTS UEdist_GT1000U;
CREATE TABLE UEdist_GT1000U AS
SELECT
r.Cluster, r.Prefijo, r.LNCELname, r.Avg_Cell_Avail, r.Avail_Days_LT95, r.AvailLast,
r.AvgUEdist2, r.AvgUEdist1, r.AvgUEdistLast, round(r.Delta_UEdist,1) AS DeltaUEdist, r.Delta
FROM UEdist_Delta r
WHERE (r.Prefijo = 'MED' OR r.Prefijo = 'PER' OR r.Prefijo = 'MAN' OR r.Prefijo = 'ARM' OR r.Prefijo = 'QUB')
AND r.AvgUEdist1 > 1
ORDER BY r.AvgUEdist1 DESC;
--
--
--
--
-- worst 30 cells for RACH
--
DROP TABLE IF EXISTS RACH_Rural;
CREATE TABLE RACH_Rural AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.RACH_SR) AS AvgRACH_SR, AVG(r.AvgUEdistance) AS AvgUEdist,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY AvgRACH_SR
Limit 30;
--
--
DROP TABLE IF EXISTS RACH_Urban;
CREATE TABLE RACH_Urban AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.RACH_SR) AS AvgRACH_SR, AVG(r.AvgUEdistance) AS AvgUEdist,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY AvgRACH_SR
Limit 30;
--
-- worst 30 cells for TPUT
--
DROP TABLE IF EXISTS TPUT_Rural;
CREATE TABLE TPUT_Rural AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.Usr_thr_DL_kbps) AS Avg_UsrTput, AVG(r.AvgUEdistance) AS AvgUEdist,
AVG(r.DL_PRB) AS AVG_DL_PRB, AVG(r.RRC_CONNECTED_UE_MAX) AS AVG_RRC_CONNECTED_UE_Max,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY Avg_UsrTput
Limit 30;
--
--
DROP TABLE IF EXISTS TPUT_Urban;
CREATE TABLE TPUT_Urban AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.Usr_thr_DL_kbps) AS Avg_UsrTput, AVG(r.AvgUEdistance) AS AvgUEdist,
AVG(r.DL_PRB) AS AVG_DL_PRB, AVG(r.RRC_CONNECTED_UE_MAX) AS AVG_RRC_CONNECTED_UE_Max,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY Avg_UsrTput
Limit 30;
--
-- worst 30 cells for PRB
--
DROP TABLE IF EXISTS PRB_Rural;
CREATE TABLE PRB_Rural AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.Usr_thr_DL_kbps) AS Avg_UsrTput, AVG(r.AvgUEdistance) AS AvgUEdist,
AVG(r.DL_PRB) AS AVG_DL_PRB, AVG(r.RRC_CONNECTED_UE_MAX) AS AVG_RRC_CONNECTED_UE_Max,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'ANT' OR w.Prefijo = 'RIS'
OR w.Prefijo = 'CAD' OR w.Prefijo = 'CHO' OR w.Prefijo = 'QUI' OR w.Prefijo = 'CUN'))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY AVG_DL_PRB DESC
Limit 30;
--
--
DROP TABLE IF EXISTS PRB_Urban;
CREATE TABLE PRB_Urban AS
SELECT
w.Cluster, r.LNCELname,
AVG(r.CELL_AVAIL) AS AvgCELL_AVAIL, AVG(r.Usr_thr_DL_kbps) AS Avg_UsrTput, AVG(r.AvgUEdistance) AS AvgUEdist,
AVG(r.DL_PRB) AS AVG_DL_PRB, AVG(r.RRC_CONNECTED_UE_MAX) AS AVG_RRC_CONNECTED_UE_Max,
w.PowerBoost
FROM lweek1 r LEFT JOIN lte_param w ON r.LNCELname = w.LNCELname COLLATE NOCASE
WHERE (Day > (SELECT DATETIME('now', '-8 day', 'localtime')) AND w.Region = 'NOROCCIDENTE' COLLATE NOCASE AND (w.Prefijo = 'MED' OR w.Prefijo = 'PER'
OR w.Prefijo = 'MAN' OR w.Prefijo = 'ARM' OR w.Prefijo = 'QUB' ))
GROUP BY r.LNCELname
HAVING AvgCELL_AVAIL>0
ORDER BY AVG_DL_PRB DESC
Limit 30;
--
