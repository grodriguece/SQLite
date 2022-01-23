import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
import subprocess


def inputval():  # Option selections and veification
    verif = 0
    while verif < 3:
        try:
            opt = int(input())
            if opt <1 or opt >3:
                print('Please enter correct value.')
                verif+=1
            else:
                verif = 4
        except ValueError:
            print('No valid integer! Please try again ...')
    return opt, verif

def cleandir(csvpath,exten):  # del .exten files inside a dir
    for baself in csvpath.glob('*.%s' % exten):  # file iteration inside directory
        try:
            os.remove(baself)  # remove old exten files
        except:
            print("Error while deleting file : ", baself)
    return

def folderc(xlspathc):  # folder creation if not available
    (xlspathc / 'output').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'raw').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'tab').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files    
    return

def netactimp(netactf, pathdest):  # file retrieve from network location 
    cmdir = 'dir "%s"' % (str(PureWindowsPath(netactf))) 
    subprocess.call(cmdir, shell=True)
    cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(netactf)), str(PureWindowsPath(pathdest)) )
    subprocess.call(cmcopy, shell=True)
    subprocess.call(exe + " e " + str(PureWindowsPath(pathdest)) + "\*.gz" + " -o" 
    + str(PureWindowsPath(pathdest)))
    cleandir(pathdest, 'gz')
    cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(pathdest)) + "\*.csv", str(PureWindowsPath(pathdest)) + "\\raw")
    subprocess.call(cmcopy, shell=True)
    return

def totemplate(conn, xlspath, sqlxtrtcel): # get info to load xlsb template
    ftab1 = 'sector_set.csv'  # sector names to extract
    df3 = pd.read_csv(xlspath / 'tab' / ftab1)
    cur.execute("DROP TABLE IF EXISTS temptable;")
    df3.to_sql('temptable', conn, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    df = pd.read_sql_query(sqlxtrtcel, conn)
    cleandir(xlspath / 'output', 'csv')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
    return

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
    t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE 
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
    INSERT INTO RTWP (Day, RNCname, WBTSname, WBTSid, WCELname, WCELid,
    AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach) 
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM temptable AS t 
    WHERE NOT EXISTS (SELECT 1 FROM RTWP AS r WHERE t.Day = r.Day 
    AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);
    """
sqlinsert1 = ("INSERT INTO UMTS (" + columtssql + ") " +
" SELECT " + umtssql2 + " FROM temptable AS t " +
"WHERE NOT EXISTS " + "(SELECT 1 FROM UMTS AS r WHERE t.Day = r.Day " +
"AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);")
sqlxtrtcel = """
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM RTWP AS t INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);
    """
sqlxtrtcel1 = ("SELECT " + umtssql2 +  
    "FROM UMTS AS t INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);")
xlspath1 = Path('C:/xml/baseline/TUMTS/')  # UMTS csv directory
xlspath = Path('C:/xml/baseline/RTWP/')  # RTWP csv directory
folderc(xlspath1)  # folder creation
folderc(xlspath)
dbtgt = Path('C:/sqlite/kpi_sqlite.db')  # working dB
today = date.today()
exe = "C:\\7za\\7za.exe"
pathrep ='//USSTLCCOS01/Repository/TMP_Reportes_Netact_Mirror/'
conn = sqlite3.connect(dbtgt)
cur = conn.cursor()
print('dBAct(1), Getdata(2), Both(3): ')
opt,verif=inputval()  # option selection1
if verif == 3:
    print('Default value taken Getdata(2)')
    opt=2
print('UMTS: Kpi(1), RTWP(2), Both(3)')
opt1,verif1=inputval()  # option selection2
if verif1 == 3:
    print('Default value taken Both(3)')
    opt1=3
if (opt != 2):  # update
    if opt1 != 1:  # RTWP or both 
        netactf = pathrep + today.strftime("%Y%m%d") + "/Analisis_RTWP_3G_NorOcc*.gz"
        netactimp(netactf, xlspath)
        for baself in xlspath.glob('*.csv'):  # file iteration inside directory
            print('{repfil} processing'.format(repfil=baself))
            tempo = pd.read_csv(baself, sep=';',index_col=False)  # csv to df
            tempo[['Day', 'Hour']] = tempo.PERIOD_START_TIME.str.split(
                " ", expand=True,)  # time text to column
            mask = np.in1d(tempo['Hour'].values, ['02:00:00', '03:00:00', '04:00:00'])
            tempo1 = tempo[mask]  # filter hours
            tempo2 = tempo1.groupby(
                ['RNC name', 'WCEL ID', 'Day'],
                as_index=False).agg(aggreg).rename(columns=colnam)
            print(tempo2)
            tempo2['Day'] = pd.to_datetime(tempo2['Day']) 
            cur.execute("DROP TABLE IF EXISTS temptable;")
            tempo2.to_sql(  # temp table
                'temptable', conn, if_exists='replace', index=False, chunksize=10000)
            cur.execute(sqlinsert)  # insert avoiding duplicates
            conn.commit()
        cleandir(xlspath, 'csv')  # delete processed files in root directory
    if opt1 != 2:  # kpi or both
        netactf = pathrep + today.strftime("%Y%m%d") + "/PT_3G_RC*.gz"
        netactimp(netactf, xlspath1)
        for baself in xlspath1.glob('*.csv'):  # file iteration inside directory
            print('{repfil} processing'.format(repfil=baself))
            tempo2 = pd.read_csv(baself, sep=';', header=0, names=columts,index_col=False)  # csv to df
            print(tempo2)
            tempo2['Day'] = pd.to_datetime(tempo2['Day']) 
            cur.execute("DROP TABLE IF EXISTS temptable;")
            tempo2.to_sql(  # temp table
                'temptable', conn, if_exists='replace', index=False, chunksize=10000)
            cur.execute(sqlinsert1)  # insert avoiding duplicates
            conn.commit()
        cleandir(xlspath1, 'csv')  # delete processed files in root directory
if (opt != 1):  # data extract to xls template
    if opt1 != 1:  # RTWP or both 
        totemplate(conn, xlspath, sqlxtrtcel)
    if opt1 != 2:  # kpi or both
        totemplate(conn, xlspath1, sqlxtrtcel1)
cur.close()
conn.close()
print('ok')
