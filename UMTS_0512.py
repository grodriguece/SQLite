import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
import glob
# from pyxlsb import open_workbook as open_xlsb

def cleandir(csvpath):
    for baself in csvpath.glob('*.csv'):  # file iteration inside directory
        try:
            os.remove(baself)  # remove old csv files
        except:
            print("Error while deleting file : ", baself)
    return

def xtrctype(filtype):
    switcher = {
        'WCELName': sqlxtrtcel1,
        'Prefijo': sqlxtrtcel2,
        'Cluster': sqlxtrtcel3,
        'Responsable': sqlxtrtcel4,
    }
    return switcher.get(filtype, 0)  # 0 if not found


columts = ['Day', 'PLMN', 'RNCname', 'WBTSname', 'WBTSID', 'WCELname', 'WCELID', 
'dendenied', 'numdenied', 'dendrop', 'numdrop', 'p_denied3g', 'p_dropcall3g', 
'CStrafficErl', 'usuarios_dch_dl', 'denied_hsdpa', 'drophsdpa', 
'MaxSimultHSDPAusers', 'AvgSimultHSDPAusers', 'AvgSimultHSUPAusers', 
'HSDPA_DLvol', 'AvgRTWP', 'num_access_hsdpa', 'num_access_hsupa', 
'num_retain_hsdpa', 'num_retain_hsupa', 'den_access_hsdpa', 
'den_access_hsupa', 'den_retain_hsdpa', 'den_retain_hsupa', 'CellAvail', 
'RAB_SR_Voice', 'RRC_SR', 'RRC_stp_acc_CR_UsrCSFB', 
'OP_RAB_stp_acc_CR_Voice', 'VoiceCallSetupSR_RRC_CU', 'usuarios_dch_ul', 
'HSDPASRUsr', 'MaxsimultHSUPAusers', 'HSUPASRUsr', 'HSUPAresAccNRT', 
'HSUPACongestionRatioIub', 'IUB_LOSS_CC_FRAME_LOSS_IND', 
'HSDPAcongestionRateInIub', 'HSUPAMAC_esDV', 'CSSRAll', 
'RRCActiveFR_due_IU', 'PSDLdataVol', 'PSULdataVol', 'AvgCQI', 
'avgprachdelay', 'ActHS_DSCHendUserthp', 'LTE_NOT_FOUND_REDIR', 
'CS_VOICE_DRP_AFT_MISSING_ADJ', 'MAXIMUM_PTXTOTAL', 
'rab_act_fail_cs_voice_bts', 'rab_act_fail_cs_voice_iu', 
'rab_act_fail_cs_voice_iur', 'rab_act_fail_cs_voice_radio', 
'rab_act_fail_cs_voice_rnc', 'RAB_ACT_FAIL_CS_VOICE_TRANS', 
'RAB_ACT_FAIL_CS_VOICE_UE', 'rab_acc_fail_cs_voice_rnc', 
'rab_acc_fail_cs_voice_ms', 'rab_stp_fail_cs_voice_ac', 
'rab_stp_fail_cs_voice_bts', 'rab_stp_fail_cs_voice_frozbs', 
'rab_stp_fail_cs_voice_rnc', 'rab_stp_fail_cs_voice_trans', 
'rrc_conn_acc_fail_rnc', 'rrc_conn_act_fail_radio', 'rrc_conn_acc_fail_ms', 
'rrc_conn_act_fail_iu', 'RRC_CONN_ACT_FAIL_TRANS', 'rrc_conn_stp_fail_ac', 
'rrc_conn_stp_fail_bts', 'rrc_conn_stp_fail_hc', 'rrc_conn_stp_fail_rnc', 
'rrc_conn_stp_fail_trans', 'rrc_conn_act_fail_bts', 'rrc_conn_act_fail_iur', 
'rrc_conn_act_fail_rnc', 'RRC_CONN_ACT_FAIL_UE']

columtssql = """
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
    avgprachdelay, ActHS_DSCHendUserthp, LTE_NOT_FOUND_REDIR,
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
    rrc_conn_act_fail_rnc, RRC_CONN_ACT_FAIL_UE
    """
umtssql2 = """
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
    t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE, w.Cluster, w.Sector, w.SectorID,
    w.Banda, w.UARFCN, c.Responsable  
    """
umtssql3 = """
    FROM ((UMTS AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster) 
    INNER JOIN temptable AS r ON 
    """
umtssql4 = """
    WHERE w.Region = 'Noroccidente' COLLATE NOCASE OR 
    (w.Region = 'oriente' COLLATE NOCASE AND w.Depto = 'Antioquia' COLLATE NOCASE) OR
    (w.Region = 'suroccidente' COLLATE NOCASE AND w.Depto = 'Caldas' COLLATE NOCASE)
    ORDER BY t.WBTSname, t.WCELname, t.Day;
    """
colnam = {
    'RNC name': 'RNCname', 'WBTS name': 'WBTSname', 'WBTS ID': 'WBTSid',
    'WCEL name': 'WCELname', 'WCEL ID': 'WCELid', 'Average RTWP': 'AvgRTWP',
    'Total CS traffic - Erl': 'AvgCS_ERL',
    'Max simult HSDPA users': 'AvgMaxHSDPAusers', 'avgprach': 'AvgPrach'
    }
aggreg = {
    'Day': 'first', 'RNC name': 'first', 'WBTS name': 'first', 
    'WBTS ID': 'first', 'WCEL name': 'first', 'WCEL ID': 'first', 
    'Average RTWP': 'mean', 'Total CS traffic - Erl': 'mean', 
    'Max simult HSDPA users': 'mean', 'avgprach': 'mean'
    }
sqlinsert = """
    INSERT INTO RTWP1 (Day, RNCname, WBTSname, WBTSid, WCELname, WCELid,
    AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach) 
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM temptable AS t 
    WHERE NOT EXISTS (SELECT 1 FROM RTWP1 AS r WHERE t.Day = r.Day 
    AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);
    """

sqlinsert1 = ("INSERT INTO UMTS (" + columtssql + ") " +
" SELECT " + umtssql2 + " FROM temptable AS t " +
"WHERE NOT EXISTS " + "(SELECT 1 FROM UMTS AS r WHERE t.Day = r.Day " +
"AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);")

sqlxtrtcel = """
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM RTWP1 AS t INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);
    """
sqlxtrtcel1 = ("SELECT " + umtssql2 + umtssql3 + 
" (t.WCELname = r.WCELName COLLATE NOCASE) " + umtssql4)
sqlxtrtcel2 = ("SELECT " + umtssql2 + umtssql3 + 
" (w.Prefijo = r.Prefijo COLLATE NOCASE) " + umtssql4)
sqlxtrtcel3 = ("SELECT " + umtssql2 + umtssql3 + 
" (w.Cluster = r.Cluster COLLATE NOCASE) " + umtssql4)
sqlxtrtcel4 = ("SELECT " + umtssql2 + umtssql3 + 
" (c.Responsable = r.Responsable COLLATE NOCASE) " + umtssql4)



    
 
    # FROM UMTS AS t INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);")
   





xlspath = Path('C:/xml/baseline/TUMTS/')  # RTWP csv directory
(xlspath / 'output').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
(xlspath / 'raw').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
(xlspath / 'tab').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
dbtgt = Path('C:/sqlite/kpi_sqlite.db')

dbdumplist = glob.glob(str(dbtgt.parent) +'/*_sqlite.dba')
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
connd = sqlite3.connect(latestdump)
curd = connd.cursor()
conn = sqlite3.connect(dbtgt)
cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")
df = pd.read_sql_query("select * from WCEL_PARAM1;", connd, index_col=None)  # pandas dataframe from sqlite
df.to_sql('wcel_param', conn, if_exists='replace', index=False, chunksize=10000)
cur.execute("DROP TABLE IF EXISTS cluster;")
dfcluster = pd.read_excel(xlspath.parent / 'distribucion.xlsb', sheet_name='Cluster_Dist', index_col=0 ,engine='pyxlsb')
dfcluster.to_sql('cluster', conn, if_exists='replace', index=False, chunksize=10000)



# report import to kpi_sqlite.db
# for baself in xlspath.glob('*.csv'):  # file iteration inside directory
#     print('{repfil} processing'.format(repfil=baself))
#     tempo2 = pd.read_csv(baself, sep=';', header=0, names=columts,index_col=False)  # csv to df
#     print(tempo2)
#     tempo2['Day'] = pd.to_datetime(tempo2['Day']) 
#     cur.execute("DROP TABLE IF EXISTS temptable;")
#     tempo2.to_sql(  # temp table
#         'temptable', conn, if_exists='replace', index=False, chunksize=10000)
#     cur.execute(sqlinsert1)  # insert avoiding duplicates
#     conn.commit()
# print('ok')
#
# data extract to xls template
ftab1 = 'sector_set.csv'  # sector names to extract
df3 = pd.read_csv(xlspath / 'tab' / ftab1)
cur.execute("DROP TABLE IF EXISTS temptable;")
df3.to_sql('temptable', conn, if_exists='replace', index=False)  # temp table
print('Sector Qty: {repfil}'.format(repfil=len(df3)))
xtrctyp = list(df3.columns)
xtrctyp1 = xtrctype(xtrctyp[0])

# if xtrctyp1 == 1:
#     sqlxtrtfinal = sqlxtrtcel1
# elif xtrctyp1 == 2:
#     sqlxtrtfinal = sqlxtrtcel2
# elif xtrctyp1 == 3:
#     sqlxtrtfinal = sqlxtrtcel3

if xtrctyp1 == 0:
    print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
else:
    df = pd.read_sql_query(xtrctyp1, conn)
    cleandir(xlspath / 'output')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
cur.close()
conn.close()
