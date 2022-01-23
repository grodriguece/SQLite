--
-- 651 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD651V2;
CREATE TABLE ANRPRL_AUD651v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 651;
--
--651 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD651;
CREATE TABLE ANRPRL_AUD651 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell, 
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 651 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD651v2 AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 626 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD626V2;
CREATE TABLE ANRPRL_AUD626v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 626;
--
--626 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD626;
CREATE TABLE ANRPRL_AUD626 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id,A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell, 
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 626 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD626v2 AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 3075 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD3075V2;
CREATE TABLE ANRPRL_AUD3075v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 3075;
--
--3075 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD3075;
CREATE TABLE ANRPRL_AUD3075 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell, 
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 3075 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD3075v2 AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 3225 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD3225V2;
CREATE TABLE ANRPRL_AUD3225v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 3225;
--
--3225 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD3225;
CREATE TABLE ANRPRL_AUD3225 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell, 
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 3225 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD3225v2 AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 9560 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD9560V2;
CREATE TABLE ANRPRL_AUD9560v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 9560;
--
--9560 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD9560;
CREATE TABLE ANRPRL_AUD9560 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell, 
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 9560 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD9560v2 AS A ON (L.PLMN_id = A.PLMN_id) 
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
--
DROP TABLE IF EXISTS ANRPRL_MISS_FULL;
CREATE TABLE ANRPRL_MISS_FULL AS
SELECT * FROM ANRPRL_AUD626
UNION ALL
SELECT * FROM ANRPRL_AUD651
UNION ALL
SELECT * FROM ANRPRL_AUD3225
UNION ALL
SELECT * FROM ANRPRL_AUD3075
UNION ALL
SELECT * FROM ANRPRL_AUD9560
ORDER BY
    LNBTS_id;
--
--
-- Combinations from missing tuples
--
DROP TABLE IF EXISTS ANRPRL1;
CREATE TABLE ANRPRL1 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 1 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL2;
CREATE TABLE ANRPRL2 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 2 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL3;
CREATE TABLE ANRPRL3 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 3 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL4;
CREATE TABLE ANRPRL4 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 4 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL5;
CREATE TABLE ANRPRL5 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 5 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL6;
CREATE TABLE ANRPRL6 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 6 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL7;
CREATE TABLE ANRPRL7 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 7 AS ANRPRL_Id, B.LNBTS_id, 
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL8;
CREATE TABLE ANRPRL8 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 8 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
--
DROP TABLE IF EXISTS ANRPRL_COMB;
CREATE TABLE ANRPRL_COMB AS
SELECT * FROM ANRPRL1
UNION ALL
SELECT * FROM ANRPRL2
UNION ALL
SELECT * FROM ANRPRL3
UNION ALL
SELECT * FROM ANRPRL4
UNION ALL
SELECT * FROM ANRPRL5
UNION ALL
SELECT * FROM ANRPRL6
UNION ALL
SELECT * FROM ANRPRL7
UNION ALL
SELECT * FROM ANRPRL8
ORDER BY
    LNBTS_id, ANRPRL_Id;
--
--
-- Possible ids from not used in ANRPRL
--   
DROP TABLE IF EXISTS ANRPRL_AVAIL;
CREATE TABLE ANRPRL_AVAIL AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, B.ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell, 
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_COMB AS B LEFT JOIN ANRPRL AS A ON (B.PLMN_id = A.PLMN_id) 
AND (B.MRBTS_id = A.MRBTS_id) AND (B.LNBTS_id = A.LNBTS_id) AND (B.ANRPRL_Id = A.ANRPRL_Id)
WHERE A.ANRPRL_id IS NULL
ORDER BY
    B.LNBTS_id;
--
--
--
--