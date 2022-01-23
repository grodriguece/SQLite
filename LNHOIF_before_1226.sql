--
-- LNCEL LNHOIF combinations FROM 9560 TO 626
--
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_626;
CREATE TABLE LNCEL_LNHOIF9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_626;
CREATE TABLE LNCEL_LNHOIF3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_626;
CREATE TABLE LNCEL_LNHOIF3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_651;
CREATE TABLE LNCEL_LNHOIF9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_651;
CREATE TABLE LNCEL_LNHOIF3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_651;
CREATE TABLE LNCEL_LNHOIF3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF626_9560;
CREATE TABLE LNCEL_LNHOIF626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF651_9560;
CREATE TABLE LNCEL_LNHOIF651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_9560;
CREATE TABLE LNCEL_LNHOIF3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_9560;
CREATE TABLE LNCEL_LNHOIF3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF626_3225;
CREATE TABLE LNCEL_LNHOIF626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF651_3225;
CREATE TABLE LNCEL_LNHOIF651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_3225;
CREATE TABLE LNCEL_LNHOIF9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_3225;
CREATE TABLE LNCEL_LNHOIF3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF626_3075;
CREATE TABLE LNCEL_LNHOIF626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF651_3075;
CREATE TABLE LNCEL_LNHOIF651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_3075;
CREATE TABLE LNCEL_LNHOIF9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_3075;
CREATE TABLE LNCEL_LNHOIF3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
DROP TABLE IF EXISTS LNCEL_LNHOIF_FULL;
CREATE TABLE LNCEL_LNHOIF_FULL AS
SELECT * FROM LNCEL_LNHOIF626_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF626_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF626_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
DROP TABLE IF EXISTS LNHOIF_Miss;
CREATE TABLE LNHOIF_Miss AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.eutraCarrierInfo,L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq
FROM LNCEL_LNHOIF_Full AS L LEFT JOIN LNHOIF_ref AS I ON ((L.PLMN_id = I.PLMN_id) AND (L.MRBTS_id = I.MRBTS_id) AND (L.LNBTS_id = I.LNBTS_id) AND (L.LNCEL_id = I.LNCEL_id) AND (L.eutraCarrierInfo = I.eutraCarrierInfo))
WHERE I.eutraCarrierInfo IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
--
--
--
--
-- LNHOIF AUDIT WITHOUT ID
--
DROP TABLE IF EXISTS LNHOIF_651_626;
CREATE TABLE LNHOIF_651_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
--
--
DROP TABLE IF EXISTS LNHOIF_9560_626;
CREATE TABLE LNHOIF_9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_626;
CREATE TABLE LNHOIF_3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_626;
CREATE TABLE LNHOIF_3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_651;
CREATE TABLE LNHOIF_626_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_651;
CREATE TABLE LNHOIF_9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_651;
CREATE TABLE LNHOIF_3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_651;
CREATE TABLE LNHOIF_3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_9560;
CREATE TABLE LNHOIF_626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_9560;
CREATE TABLE LNHOIF_651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_9560;
CREATE TABLE LNHOIF_3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_9560;
CREATE TABLE LNHOIF_3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_3075;
CREATE TABLE LNHOIF_626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_3075;
CREATE TABLE LNHOIF_651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_3075;
CREATE TABLE LNHOIF_9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_3075;
CREATE TABLE LNHOIF_3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_3225;
CREATE TABLE LNHOIF_626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_3225;
CREATE TABLE LNHOIF_651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_3225;
CREATE TABLE LNHOIF_9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_3225;
CREATE TABLE LNHOIF_3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
