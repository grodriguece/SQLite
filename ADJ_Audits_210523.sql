CREATE INDEX umts_kpi ON UMTS (Period_start_time, MRBTSname, LNCELname);


SELECT
AnilloRF, Sitio, WCEL_Name, FechaEstimada, DATE('1899-12-30', ('+' ||Ejecucion|| ' day')) AS Ejecucion, Sector
FROM WCEL_PARAM2;

DROP TABLE IF EXISTS wcelrefarcomb;
CREATE TABLE wcelrefarcomb AS
SELECT DISTINCT
w1.AnilloRF, w1.Sitio, w1.WCEL_Name, w1.FechaEstimada, DATE('1899-12-30', ('+' ||w1.Ejecucion|| ' day')) AS Ejecucion, w1.Sector,
w1.WCEL_Name AS Source, w4.CellDN AS targetcelldn, w3.WCEL_Name AS Target, w2.version, a.ADJI_id 
FROM ((WCEL_PARAM2 w1 INNER JOIN WCEL_PARAM1 w2 ON w1.WCEL_Name = w2.WCELName) 
LEFT JOIN WCEL_PARAM2 w3 INNER JOIN WCEL_PARAM1 w4 ON w3.WCEL_Name = w4.WCELName)
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w2.RNC_id = a.RNC_id AND w2.CId = a.WCEL_id 
WHERE (w2.WBTSName = w4.WBTSName) AND (w2.WCELName <> w4.WCELName) AND w2.UARFCN <> 9685 AND w4.UARFCN <> 9685 
AND (w2.UARFCN <> w4.UARFCN) AND a.ADJI_id ISNULL
ORDER BY w1.Ejecucion IS NULL OR w1.Ejecucion='', w1.Ejecucion, w1.WCEL_Name; 


DROP TABLE IF EXISTS adjicustom;
CREATE TABLE adjicustom AS
SELECT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w1.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID, W.WCDMACellReselection, W.LTECellReselection, W.GSMCellReselection, W.QqualMin, W.QrxlevMin, W.AbsPrioCellReselec, 
W.RACHInterFreqMesQuant, W.BlindHORSCPThrTarget, W.BlindHOEcNoThrTarget, W.Sprioritysearch1, W.Sprioritysearch2, W.Threshservlow, W.Threshservlow2,
i.moVersion,i.distName,i.PLMN_id,i.RNC_id,i.WBTS_id,i.WCEL_id,i.ADJI_id,i.AdjiMCC,i.AdjiMNC,i.TargetCellDN,i.name,
i.AdjiCI,i.AdjiCPICHTxPwr,i.AdjiComLoadMeasDRNCCellNCHO,i.AdjiEcNoOffsetNCHO,
i.AdjiHandlingBlockedCellSLHO,i.AdjiLAC,i.AdjiNCHOHSPASupport,i.AdjiRAC,i.AdjiRNCid,i.AdjiSIB,i.AdjiScrCode,
i.AdjiTxDiv,i.AdjiTxPwrDPCH,i.AdjiTxPwrRACH,i.AdjiUARFCN,i.BlindHOTargetCell,i.NrtHopiIdentifier,i.RtHopiIdentifier,w.UARFCN AS uarfcns,
w1.UARFCN AS uarfcnt, 
h1.AdjiAbsPrioCellReselec AS AdjiAbsPrioCellReselecRT, h1.AdjiEcNoMargin AS AdjiEcNoMarginRT, h1.AdjiMinEcNo AS  AdjiMinEcNoRT, 
h1.AdjiMinRSCP AS AdjiMinRSCPRT, h1.AdjiQoffset1 AS AdjiQoffset1RT, h1.AdjiQoffset2 AS AdjiQoffset2RT, h1.AdjiQqualMin AS AdjiQqualMinRT,
h1.AdjiQrxlevMin AS AdjiQrxlevMinRT, h1.AdjiThreshigh AS AdjiThreshighRT, h1.AdjiThreslow AS AdjiThreslowRT, h1.BlindHORSCPThr AS BlindHORSCPThrRT, 
h2.AdjiAbsPrioCellReselec AS AdjiAbsPrioCellReselecNRT, h2.AdjiEcNoMargin AS AdjiEcNoMarginNRT, h2.AdjiMinEcNo AS AdjiMinEcNoNRT, 
h2.AdjiMinRSCP AS AdjiMinRSCPNRT, h2.AdjiQoffset1 AS AdjiQoffset1NRT, h2.AdjiQoffset2 AS AdjiQoffset2NRT, h2.AdjiQqualMin AS AdjiQqualMinNRT, 
h2.AdjiQrxlevMin AS AdjiQrxlevMinNRT, h2.AdjiThreshigh AS AdjiThreshighNRT, h2.AdjiThreslow AS AdjiThreslowNRT, h2.BlindHORSCPThr AS BlindHORSCPThrNRT
FROM (((ADJI i LEFT JOIN WCEL_PARAM1 w ON (i.RNC_id = w.RNC_id AND i.WBTS_id = w.WBTS_id AND i.WCEL_id = w.WCEL_id))
LEFT JOIN WCEL_PARAM1 w1 ON (i.TargetCellDN = w1.CellDN)) LEFT JOIN HOPI h1 ON (i.RNC_id= h1.RNC_id AND i.RtHopiIdentifier = h1.HOPI_id))
LEFT JOIN HOPI h2 ON (i.RNC_id= h2.RNC_id AND i.NrtHopiIdentifier = h2.HOPI_id)
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;


DROP TABLE IF EXISTS adjicombifull;
CREATE TABLE adjicombi AS
SELECT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w4.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID, w4.WCELName AS Target, w.UARFCN, w4.UARFCN AS UARFCNT
w4.CellDN AS targetcelldn, w.version, a.ADJI_id 
FROM (WCEL_PARAM1 w INNER JOIN WCEL_PARAM1 w4 ON w.WBTSName = w4.WBTSName COLLATE NOCASE) 
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w.RNC_id = a.RNC_id AND w.CId = a.WCEL_id 
WHERE (w.WBTSName = w4.WBTSName COLLATE NOCASE) AND (w.WCELName <> w4.WCELName) AND w.UARFCN <> w4.UARFCN AND a.ADJI_id ISNULL
ORDER BY w1.Ejecucion IS NULL OR w1.Ejecucion='', w1.Ejecucion, w1.WCEL_Name; 




DROP TABLE IF EXISTS hopicustom;
CREATE TABLE hopicustom AS
SELECT
*
FROM hopi;






DROP TABLE IF EXISTS adjicustom;
CREATE TABLE adjicustom AS
SELECT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w1.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID, W.WCDMACellReselection, W.LTECellReselection, W.GSMCellReselection, W.QqualMin, W.QrxlevMin, W.AbsPrioCellReselec, 
W.RACHInterFreqMesQuant, W.BlindHORSCPThrTarget, W.BlindHOEcNoThrTarget, W.Sprioritysearch1, W.Sprioritysearch2, W.Threshservlow, W.Threshservlow2,
i.moVersion,i.distName,i.PLMN_id,i.RNC_id,i.WBTS_id,i.WCEL_id,i.ADJI_id,i.AdjiMCC,i.AdjiMNC,i.TargetCellDN,i.name,
i.AdjiCI,i.AdjiCPICHTxPwr,i.AdjiComLoadMeasDRNCCellNCHO,i.AdjiEcNoOffsetNCHO,
i.AdjiHandlingBlockedCellSLHO,i.AdjiLAC,i.AdjiNCHOHSPASupport,i.AdjiRAC,i.AdjiRNCid,i.AdjiSIB,i.AdjiScrCode,
i.AdjiTxDiv,i.AdjiTxPwrDPCH,i.AdjiTxPwrRACH,i.AdjiUARFCN,i.BlindHOTargetCell,i.NrtHopiIdentifier,i.RtHopiIdentifier,w.UARFCN AS uarfcns,
w1.UARFCN AS uarfcnt, 
h1.AdjiAbsPrioCellReselec AS AdjiAbsPrioCellReselecRT, h1.AdjiEcNoMargin AS AdjiEcNoMarginRT, h1.AdjiMinEcNo AS  AdjiMinEcNoRT, 
h1.AdjiMinRSCP AS AdjiMinRSCPRT, h1.AdjiQoffset1 AS AdjiQoffset1RT, h1.AdjiQoffset2 AS AdjiQoffset2RT, h1.AdjiQqualMin AS AdjiQqualMinRT,
h1.AdjiQrxlevMin AS AdjiQrxlevMinRT, h1.AdjiThreshigh AS AdjiThreshighRT, h1.AdjiThreslow AS AdjiThreslowRT, h1.BlindHORSCPThr AS BlindHORSCPThrRT, 
h2.AdjiAbsPrioCellReselec AS AdjiAbsPrioCellReselecNRT, h2.AdjiEcNoMargin AS AdjiEcNoMarginNRT, h2.AdjiMinEcNo AS AdjiMinEcNoNRT, 
h2.AdjiMinRSCP AS AdjiMinRSCPNRT, h2.AdjiQoffset1 AS AdjiQoffset1NRT, h2.AdjiQoffset2 AS AdjiQoffset2NRT, h2.AdjiQqualMin AS AdjiQqualMinNRT, 
h2.AdjiQrxlevMin AS AdjiQrxlevMinNRT, h2.AdjiThreshigh AS AdjiThreshighNRT, h2.AdjiThreslow AS AdjiThreslowNRT, h2.BlindHORSCPThr AS BlindHORSCPThrNRT
FROM (((ADJI i LEFT JOIN WCEL_PARAM1 w ON (i.RNC_id = w.RNC_id AND i.WBTS_id = w.WBTS_id AND i.WCEL_id = w.WCEL_id))
LEFT JOIN WCEL_PARAM1 w1 ON (i.TargetCellDN = w1.CellDN)) LEFT JOIN HOPI h1 ON (i.RNC_id= h1.RNC_id AND i.RtHopiIdentifier = h1.HOPI_id))
LEFT JOIN HOPI h2 ON (i.RNC_id= h2.RNC_id AND i.NrtHopiIdentifier = h2.HOPI_id)
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;
--
--
DROP TABLE IF EXISTS adjicustom1;
CREATE TABLE adjicustom1 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc1';
--
DROP TABLE IF EXISTS adjicustom2;
CREATE TABLE adjicustom2 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc2';
--
DROP TABLE IF EXISTS adjicustom7;
CREATE TABLE adjicustom7 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc7';
--
DROP TABLE IF EXISTS adjicustom8;
CREATE TABLE adjicustom8 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc8';
--
DROP TABLE IF EXISTS adjicustom9;
CREATE TABLE adjicustom9 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc9';
--
DROP TABLE IF EXISTS adjicustom10;
CREATE TABLE adjicustom10 AS
SELECT *
FROM adjicustom
WHERE adjicustom.PLMN_id = 'rc10';
--
--
DROP TABLE IF EXISTS adjicombifull;
CREATE TABLE adjicombifull AS
SELECT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w4.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID, w4.WCELName AS Target, w.UARFCN, w4.UARFCN AS UARFCNT,
w4.CellDN AS targetcelldn, w.version, a.ADJI_id 
FROM (WCEL_PARAM1 w INNER JOIN WCEL_PARAM1 w4 ON w.WBTSName = w4.WBTSName COLLATE NOCASE) 
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w.RNC_id = a.RNC_id AND w.CId = a.WCEL_id 
WHERE (w.WBTSName = w4.WBTSName COLLATE NOCASE) AND (w.WCELName <> w4.WCELName) AND w.UARFCN <> w4.UARFCN AND a.ADJI_id ISNULL 
AND w.Cluster = 'Envigado' COLLATE NOCASE
ORDER BY w.Region, w.Cluster, w.WBTSName, w.WCELName; 
--
--
-- 4 carrier scenario
DROP TABLE IF EXISTS adjicombi2;
CREATE TABLE adjicombi2 AS
SELECT
w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.RNCName, w.Banda, w4.Banda AS Bandat, w.Sector, w.WBTSName,
w.SectorID,  w.UARFCN, w4.UARFCN AS UARFCNT, w.RNC_id AS SourceRncId, 732 AS SourceMCC, 101 AS SourceMNC, 
w.CId AS SourceCI, w.WCELName AS name, w4.CellDN AS TargetCellDN, w4.WCELName AS Target, w.version, a.ADJI_id 
FROM (WCEL_PARAM1 w INNER JOIN WCEL_PARAM1 w4 ON w.WBTSName = w4.WBTSName COLLATE NOCASE) 
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w.RNC_id = a.RNC_id AND w.CId = a.WCEL_id 
WHERE (w.WBTSName = w4.WBTSName COLLATE NOCASE) AND (w.WCELName <> w4.WCELName) AND w.UARFCN <> w4.UARFCN AND
((w.UARFCN = 4387 AND w4.UARFCN = 9685) OR (w.UARFCN = 9685 AND w4.UARFCN = 4387) OR
(w.UARFCN = 4364 AND w4.UARFCN = 9712) OR (w.UARFCN = 9712 AND w4.UARFCN = 4364)) AND
a.ADJI_id ISNULL
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;
--
-- same band scenario
DROP TABLE IF EXISTS adjicombis;
CREATE TABLE adjicombis AS
SELECT
w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.RNCName, w.Banda, w4.Banda AS Bandat, w.Sector, w.WBTSName,
w.SectorID,  w.UARFCN, w4.UARFCN AS UARFCNT, w.RNC_id AS SourceRncId, 732 AS SourceMCC, 101 AS SourceMNC, 
w.CId AS SourceCI, w.WCELName AS name, w4.CellDN AS TargetCellDN, w4.WCELName AS Target, w.version, a.ADJI_id 
FROM (WCEL_PARAM1 w INNER JOIN WCEL_PARAM1 w4 ON w.WBTSName = w4.WBTSName COLLATE NOCASE) 
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w.RNC_id = a.RNC_id AND w.CId = a.WCEL_id 
WHERE (w.WBTSName = w4.WBTSName COLLATE NOCASE) AND (w.WCELName <> w4.WCELName) AND w.UARFCN <> w4.UARFCN AND
((w.UARFCN = 4387 AND w4.UARFCN = 4364) OR (w.UARFCN = 4364 AND w4.UARFCN = 4387) OR
(w.UARFCN = 9685 AND w4.UARFCN = 9712) OR (w.UARFCN = 9712 AND w4.UARFCN = 9685)) AND
a.ADJI_id ISNULL
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName; 
--


ATTACH DATABASE 'c:\sqlite\20210614_sqlite.dba' AS 'db0614';

DROP TABLE IF EXISTS dB0614.adjicusto;
CREATE TABLE dB0614.adjicusto AS
SELECT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w1.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID,i.moVersion,i.distName,i.PLMN_id,i.RNC_id,i.WBTS_id,i.WCEL_id,i.ADJI_id,i.AdjiMCC,i.AdjiMNC,i.TargetCellDN,i.name,
i.AdjiCI,i.AdjiCPICHTxPwr,i.AdjiComLoadMeasDRNCCellNCHO,i.AdjiEcNoOffsetNCHO,
i.AdjiHandlingBlockedCellSLHO,i.AdjiLAC,i.AdjiNCHOHSPASupport,i.AdjiRAC,i.AdjiRNCid,i.AdjiSIB,i.AdjiScrCode,
i.AdjiTxDiv,i.AdjiTxPwrDPCH,i.AdjiTxPwrRACH,i.AdjiUARFCN,i.BlindHOTargetCell,i.NrtHopiIdentifier,i.RtHopiIdentifier,w.UARFCN AS uarfcns,
w1.UARFCN AS uarfcnt
FROM (dB0614.ADJI i LEFT JOIN WCEL_PARAM1 w ON (i.RNC_id = w.RNC_id AND i.WBTS_id = w.WBTS_id AND i.WCEL_id = w.WCEL_id))
LEFT JOIN WCEL_PARAM1 w1 ON (i.TargetCellDN = w1.CellDN)
WHERE w.WBTSName = 'ANT.Urrao' COLLATE NOCASE OR w1.WBTSName = 'ANT.Urrao' COLLATE NOCASE
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;






