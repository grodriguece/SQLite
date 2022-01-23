DROP TABLE IF EXISTS tempumts;
CREATE TABLE tempumts AS 
SELECT
 t.Day, t.PLMN, t.RNCname, t.WBTSname, t.WBTSID, t.WCELname, t.WCELid,
    t.dendenied, t.numdenied, t.dendrop, t.numdrop, t.p_denied3g, t.p_dropcall3g,
    t.CStrafficErl, t.usuarios_dch_dl, t.denied_hsdpa, t.drophsdpa, t.MaxSimultHSDPAusers,
    t.AvgSimultHSDPAusers, t.AvgSimultHSUPAusers, t.HSDPA_DLvol, t.AvgRTWP,
    t.num_access_hsdpa, t.num_access_hsupa, t.num_retain_hsdpa, t.num_retain_hsupa,
    t.den_access_hsdpa, t.den_access_hsupa, t.den_retain_hsdpa, t.den_retain_hsupa,
    t.CellAvail, t.RAB_SR_Voice, t.RRC_SR, t.RRC_stp_acc_CR_UsrCSFB,
    t.OP_RAB_stp_acc_CR_Voice, t.VoiceCallSetupSR_RRC_CU, t.usuarios_dch_ul, t.HSDPASRUsr,
    t.MaxsimultHSUPAusers, t.HSUPASRUsr, t.HSUPAresAccNRT, t.HSUPACongestionRatioIub,
    t.IUB_LOSS_CC_FRAME_LOSS_IND, t.HSDPAcongestionRateInIub, t.HSUPAMAC_esDV, t.CSSRAll,
    t.RRCActiveFR_due_IU, t.PSDLdataVol, t.PSULdataVol, t.AvgCQI, t.avgprachdelay,
    t.ActHS_DSCHendUserthp, t.LTE_NOT_FOUND_REDIR, t.CS_VOICE_DRP_AFT_MISSING_ADJ,
    t.MAXIMUM_PTXTOTAL, t.rab_act_fail_cs_voice_bts, t.rab_act_fail_cs_voice_iu,
    t.rab_act_fail_cs_voice_iur, t.rab_act_fail_cs_voice_radio, t.rab_act_fail_cs_voice_rnc,
    t.RAB_ACT_FAIL_CS_VOICE_TRANS, t.RAB_ACT_FAIL_CS_VOICE_UE, t.rab_acc_fail_cs_voice_rnc,
    t.rab_acc_fail_cs_voice_ms, t.rab_stp_fail_cs_voice_ac, t.rab_stp_fail_cs_voice_bts,
    t.rab_stp_fail_cs_voice_frozbs, t.rab_stp_fail_cs_voice_rnc, t.rab_stp_fail_cs_voice_trans,
    t.rrc_conn_acc_fail_rnc, t.rrc_conn_act_fail_radio, t.rrc_conn_acc_fail_ms,
    t.rrc_conn_act_fail_iu, t.RRC_CONN_ACT_FAIL_TRANS, t.rrc_conn_stp_fail_ac,
    t.rrc_conn_stp_fail_bts, t.rrc_conn_stp_fail_hc, t.rrc_conn_stp_fail_rnc,
    t.rrc_conn_stp_fail_trans, t.rrc_conn_act_fail_bts, t.rrc_conn_act_fail_iur,
    t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE, w.Cluster, w.Sector, w.SectorID, w.Banda, w.UARFCN, c.Responsable 
FROM ((UMTS AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName) 
LEFT JOIN cluster AS c ON w.Cluster = c.Cluster) 
INNER JOIN temptable AS r ON (c.Responsable = r.Responsable COLLATE NOCASE) ORDER BY t.WBTSname, t.WCELname, t.Day;
    


SELECT \n    t.Day, t.PLMN, t.RNCname, t.WBTSname, t.WBTSID, t.WCELname, t.WCELid,\n    t.dendenied, t.numdenied, t.dendrop, 
t.numdrop, t.p_denied3g, t.p_dropcall3g,\n    t.CStrafficErl, t.usuarios_dch_dl, t.denied_hsdpa, t.drophsdpa, t.MaxSimultHSDPAusers,
t.AvgSimultHSDPAusers, t.AvgSimultHSUPAusers, t.HSDPA_DLvol, t.AvgRTWP,\n    t.num_access_hsdpa, t.num_access_hsupa, t.num_retain_hsdpa, 
t.num_retain_hsupa, t.den_access_hsdpa, t.den_access_hsupa, t.den_retain_hsdpa, t.den_retain_hsupa, t.CellAvail, t.RAB_SR_Voice,
t.RRC_SR, t.RRC_stp_acc_CR_UsrCSFB, t.OP_RAB_stp_acc_CR_Voice, t.VoiceCallSetupSR_RRC_CU, t.usuarios_dch_ul, t.HSDPASRUsr,
t.MaxsimultHSUPAusers, t.HSUPASRUsr, t.HSUPAresAccNRT, t.HSUPACongestionRatioIub, t.IUB_LOSS_CC_FRAME_LOSS_IND, t.HSDPAcongestionRateInIub,
t.HSUPAMAC_esDV, t.CSSRAll, t.RRCActiveFR_due_IU, t.PSDLdataVol, t.PSULdataVol, t.AvgCQI, t.avgprachdelay, t.ActHS_DSCHendUserthp, 
t.LTE_NOT_FOUND_REDIR, t.CS_VOICE_DRP_AFT_MISSING_ADJ, t.MAXIMUM_PTXTOTAL, t.rab_act_fail_cs_voice_bts, t.rab_act_fail_cs_voice_iu,
t.rab_act_fail_cs_voice_iur, t.rab_act_fail_cs_voice_radio, t.rab_act_fail_cs_voice_rnc, t.RAB_ACT_FAIL_CS_VOICE_TRANS, 
t.RAB_ACT_FAIL_CS_VOICE_UE, t.rab_acc_fail_cs_voice_rnc, t.rab_acc_fail_cs_voice_ms, t.rab_stp_fail_cs_voice_ac, 
t.rab_stp_fail_cs_voice_bts, t.rab_stp_fail_cs_voice_frozbs, t.rab_stp_fail_cs_voice_rnc, t.rab_stp_fail_cs_voice_trans,
t.rrc_conn_acc_fail_rnc, t.rrc_conn_act_fail_radio, t.rrc_conn_acc_fail_ms, t.rrc_conn_act_fail_iu, t.RRC_CONN_ACT_FAIL_TRANS, 
t.rrc_conn_stp_fail_ac, t.rrc_conn_stp_fail_bts, t.rrc_conn_stp_fail_hc, t.rrc_conn_stp_fail_rnc, t.rrc_conn_stp_fail_trans,
t.rrc_conn_act_fail_bts, t.rrc_conn_act_fail_iur, t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE, w.Cluster, w.Sector, w.SectorID,
w.Banda, w.UARFCN, c.Responsable
FROM ((UMTS AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName)
LEFT JOIN cluster AS c ON w.Cluster = c.Cluster)
INNER JOIN temptable AS r ON (c.Responsable = r.Responsable COLLATE NOCASE)
ORDER BY t.WBTSname, t.WCELname, t.Day;
    
FROM ((UMTS AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName) LEFT JOIN cluster AS c ON w.Cluster = c.Cluster)
INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);



LEFT JOIN ;
DROP TABLE IF EXISTS tempumts;
CREATE TABLE tempumts AS 
SELECT
 t.Day, t.PLMN, t.RNCname, t.WBTSname, t.WBTSID, t.WCELname, t.WCELid,
    t.dendenied, t.numdenied, t.dendrop, t.numdrop, t.p_denied3g, t.p_dropcall3g,
    t.CStrafficErl, t.usuarios_dch_dl, t.denied_hsdpa, t.drophsdpa, t.MaxSimultHSDPAusers,
    t.AvgSimultHSDPAusers, t.AvgSimultHSUPAusers, t.HSDPA_DLvol, t.AvgRTWP,
    t.num_access_hsdpa, t.num_access_hsupa, t.num_retain_hsdpa, t.num_retain_hsupa,
    t.den_access_hsdpa, t.den_access_hsupa, t.den_retain_hsdpa, t.den_retain_hsupa,
    t.CellAvail, t.RAB_SR_Voice, t.RRC_SR, t.RRC_stp_acc_CR_UsrCSFB,
    t.OP_RAB_stp_acc_CR_Voice, t.VoiceCallSetupSR_RRC_CU, t.usuarios_dch_ul, t.HSDPASRUsr,
    t.MaxsimultHSUPAusers, t.HSUPASRUsr, t.HSUPAresAccNRT, t.HSUPACongestionRatioIub,
    t.IUB_LOSS_CC_FRAME_LOSS_IND, t.HSDPAcongestionRateInIub, t.HSUPAMAC_esDV, t.CSSRAll,
    t.RRCActiveFR_due_IU, t.PSDLdataVol, t.PSULdataVol, t.AvgCQI, t.avgprachdelay,
    t.ActHS_DSCHendUserthp, t.LTE_NOT_FOUND_REDIR, t.CS_VOICE_DRP_AFT_MISSING_ADJ,
    t.MAXIMUM_PTXTOTAL, t.rab_act_fail_cs_voice_bts, t.rab_act_fail_cs_voice_iu,
    t.rab_act_fail_cs_voice_iur, t.rab_act_fail_cs_voice_radio, t.rab_act_fail_cs_voice_rnc,
    t.RAB_ACT_FAIL_CS_VOICE_TRANS, t.RAB_ACT_FAIL_CS_VOICE_UE, t.rab_acc_fail_cs_voice_rnc,
    t.rab_acc_fail_cs_voice_ms, t.rab_stp_fail_cs_voice_ac, t.rab_stp_fail_cs_voice_bts,
    t.rab_stp_fail_cs_voice_frozbs, t.rab_stp_fail_cs_voice_rnc, t.rab_stp_fail_cs_voice_trans,
    t.rrc_conn_acc_fail_rnc, t.rrc_conn_act_fail_radio, t.rrc_conn_acc_fail_ms,
    t.rrc_conn_act_fail_iu, t.RRC_CONN_ACT_FAIL_TRANS, t.rrc_conn_stp_fail_ac,
    t.rrc_conn_stp_fail_bts, t.rrc_conn_stp_fail_hc, t.rrc_conn_stp_fail_rnc,
    t.rrc_conn_stp_fail_trans, t.rrc_conn_act_fail_bts, t.rrc_conn_act_fail_iur,
    t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE, w.Cluster, w.Sector, w.SectorID, w.Banda, w.UARFCN, c.Responsable 
FROM ((UMTS AS t INNER JOIN temptable AS r ON (t.Prefijo = r.Prefijo))
LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName) LEFT JOIN cluster AS c ON w.Cluster = c.Cluster;


DROP TABLE IF EXISTS RTWP1;
CREATE TABLE RTWP1(
   Day DATETIME, RNCname, WBTSname, WBTSid, WCELname, WCELid, AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach
);
CREATE INDEX rtwp1_rnc_wcelid ON RTWP1(Day, RNCname, WCELid);

Day, RNCname, WBTSname, WBTSid, WCELname, WCELid, AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach
SELECT
RNCname, WBTSname, WCELname, cluster
FROM wcel_param
WHERE WBTSname = "MED.Olaya Herrera";
Day > (SELECT DATETIME('now', '-4 day'));
SELECT date('now');


DROP TABLE IF EXISTS temptable;
CREATE TABLE temptable AS
SELECT
RNCname, WBTSname, WBTSid, WCELname, WCELid, AVG(AvgRTWP) AS AvgRTWP, MAX(AvgRTWP) AS MaxRTWP, AVG(AvgCS_ERL) AS AvgCS_ERL, 
AVG(AvgMaxHSDPAusers) AS AvgMaxHSDPAusers , AVG(AvgPrach) AS AvgPrach 
FROM RTWP
WHERE (Day > (SELECT DATETIME('now', '-7 day'))) 
GROUP BY RNCname, WBTSname, WBTSid, WCELname, WCELid
ORDER BY MAX(AvgRTWP) DESC;
DROP TABLE IF EXISTS rtwp7day;
CREATE TABLE rtwp7day AS
SELECT
RNCname, WBTSname, WBTSid, WCELname, WCELid, AvgRTWP, MaxRTWP, AvgCS_ERL, AvgMaxHSDPAusers , AvgPrach 
FROM temptable
WHERE AvgRTWP > -85 AND MaxRTWP > -85
ORDER BY MaxRTWP DESC;

DELETE FROM RTWP 
WHERE Day > '2021-06-01' ;

DELETE FROM UMTS 
WHERE Day > '2021-05-31' ;


ALTER TABLE UMTS RENAME TO umtsini;

CREATE TABLE UMTS AS
SELECT
Day, PLMN, RNCname, WBTSname, WBTSID, WCELname, WCELid,
    dendenied, numdenied, dendrop, numdrop, p_denied3g, p_dropcall3g,
    CStrafficErl, usuarios_dch_dl, denied_hsdpa, drophsdpa,
    MaxSimultHSDPAusers, AvgSimultHSDPAusers, AvgSimultHSUPAusers,
    HSDPA_DLvol, AvgRTWP, num_access_hsdpa, num_access_hsupa,
    num_retain_hsdpa, num_retain_hsupa, den_access_hsdpa,
    den_access_hsupa, den_retain_hsdpa, den_retain_hsupa, CellAvail,
    RAB_SR_Voice, RRC_SR, RRC_stp_acc_CR_UsrCSFB,
    OP_RAB_stp_acc_CR_Voice, VoiceCallSetupSR_RRC_CU, usuarios_dch_ul,
    HSDPASRUsr, MaxsimultHSUPAusers, HSUPASRUsr, HSUPAresAccNRT,
    HSUPACongestionRatioIub, IUB_LOSS_CC_FRAME_LOSS_IND,
    HSDPAcongestionRateInIub, HSUPAMAC_esDV, CSSRAll,
    RRCActiveFR_due_IU, PSDLdataVol, PSULdataVol, AvgCQI,
    avgprachdelay, ActHS_DSCHendUserthp, LTE_NOT_FOUND_REDIR, RDRT_START_MEAS,
    CS_VOICE_DRP_AFT_MISSING_ADJ, MAXIMUM_PTXTOTAL,
    rab_act_fail_cs_voice_bts, rab_act_fail_cs_voice_iu,
    rab_act_fail_cs_voice_iur, rab_act_fail_cs_voice_radio,
    rab_act_fail_cs_voice_rnc, RAB_ACT_FAIL_CS_VOICE_TRANS,
    RAB_ACT_FAIL_CS_VOICE_UE, rab_acc_fail_cs_voice_rnc,
    rab_acc_fail_cs_voice_ms, rab_stp_fail_cs_voice_ac,
    rab_stp_fail_cs_voice_bts, rab_stp_fail_cs_voice_frozbs,
    rab_stp_fail_cs_voice_rnc, rab_stp_fail_cs_voice_trans,
    rrc_conn_acc_fail_rnc, rrc_conn_act_fail_radio, rrc_conn_acc_fail_ms,
    rrc_conn_act_fail_iu, RRC_CONN_ACT_FAIL_TRANS, rrc_conn_stp_fail_ac,
    rrc_conn_stp_fail_bts, rrc_conn_stp_fail_hc, rrc_conn_stp_fail_rnc,
    rrc_conn_stp_fail_trans, rrc_conn_act_fail_bts, rrc_conn_act_fail_iur,
    rrc_conn_act_fail_rnc, RRC_CONN_ACT_FAIL_UE, 0 AS RRCCONN_STPFL_frozbs,
    0 AS RRC_CONN_STP_FL_AC_UL, 0 AS RRCCONN_STPFL_AC_DL, 0 AS RRCCONN_STPFL_AC_COD, 
    0 AS DCHSEL_MAXHSD_USRINT
FROM umtsini;

DROP INDEX umts_rnc_wcelid1;
CREATE INDEX umts_rnc_wcelid1 ON UMTS (Day, RNCname, WCELid);
DROP TABLE IF EXISTS umtsini;


DROP TABLE IF EXISTS rtwpcell;
CREATE TABLE rtwpcell AS
SELECT *
FROM RTWP r
WHERE r.WBTSname = 'ANT.ZUNGO EMBARCADERO' COLLATE NOCASE OR r.WBTSname = 'ANT.CHURIDO' COLLATE NOCASE 
OR r.WBTSname = 'ANT.NUEVA COLONIA' COLLATE NOCASE OR r.WBTSname = 'ANT.UNIBAN' COLLATE NOCASE;
--
--
--
--
DROP TABLE IF EXISTS temptable1;
CREATE TABLE temptable1 AS
SELECT
RNCname, WBTSname, WBTSid, WCELname, WCELid, AVG(AvgRTWP) AS AvgRTWP, MAX(AvgRTWP) AS MaxRTWP, AVG(AvgCS_ERL) AS AvgCS_ERL, 
AVG(AvgMaxHSDPAusers) AS AvgMaxHSDPAusers , AVG(AvgPrach) AS AvgPrach 
FROM RTWP
WHERE Day BETWEEN '2021-06-05' AND '2021-06-06'
GROUP BY RNCname, WBTSname, WBTSid, WCELname, WCELid
ORDER BY MAX(AvgRTWP) DESC;
DROP TABLE IF EXISTS rtwp7day;


