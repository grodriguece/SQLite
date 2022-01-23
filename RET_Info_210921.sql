-- 
--
DROP TABLE IF EXISTS RMOD_R_L;
CREATE TABLE RMOD_R_L AS
SELECT * FROM RMOD_R_ACTIVECELLSLIST
UNION ALL
SELECT * FROM RMOD_R_ACTIVELTECELLSLIST;
--
DROP TABLE IF EXISTS RMOD_LTE;
CREATE TABLE RMOD_LTE AS
SELECT
l.LNCELname,l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo,  l.PLMN_id, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.lcrId, l.earfcnDL,
l.tilt AS tilt_e_dump,
r.moVersion AS moVersionr,r.distName AS distNamer ,r.PLMN_id,r.MRBTS_id,r.EQM_R_id,r.APEQM_R_id,r.RMOD_R_id,r.OPTITEM_id,r.Value,
rr.chassisProductCode,rr.chassisSerialNumber,rr.configDN,rr.hwVersion,rr.nrOfTXElements,rr.operationalState,rr.proceduralStatus,rr.productCode,
rr.productName,rr.radioMasterDN,rr.radioModuleHwReleaseCode,rr.serialNumber
FROM (LTE_Param l LEFT JOIN RMOD_R_L r ON (l.PLMN_id=r.PLMN_id AND l.MRBTS_id=r.MRBTS_id AND l.lcrid=r.Value))
LEFT JOIN RMOD_R rr ON rr.distName = r.distName
ORDER BY l.LNCELname IS NULL OR l.LNCELname='', l.LNCELname;
--
--
--
--
DROP TABLE IF EXISTS ANTL_info1;
CREATE TABLE ANTL_info1 AS
SELECT DISTINCT 
B.LNBTSname, l.LNCELname, B.Cluster, B.Region, B.Depto, B.Mun, B.Prefijo, c.PLMN_id, c.MRBTS_id, c.LCELL_id, c.antlDN, c.LCELW_id, c.LCELNR_id, c.resourceDN, c.LCELC_id,
r.ALD_id, r.RETU_id
FROM ((CHANNEL c INNER JOIN RETU_ANTLDNLIST r ON (c.PLMN_id = r.PLMN_id AND c.MRBTS_id = r.MRBTS_id AND c.antlDN = r.Value))
LEFT JOIN LNBTS_Full B ON (c.PLMN_id=B.PLMN_id AND c.MRBTS_id=B.MRBTS_id)) LEFT JOIN LNCEL_Full l ON (c.PLMN_id = l.PLMN_id AND c.MRBTS_id = l.MRBTS_id AND 
c.LCELL_id = l.lcrId)
ORDER BY B.LNBTSname IS NULL OR B.LNBTSname='', B.LNBTSname;
--
--
DROP TABLE IF EXISTS RETU_info1;
CREATE TABLE RETU_info1 AS
SELECT
a.PLMN_id,a.MRBTS_id,a.EQM_id,a.APEQM_id,a.ALD_id, r.RETU_id, 
a.productCode, a.serialNumber, a.moVersion,a.distName,
r.angle/10 AS angle,r.maxAngle,r.mechanicalAngle,r.minAngle, r.subunitNumber,
r.antBearing, r.antModel,r.antSerial,r.baseStationID,r.sectorID,r.moVersion AS Versionr ,r.distName AS distNamer
FROM (ALD a LEFT JOIN RETU r ON (a.PLMN_id=r.PLMN_id AND a.MRBTS_id=r.MRBTS_id AND a.EQM_id=r.EQM_id AND a.APEQM_id=r.APEQM_id AND a.ALD_id=r.ALD_id))
;
--
--
DROP TABLE IF EXISTS ANTL_info2;
CREATE TABLE ANTL_info2 AS
SELECT
a.LNBTSname, a.LNCELname, a.Cluster, a.Region, a.Depto, a.Mun, a.Prefijo, a.PLMN_id, a.MRBTS_id, a.LCELL_id, r.EQM_id,r.APEQM_id,r.ALD_id,  
r.productCode, r.serialNumber, r.moVersion, r.distName,
r.RETU_id, r.angle, r.maxAngle, r.mechanicalAngle, r.minAngle, r.subunitNumber,
r.antBearing, r.antModel, r.antSerial, r.baseStationID, r.sectorID, r.Versionr ,r.distNamer,
a.antlDN, a.LCELW_id, a.LCELNR_id, a.resourceDN, a.LCELC_id,
SUBSTR(a.antlDN, 1, INSTR(a.antlDN, '/ANTL')-1) AS rmod_dn
FROM ANTL_info1 a LEFT JOIN RETU_info1 r ON (a.PLMN_id=r.PLMN_id AND a.MRBTS_id=r.MRBTS_id AND a.ALD_id=r.ALD_id AND a.RETU_id=r.RETU_id);
--
--
--
DROP TABLE IF EXISTS RET_LTE;
CREATE TABLE RET_LTE AS
SELECT
l.LNCELname,r.LNBTSname,l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo, l.PLMN_id, l.MRBTS_id, 
l.LNBTS_id, l.LNCEL_id, l.lcrId, l.earfcnDL, l.moVersionr,l.distNamer ,l.EQM_R_id,l.APEQM_R_id,
l.RMOD_R_id,l.OPTITEM_id,l.Value,l.chassisProductCode,l.chassisSerialNumber,l.configDN,
l.hwVersion,l.nrOfTXElements,l.operationalState,l.proceduralStatus,l.productCode,
l.productName,l.radioMasterDN,l.radioModuleHwReleaseCode,l.serialNumber,
r.ALD_id, r.RETU_id, r.productCode AS productCodea, r.serialNumber AS serialNumber, r.moVersion, 
r.distName, l.tilt_e_dump, r.angle, CASE WHEN (r.angle IS NULL OR l.tilt_e_dump IS NULL) THEN 0 ELSE
(CASE WHEN (r.angle = l.tilt_e_dump) THEN 0 ELSE 1 END)END AS TiltDisc,
CASE WHEN (r.angle IS NULL OR l.tilt_e_dump IS NULL) THEN 0 ELSE (r.angle - l.tilt_e_dump) END AS TEret_TEDump,
r.maxAngle, r.mechanicalAngle, r.minAngle, r.subunitNumber,
r.antBearing, r.antModel,r.antSerial,r.baseStationID,r.sectorID,r.Versionr ,r.distNamer, r.antlDN, r.rmod_dn
FROM RMOD_LTE l LEFT JOIN ANTL_info2 r ON (l.configDN=r.rmod_dn)
ORDER BY l.LNCELname IS NULL OR l.LNCELname='', l.LNCELname;
--

