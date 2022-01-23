import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
import subprocess
import glob
from pyexcelerate import Workbook

def sqltabexport(conn1, tabs1, filenam, datab):
    today = date.today()
    xls_file = filenam + '_' + today.strftime("%y%m%d") + ".xlsx"
    xls_path = datab.parent / 'xlsx' / xls_file  # xls file path-name
    wb = Workbook()
    for i in tabs1:
        try:
            print('saving sheet {iterar}'.format (iterar=i))
            df = pd.read_sql_query("select * from " + i + ";", conn1)  # pandas dataframe from sqlite
            data = [df.columns.tolist()] + df.values.tolist()  # dataframe to list to pyexcelerate save
            wb.new_sheet(i, data=data)
        except sqlite3.Error as error:  # sqlite error handling
            print('SQLite error: %s' % (' '.join(error.args)))
    print('saving file {iterar}'.format (iterar=str(xls_path)))
    wb.save(xls_path)
    return

def inputval():  # Option selections and verification
    verif = 0
    while verif < 3:
        try:
            opt = int(input())
            if opt <1 or opt >4:
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

def xtrctype(filtype):
    switcher = {
        'WCELName': sqlxtrtcel1,
        'Prefijo': sqlxtrtcel2,
        'Cluster': sqlxtrtcel3,
        'Responsable': sqlxtrtcel4,
    }
    return switcher.get(filtype, 0)  # 0 if not found

def xtrctypr(filtype):
    switcher = {
        'WCELName': sqlxtrtcer1,
        'Prefijo': sqlxtrtcer2,
        'Cluster': sqlxtrtcer3,
        'Responsable': sqlxtrtcer4,
    }
    return switcher.get(filtype, 0)  # 0 if not found

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

def totemplate(conn, xlspath): # get info to load xlsb template
    ftab1 = 'sector_set.csv'  # sector names to extract
    df3 = pd.read_csv(xlspath / 'tab' / ftab1)
    cur.execute("DROP TABLE IF EXISTS temptable;")
    df3.to_sql('temptable', conn, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    return df3

def totemplate1(conn, xlspath, sqlxtrtcel): # get info to load xlsb template    
    df = pd.read_sql_query(sqlxtrtcel, conn)
    cleandir(xlspath / 'output', 'csv')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
    return

wcelfulsql = """
CREATE TABLE WCEL_PARAM2 AS
SELECT DISTINCT
WCEL.name AS WCELName, substr(WCEL.name,1,3) AS Prefijo, WCEL.UARFCN, CASE WHEN WCEL.UARFCN < 9685 THEN 850 ELSE 1900 END Banda,
WBTS.name AS WBTSName, WCEL.PLMN_id, RNC.name AS RNCName, RNC.RNC_id, WBTS.WBTS_id, WCEL.WCEL_id, 
SUBSTR(WCEL.name, INSTR(WCEL.name, '_') + 1, LENGTH(WCEL.name) - INSTR(WCEL.name, '_')) AS Sector, 
"PLMN-PLMN/RNC-" || WCEL.RNC_id || "/WBTS-" || WCEL.WBTS_Id || "/WCEL-" || WCEL.WCEL_id AS CellDN,
WBTS.name || "_" ||WCEL.SectorID AS SectorIdName, WCEL.moVersion,WCEL.WCELMCC,WCEL.WCELMNC,WCEL.SectorID, (WCEL.angle)/10 AS tilt,
b.SITIO, b.AMBIENTE_COBERTURA, b.REGION AS Region, b.DEPARTAMENTO AS Depto,	b.MUNICIPIO AS Mun, b.LOCALIDAD AS LocalidadCRC, 
b.GEO_REFERENCIA AS Cluster,
b.UBICACION, b.LATITUD, b.LONGITUD, b.ALTURA_ESTRUCTURA, b.BTS_NAME,b.BSC_NAME,b.SECTOR,b.ANTENA_TYPE,b.ALTURA_ANTENA,b.AZIMUTH,
b.TILT_ELECTRICO, b.TILT_MECANICO,b.TWIST,b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,
b.TIPO_AREA_COBERTURA,b.OWA
FROM ((RNC LEFT JOIN WBTS ON RNC.RNC_id = WBTS.RNC_id) LEFT JOIN WCEL ON (WBTS.WBTS_Id = WCEL.WBTS_Id) AND (WBTS.RNC_id = WCEL.RNC_id))
LEFT JOIN baseline AS b ON (b.Sitio = WBTS.name COLLATE NOCASE) AND (WCEL.name = b.BTS_Name COLLATE NOCASE)
WHERE WCEL.WCEL_id IS NOT NULL
ORDER BY WCEL.name IS NULL OR WCEL.name='', WCEL.name;
"""
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
'avgprachdelay', 'ActHS_DSCHendUserthp', 'LTE_NOT_FOUND_REDIR', 'RDRT_START_MEAS',
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
'rrc_conn_act_fail_rnc', 'RRC_CONN_ACT_FAIL_UE', 'RRCCONN_STPFL_frozbs', 
'RRC_CONN_STP_FL_AC_UL', 'RRCCONN_STPFL_AC_DL', 'RRCCONN_STPFL_AC_COD', 
'DCHSEL_MAXHSD_USRINT']
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
    rrc_conn_act_fail_rnc, RRC_CONN_ACT_FAIL_UE, RRCCONN_STPFL_frozbs, 
    RRC_CONN_STP_FL_AC_UL, RRCCONN_STPFL_AC_DL, RRCCONN_STPFL_AC_COD, 
    DCHSEL_MAXHSD_USRINT 
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
    t.ActHS_DSCHendUserthp, t.LTE_NOT_FOUND_REDIR, t.RDRT_START_MEAS, t.CS_VOICE_DRP_AFT_MISSING_ADJ,
    t.MAXIMUM_PTXTOTAL, t.rab_act_fail_cs_voice_bts, t.rab_act_fail_cs_voice_iu,
    t.rab_act_fail_cs_voice_iur, t.rab_act_fail_cs_voice_radio, t.rab_act_fail_cs_voice_rnc,
    t.RAB_ACT_FAIL_CS_VOICE_TRANS, t.RAB_ACT_FAIL_CS_VOICE_UE, t.rab_acc_fail_cs_voice_rnc,
    t.rab_acc_fail_cs_voice_ms, t.rab_stp_fail_cs_voice_ac, t.rab_stp_fail_cs_voice_bts,
    t.rab_stp_fail_cs_voice_frozbs, t.rab_stp_fail_cs_voice_rnc, t.rab_stp_fail_cs_voice_trans,
    t.rrc_conn_acc_fail_rnc, t.rrc_conn_act_fail_radio, t.rrc_conn_acc_fail_ms,
    t.rrc_conn_act_fail_iu, t.RRC_CONN_ACT_FAIL_TRANS, t.rrc_conn_stp_fail_ac,
    t.rrc_conn_stp_fail_bts, t.rrc_conn_stp_fail_hc, t.rrc_conn_stp_fail_rnc,
    t.rrc_conn_stp_fail_trans, t.rrc_conn_act_fail_bts, t.rrc_conn_act_fail_iur,
    t.rrc_conn_act_fail_rnc, t.RRC_CONN_ACT_FAIL_UE, t.RRCCONN_STPFL_frozbs, 
    t.RRC_CONN_STP_FL_AC_UL, t.RRCCONN_STPFL_AC_DL, t.RRCCONN_STPFL_AC_COD, 
    t.DCHSEL_MAXHSD_USRINT  
    """
umtssql5 = ", w.Cluster, w.Sector, w.SectorID, w.Banda, w.UARFCN, c.Responsable "  
umtssql3 = """
    FROM ((UMTS AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName COLLATE NOCASE) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster COLLATE NOCASE) 
    INNER JOIN temptable AS r ON 
    """
rtwpsql3 = """
    FROM ((RTWP AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName COLLATE NOCASE) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster COLLATE NOCASE) 
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
rtwpsql1 = """
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach, w.Cluster,
    w.Sector, w.SectorID, w.Banda, w.UARFCN, c.Responsable  
    """
sqlxtrtcer1 = (rtwpsql1 + rtwpsql3 +  
" (t.WCELname = r.WCELName COLLATE NOCASE) " + umtssql4)
sqlxtrtcer2 = (rtwpsql1 + rtwpsql3 + 
" (w.Prefijo = r.Prefijo COLLATE NOCASE) " + umtssql4)
sqlxtrtcer3 = (rtwpsql1 + rtwpsql3 + 
" (w.Cluster = r.Cluster COLLATE NOCASE) " + umtssql4)
sqlxtrtcer4 = (rtwpsql1 + rtwpsql3 + 
" (c.Responsable = r.Responsable COLLATE NOCASE) " + umtssql4)  
sqlxtrtcel1 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (t.WCELname = r.WCELName COLLATE NOCASE) " + umtssql4)
sqlxtrtcel2 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (w.Prefijo = r.Prefijo COLLATE NOCASE) " + umtssql4)
sqlxtrtcel3 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (w.Cluster = r.Cluster COLLATE NOCASE) " + umtssql4)
sqlxtrtcel4 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (c.Responsable = r.Responsable COLLATE NOCASE) " + umtssql4)
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
print('dBAct(1), Getdata(2), Both(3), TabSave(4): ')
opt,verif=inputval()  # option selection1
if verif == 3:
    print('Default value taken TabSave(4)')
    opt=4
if opt != 4:
    print('UMTS: Kpi(1), RTWP(2), Both(3)')
    opt1,verif1=inputval()  # option selection2
    if verif1 == 3:
        print('Default value taken Both(3)')
        opt1=3
    if (opt != 2):  # update
        dbdumplist = glob.glob(str(dbtgt.parent) +'/*_sqlite.dba')  # get latest dump in sqlite dir
        latestdump = max(dbdumplist, key=os.path.getctime)
        print(latestdump)
        connd = sqlite3.connect(latestdump)
        curd = connd.cursor()
        curd.execute("DROP TABLE IF EXISTS WCEL_PARAM2;")  # prepare wcel_param in dump to copy to kpi.db
        curd.execute(wcelfulsql)
        conn = sqlite3.connect(dbtgt)
        cur = conn.cursor()
        cur.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")  # copy wcel_param1 to kpi.db
        df = pd.read_sql_query("select * from WCEL_PARAM2;", connd, index_col=None)  # pandas dataframe from sqlite
        df.to_sql('wcel_param', conn, if_exists='replace', index=False, chunksize=10000)
        cur.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to kpi.db
        dfcluster = pd.read_excel(xlspath.parent / 'distribucion.xlsb', sheet_name='Cluster_Dist', index_col=0 ,engine='pyxlsb')
        dfcluster.to_sql('cluster', conn, if_exists='replace', index=False, chunksize=10000)
        if opt1 != 1:  # RTWP or both 
            # netactf = pathrep + today.strftime("%Y%m%d") + "/Analisis_RTWP_3G_NorOcc*.gz"
            # netactf = pathrep + today.strftime("%Y%m%d") + "/AMDOCS_NOURT_RC*.gz"
            # netactf = pathrep + "CustomReports/AMDOCS_NOURT_RC*.gz"
            listrc = ['07', '08'] # RC list for copy iteration
            for rc in listrc:
                dbdumplist = glob.glob(str(pathrep) +'/CustomReports/AMDOCS_NOURT_RC' + rc + '*.gz')  # get rc latest file in customreports
                latestdump = max(dbdumplist, key=os.path.getctime)
                netactimp(latestdump, xlspath)  # network file import
            for baself in xlspath.glob('*.csv'):  # file iteration inside directory add files if necessary
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
            # netactf = pathrep + today.strftime("%Y%m%d") + "/PT_3G_RC*.gz"
            # netactf = pathrep + today.strftime("%Y%m%d") + "/AMDOCS_NOUKPI_RC*.gz"
            # netactimp(netactf, xlspath1)
            listrc = ['07', '08'] # RC list for copy iteration
            for rc in listrc:
                dbdumplist = glob.glob(str(pathrep) +'/CustomReports/AMDOCS_NOUKPI_RC' + rc + '*.gz')  # get rc latest file in customreports
                latestdump = max(dbdumplist, key=os.path.getctime)
                netactimp(latestdump, xlspath1)  # network file import
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
            df3 = totemplate(conn, xlspath)  # info from sector_set
            xtrctyp = list(df3.columns)  # column names from sector_set  
            xtrctyp1 = xtrctypr(xtrctyp[0])  # query selection based on filter option
            if xtrctyp1 == 0:
                print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
            else:
                totemplate1(conn, xlspath, xtrctyp1)
        if opt1 != 2:  # kpi or both
            df3 = totemplate(conn, xlspath1)
            xtrctyp = list(df3.columns)
            xtrctyp1 = xtrctype(xtrctyp[0])
            if xtrctyp1 == 0:
                print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
            else:
                totemplate1(conn, xlspath1, xtrctyp1)
else:
    proc = [4]
    for iter1 in proc:
        if iter1 == 1:
            tabs = ['rtwp7day']
            filen = 'RTWP_Audit'
            sqltabexport(conn, tabs, filen, dbtgt)
        if iter1 == 2:
            tabs = ['hopicustom']
            filen = 'hopicustom'
            sqltabexport(conn, tabs, filen, dbtgt)
        if iter1 == 3:
            tabs = ['rtwpcell']
            filen = 'RTWPcell'
            sqltabexport(conn, tabs, filen, dbtgt)
        if iter1 == 4:
            tabs = ['temptable','temptable1']
            filen = 'RTWPcompare'
            sqltabexport(conn, tabs, filen, dbtgt)
cur.close()
conn.close()
print('ok')
