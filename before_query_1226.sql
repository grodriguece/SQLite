--
--IRFIM custom
--
DROP TABLE IF EXISTS IRFIM_ref;
CREATE TABLE IRFIM_ref AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
IRFIM.IRFIM_id,IRFIM.moVersion,IRFIM.dlCarFrqEut,IRFIM.enableA4IMLB,IRFIM.eutCelResPrio,IRFIM.idleLBEutCelResPrio,IRFIM.idleLBEutCelResWeight,IRFIM.incMonExSel,IRFIM.interFrqThrH,IRFIM.interFrqThrL,IRFIM.interPresAntP,IRFIM.interTResEut,IRFIM.mbmsNeighCellConfigInterF,IRFIM.measBdw,IRFIM.minDeltaRsrpIMLB,IRFIM.minDeltaRsrqIMLB,IRFIM.minRsrpIMLB,IRFIM.minRsrqIMLB,IRFIM.qOffFrq,IRFIM.qRxLevMinInterF,IRFIM.reducedMeasPerformance,IRFIM.SBTS_id
FROM IRFIM LEFT JOIN LNCEL_Full AS L ON (IRFIM.PLMN_Id=L.PLMN_Id) AND (IRFIM.MRBTS_Id=L.MRBTS_Id) AND (IRFIM.LNBTS_Id=L.LNBTS_Id) AND (IRFIM.LNCEL_id=L.LNCEL_id);
--
--
--LNHOIF custom
DROP TABLE IF EXISTS LNHOIF_ref;
CREATE TABLE LNHOIF_ref AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, H.eutraCarrierInfo,
CASE WHEN H.eutraCarrierInfo BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 600 and 1199 THEN 1900
ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 2400 and 2649 THEN 850
ELSE NULL END)END)END)END AS BandaT,
H.PLMN_id, H.MRBTS_id, H.LNBTS_id, H.LNCEL_id, H.LNHOIF_id, H.moVersion,H.a3OffsetRsrpInterFreq,H.a3OffsetRsrpInterFreqQci1,
H.a3TimeToTriggerRsrpInterFreq,H.a5ReportIntervalInterFreq,H.a5TimeToTriggerInterFreq,H.a3ReportIntervalRsrpInterFreq,
H.hysA3OffsetRsrpInterFreq,H.hysThreshold3InterFreq,H.iFGroupPrio,H.interPresAntP,H.measQuantInterFreq,H.measurementBandwidth,
H.offsetFreqInter,H.threshold3InterFreq,H.threshold3InterFreqQci1,H.threshold3aInterFreq,H.threshold3aInterFreqQci1,
H.thresholdRsrpIFLBFilter,H.thresholdRsrpIFSBFilter,H.thresholdRsrqIFLBFilter,H.thresholdRsrqIFSBFilter,H.a3OffsetRsrqInterFreq,
H.a3ReportIntervalRsrqInterFreq,H.a3TimeToTriggerRsrqInterFreq,H.hysA3OffsetRsrqInterFreq,H.a3ReportAmountRsrpInterFreq,
H.a3ReportAmountRsrqInterFreq,H.a5ReportAmountRsrpInterFreq,H.a5ReportAmountRsrqInterFreq,H.SBTS_id,H.t312,H.a3OffsetRsrpInterFreqHpue,
H.a3OffsetRsrpInterFreqCatM,H.a3TimeToTriggerRsrpInterFreqCatM,H.hysA3OffsetRsrpInterFreqCatM,
H.reducedMeasPerf,H.threshold3InterFreqHpue,H.threshold3aInterFreqHpue,H.useT312,H.thresholdRsrpEndcFilt
FROM LNHOIF AS H LEFT JOIN LNCEL_Full AS L ON (H.PLMN_Id=L.PLMN_Id) AND (H.MRBTS_Id=L.MRBTS_Id) AND (H.LNBTS_Id=L.LNBTS_Id)
AND (H.LNCEL_id=L.LNCEL_id);
--
--
-- IRFIM AUDIT WITHOUT ID
--
--Q1 to 626
DROP TABLE IF EXISTS IRFIM_626AUD;
CREATE TABLE IRFIM_626AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 5 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 4 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 1 AS measBdw_N, -112 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -118 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 5 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 4 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 1 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -112 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -118 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=626 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>5 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>4 OR L.interPresAntP<>1 OR L.measBdw<>1 OR L.minRsrpIMLB<>-112 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-118);
--
--
--Q2 to 651
DROP TABLE IF EXISTS IRFIM_651AUD;
CREATE TABLE IRFIM_651AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 6 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 8 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 2 AS measBdw_N, -114 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -120 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 6 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 8 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 2 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -114 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -120 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=651 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>6 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>8 OR L.interPresAntP<>1 OR L.measBdw<>2 OR L.minRsrpIMLB<>-114 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-120);
--
--
--Q3 to 9560
DROP TABLE IF EXISTS IRFIM_9560AUD;
CREATE TABLE IRFIM_9560AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 6 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 10 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 3 AS measBdw_N, -114 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -120 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 6 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 10 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 3 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -114 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -120 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=9560 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>6 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>10 OR L.interPresAntP<>1 OR L.measBdw<>3 OR L.minRsrpIMLB<>-114 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-120);
--
--
--Q4 3225 to 3075
DROP TABLE IF EXISTS IRFIM32253075AUD;
CREATE TABLE IRFIM32253075AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 30 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.earfcnDL=3225 AND L.dlCarFrqEut=3075 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>30 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q5 3075 to 3225
DROP TABLE IF EXISTS IRFIM30753225AUD;
CREATE TABLE IRFIM30753225AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 30 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.earfcnDL=3075 AND L.dlCarFrqEut=3225 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>30 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q6 to 3075
DROP TABLE IF EXISTS IRFIM_3075AUD;
CREATE TABLE IRFIM_3075AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 15 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 15 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE (L.earfcnDL=626 OR L.earfcnDL=651 OR L.earfcnDL=9560) AND L.dlCarFrqEut=3075 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>15 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q7 to 3225
DROP TABLE IF EXISTS IRFIM_3225AUD;
CREATE TABLE IRFIM_3225AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 15 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 15 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE (L.earfcnDL=626 OR L.earfcnDL=651 OR L.earfcnDL=9560) AND L.dlCarFrqEut=3225 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>15 OR L.interPresAntP<>1  OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--
--
--
--AMLEPR custom
DROP TABLE IF EXISTS AMLEPR_ref;
CREATE TABLE AMLEPR_ref AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 600 and 1199 THEN 1900 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 2400 and 2649 THEN 850 ELSE NULL END)END)END)END AS BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname,
AMLEPR.PLMN_id,AMLEPR.MRBTS_id,AMLEPR.LNBTS_id,AMLEPR.LNCEL_id,AMLEPR.AMLEPR_id,AMLEPR.moVersion,AMLEPR.cacHeadroom,AMLEPR.deltaCac,AMLEPR.maxCacThreshold,AMLEPR.targetCarrierFreq,AMLEPR.SBTS_id
FROM AMLEPR LEFT JOIN LNCEL_Full AS L ON (AMLEPR.PLMN_Id=L.PLMN_Id) AND (AMLEPR.MRBTS_Id=L.MRBTS_Id) AND (AMLEPR.LNBTS_Id=L.LNBTS_Id) AND (AMLEPR.LNCEL_id=L.LNCEL_id);
--
--
-- AMLEPR AUDIT WITHOUT ID
--
DROP TABLE IF EXISTS AMLEPR_3075_3225;
CREATE TABLE AMLEPR_3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 30 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 30 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>30);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_651;
CREATE TABLE AMLEPR_3075_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_626;
CREATE TABLE AMLEPR_3075_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 45 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 45 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>45 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_9560;
CREATE TABLE AMLEPR_3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_3075;
CREATE TABLE AMLEPR_3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 30 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 30 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>30);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_651;
CREATE TABLE AMLEPR_3225_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_626;
CREATE TABLE AMLEPR_3225_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 45 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 45 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>45 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_9560;
CREATE TABLE AMLEPR_3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_651_3075;
CREATE TABLE AMLEPR_651_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_3225;
CREATE TABLE AMLEPR_651_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_626;
CREATE TABLE AMLEPR_651_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 60 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=626 AND (L.cacHeadroom <> 0 OR L.deltaCac <> 15 OR L.maxCacThreshold <> 50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_9560;
CREATE TABLE AMLEPR_651_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_626_3075;
CREATE TABLE AMLEPR_626_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_3225;
CREATE TABLE AMLEPR_626_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_651;
CREATE TABLE AMLEPR_626_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_9560;
CREATE TABLE AMLEPR_626_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_3075;
CREATE TABLE AMLEPR_9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_3225;
CREATE TABLE AMLEPR_9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_651;
CREATE TABLE AMLEPR_9560_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 60 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=651 AND (L.cacHeadroom <> 0 OR L.deltaCac <> 15 OR L.maxCacThreshold <> 50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_626;
CREATE TABLE AMLEPR_9560_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>50);
--
--
--
--
-- LNCEL IRFIM combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM626_3075;
CREATE TABLE LNCEL_IRFIM626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM626_3225;
CREATE TABLE LNCEL_IRFIM626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM626_9560;
CREATE TABLE LNCEL_IRFIM626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM651_3075;
CREATE TABLE LNCEL_IRFIM651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM651_3225;
CREATE TABLE LNCEL_IRFIM651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM651_9560;
CREATE TABLE LNCEL_IRFIM651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM3075_651;
CREATE TABLE LNCEL_IRFIM3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM3075_626;
CREATE TABLE LNCEL_IRFIM3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM3075_3225;
CREATE TABLE LNCEL_IRFIM3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,30 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM3075_9560;
CREATE TABLE LNCEL_IRFIM3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM3225_651;
CREATE TABLE LNCEL_IRFIM3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM3225_626;
CREATE TABLE LNCEL_IRFIM3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM3225_3075;
CREATE TABLE LNCEL_IRFIM3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,30 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM3225_9560;
CREATE TABLE LNCEL_IRFIM3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM9560_651;
CREATE TABLE LNCEL_IRFIM9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM9560_626;
CREATE TABLE LNCEL_IRFIM9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM9560_3075;
CREATE TABLE LNCEL_IRFIM9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM9560_3225;
CREATE TABLE LNCEL_IRFIM9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
--
DROP TABLE IF EXISTS LNCEL_IRFIM_FULL;
CREATE TABLE LNCEL_IRFIM_FULL AS
SELECT * FROM LNCEL_IRFIM626_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM626_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM626_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM651_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM651_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM651_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_651
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_626
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_651
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_626
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_651
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_626
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
--
DROP TABLE IF EXISTS IRFIM_Miss;
CREATE TABLE IRFIM_Miss AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id,
L.LNBTS_id, L.LNCEL_id,L.dlCarFrqEut,L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.IRFIM_id, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, I.dlCarFrqEut AS dlCarFrqEutMiss
FROM LNCEL_IRFIM_Full AS L LEFT JOIN IRFIM_ref AS I ON ((L.PLMN_id = I.PLMN_id) AND (L.MRBTS_id = I.MRBTS_id) AND (L.LNBTS_id = I.LNBTS_id) AND (L.LNCEL_id = I.LNCEL_id) AND (L.dlCarFrqEut = I.dlCarFrqEut))
WHERE I.dlCarFrqEut IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
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
--
--
--
-- LNCEL amlepr combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR626_3075;
CREATE TABLE LNCEL_AMLEPR626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR626_3225;
CREATE TABLE LNCEL_AMLEPR626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR626_9560;
CREATE TABLE LNCEL_AMLEPR626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR651_3075;
CREATE TABLE LNCEL_AMLEPR651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR651_3225;
CREATE TABLE LNCEL_AMLEPR651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR651_9560;
CREATE TABLE LNCEL_AMLEPR651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_651;
CREATE TABLE LNCEL_AMLEPR3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_626;
CREATE TABLE LNCEL_AMLEPR3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_3225;
CREATE TABLE LNCEL_AMLEPR3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_9560;
CREATE TABLE LNCEL_AMLEPR3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_651;
CREATE TABLE LNCEL_AMLEPR3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_626;
CREATE TABLE LNCEL_AMLEPR3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_3075;
CREATE TABLE LNCEL_AMLEPR3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_9560;
CREATE TABLE LNCEL_AMLEPR3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_651;
CREATE TABLE LNCEL_AMLEPR9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_626;
CREATE TABLE LNCEL_AMLEPR9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_3075;
CREATE TABLE LNCEL_AMLEPR9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_3225;
CREATE TABLE LNCEL_AMLEPR9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
--
DROP TABLE IF EXISTS LNCEL_AMLEPR_FULL;
CREATE TABLE LNCEL_AMLEPR_FULL AS
SELECT * FROM LNCEL_AMLEPR626_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR626_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR626_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
DROP TABLE IF EXISTS AMLEPR_MISS;
CREATE TABLE AMLEPR_MISS AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id_New, L.targetCarrierFreq_New, A.targetCarrierFreq
FROM LNCEL_AMLEPR_FULL AS L LEFT JOIN AMLEPR_ref AS A ON (L.PLMN_id = A.PLMN_id AND L.MRBTS_id = A.MRBTS_id AND L.LNBTS_id = A.LNBTS_id AND L.LNCEL_id = A.LNCEL_id AND L.targetCarrierFreq_New = A.targetCarrierFreq)
WHERE A.targetCarrierFreq IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
