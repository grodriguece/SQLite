import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
from datetime import datetime
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

def inputdate():
    verif = 0
    formatd = '%y/%m/%d'
    while verif < 3:
        dateinit= str(input())
        try:
            dateinitf = datetime.strptime(dateinit, formatd)
            dateinitf = dateinitf.date()
            print('Start date: {date1}'.format(date1=dateinitf))
            verif = 4
        except ValueError:
            print('Invalid date format.yy/mm/dd')
            verif+=1
            dateinitf = datetime.strptime('21/01/01', formatd)
            dateinitf = dateinitf.date()
    print('Start date: {finaldate}'.format(finaldate=dateinitf))
    return dateinitf, verif

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

def xtrctype(filtype):  # kpi UMTS
    switcher = {
        'WCELName': sqlxtrtcel1,
        'Prefijo': sqlxtrtcel2,
        'Cluster': sqlxtrtcel3,
        'Responsable': sqlxtrtcel4,
        'WBTSName': sqlxtrtcel5,
    }
    return switcher.get(filtype, 0)  # 0 if not found

def xtrctypr(filtype):
    switcher = {
        'WCELName': sqlxtrtcer1,
        'Prefijo': sqlxtrtcer2,
        'Cluster': sqlxtrtcer3,
        'Responsable': sqlxtrtcer4,
        'WBTSName': sqlxtrtcer5,
    }
    return switcher.get(filtype, 0)  # 0 if not found

def xtrctypelr(filtype):
    switcher = {
        'LNBTSname': sqlxtrtcerl1,
        'LNCELname': sqlxtrtcerl2,
    }
    return switcher.get(filtype, 0)  # 0 if not found

def xtrctypel(filtype):
    switcher = {
        'LNBTSname': sqlxtrtcl2,
    }
    return switcher.get(filtype, 0)  # 0 if not found    

def folderc(xlspathc):  # folder creation if not available
    (xlspathc / 'output').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'raw').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'tab').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files    
    return

def netactimp(netactf, pathdest):  # file retrieve from network location 
    # cmdir = 'dir "%s"' % (str(PureWindowsPath(netactf))) 
    # subprocess.call(cmdir, shell=True)
    # cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(netactf)), str(PureWindowsPath(pathdest)) )
    # subprocess.call(cmcopy, shell=True)
    subprocess.call(exe + " e " + str(PureWindowsPath(pathdest)) + "\*.gz" + " -o" 
    + str(PureWindowsPath(pathdest)))
    cleandir(pathdest, 'gz')
    cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(pathdest)) + "\*.csv", str(PureWindowsPath(pathdest)) + "\\raw")
    subprocess.call(cmcopy, shell=True)
    return

def totemplate(connt, curt, xlspath): # get info to load xlsb template
    ftab1 = 'sector_set.csv'  # sector names to extract
    df3 = pd.read_csv(xlspath / 'tab' / ftab1)
    curt.execute("DROP TABLE IF EXISTS temptable;")
    df3.to_sql('temptable', connt, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    return df3

def totemplateh(connt, curt, df4): # get info to load xlsb template into hystdb
    curt.execute("DROP TABLE IF EXISTS temptable;")
    df4.to_sql('temptable', connt, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df4)))
    return    

def totemplate1(conn, xlspath, sqlxtrtcel): # get info to load xlsb template    
    df = pd.read_sql_query(sqlxtrtcel, conn)
    cleandir(xlspath / 'output', 'csv')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
    return

def totemplate2(connt, conntk1 , datetk, xlspath1, sqlxtrtcel): # get info to load xlsb template    
    sqlxtrtcelful = sqlxtrtcel + "AND t.DAY >= '" + str(datetk) + "';"
    dfkh = pd.read_sql_query(sqlxtrtcelful, conntk1) 
    dfk = pd.read_sql_query(sqlxtrtcelful, connt)
    dfcon = pd.concat([dfkh,dfk]).drop_duplicates().reset_index(drop=True)
    cleandir(xlspath1 / 'output', 'csv')  # clean output dir
    dfcon.to_csv(xlspath1 / 'output' / Path('totemplate.csv'), index=False)
    return

colltesql = """
    Day,MRBTSname,LNBTSname,LNCELname,SAMPLES_CELL_AVAIL,DENOM_CELL_AVAIL,
    SAMPLES_CELL_PLAN_UNAVAIL,RACH_STP_ATT_SMALL_MSG,RACH_STP_ATT_LARGE_MSG,
    RACH_STP_ATT_DEDICATED,RACH_STP_COMPLETIONS,SIGN_CONN_ESTAB_ATT_MO_S,
    SIGN_CONN_ESTAB_ATT_MT,SIGN_CONN_ESTAB_ATT_MO_D,SIGN_CONN_ESTAB_ATT_EMG,
    SIGN_CONN_ESTAB_ATT_HIPRIO,SIGN_CONN_ESTAB_ATT_DEL_TOL,SIGN_CONN_ESTAB_ATT_OTHERS,
    SIGN_CONN_ESTAB_COMP,SIGN_CONN_ESTAB_ATT_MO_VOICE,SIGN_CONN_ESTAB_FAIL_OAM_INT,
    SIGN_CONN_ESTAB_FAIL_RB_EMG,SIGN_CONN_ESTAB_FAIL_OVLCP,SIGN_CONN_ESTAB_FAIL_OVLUP,
    SIGN_CONN_ESTAB_FAIL_PUCCH,SIGN_CONN_ESTAB_FAIL_MAXRRC,SIGN_CONN_ESTAB_FAIL_OVLMME,
    SIGN_CONN_ESTAB_FAIL_CP_POOL,SIGN_CONN_ESTAB_FAIL_ENB_INT,SIGN_CONN_ESTAB_FAIL_DEPR_AC,
    SIGN_CONN_ESTAB_FAIL_OTHER,EPS_BEARER_SETUP_ATTEMPTS,EPS_BEARER_SETUP_COMPLETIONS,
    ERAB_REL_HO_PART,ERAB_REL_ENB,ERAB_REL_ENB_RNL_INA,ERAB_REL_ENB_RNL_RED,
    EPC_EPS_BEARER_REL_REQ_RNL,EPC_EPS_BEARER_REL_REQ_OTH,ERAB_REL_EPC_PATH_SWITCH,
    ERAB_REL_TEMP_QCI1,ERAB_REL_DOUBLE_S1,ERAB_REL_ENB_INI_S1_GLOB_RESET,
    ERAB_REL_ENB_INI_S1_PART_RESET,ERAB_REL_MME_INI_S1_GLOB_RESET,
    ERAB_REL_MME_INI_S1_PART_RESET,ERAB_REL_S1_OUTAGE,ERAB_REL_HO_SUCC,
    EPC_EPS_BEARER_REL_REQ_NORM,EPC_EPS_BEARER_REL_REQ_DETACH,EPC_EPS_BEAR_REL_REQ_N_QCI1,
    EPC_EPS_BEAR_REL_REQ_D_QCI1,ERAB_REL_SUCC_HO_UTRAN,ERAB_REL_SUCC_HO_GERAN,
    ERAB_ADD_SETUP_FAIL_RNL_RRNA,ERAB_ADD_SETUP_FAIL_TNL_TRU,ERAB_ADD_SETUP_FAIL_RNL_UEL,
    ERAB_ADD_SETUP_FAIL_RNL_RIP,ERAB_ADD_SETUP_FAIL_UP,ERAB_ADD_SETUP_FAIL_RNL_MOB,
    ERAB_INI_SETUP_FAIL_NO_UE_LIC,ERAB_REL_ENB_RNL_PREEM,PDCP_SDU_VOL_UL,PDCP_SDU_VOL_DL,
    PDCP_DATA_RATE_MAX_DL,PDCP_DATA_RATE_MAX_UL,IP_TPUT_VOL_DL_QCI_5,IP_TPUT_VOL_DL_QCI_6,
    IP_TPUT_VOL_DL_QCI_7,IP_TPUT_VOL_DL_QCI_8,IP_TPUT_VOL_DL_QCI_9,IP_TPUT_TIME_DL_QCI_5,
    IP_TPUT_TIME_DL_QCI_6,IP_TPUT_TIME_DL_QCI_7,IP_TPUT_TIME_DL_QCI_8,IP_TPUT_TIME_DL_QCI_9,
    IP_TPUT_VOL_UL_QCI_5,IP_TPUT_VOL_UL_QCI_6,IP_TPUT_VOL_UL_QCI_7,IP_TPUT_VOL_UL_QCI_8,
    IP_TPUT_VOL_UL_QCI_9,IP_TPUT_TIME_UL_QCI_5,IP_TPUT_TIME_UL_QCI_6,IP_TPUT_TIME_UL_QCI_7,
    IP_TPUT_TIME_UL_QCI_8,IP_TPUT_TIME_UL_QCI_9,INTER_ENB_HO_PREP,ATT_INTER_ENB_HO,
    INTER_X2_LB_PREP_FAIL_AC,SUCC_INTER_ENB_HO,INTER_X2_HO_PREP_FAIL_QCI,SUCC_INTRA_ENB_HO,
    INTRA_ENB_HO_PREP,FAIL_ENB_HO_PREP_OTH,ATT_INTRA_ENB_HO,FAIL_ENB_HO_PREP_AC,
    INTER_ENB_S1_HO_PREP,INTER_ENB_S1_HO_ATT,INTER_S1_LB_PREP_FAIL_AC,INTER_ENB_S1_HO_SUCC,
    INTER_S1_HO_PREP_FAIL_TIME,INTER_S1_HO_PREP_FAIL_NORR,INTER_S1_HO_PREP_FAIL_OTHER,
    INTER_ENB_S1_HO_FAIL,HO_INTFREQ_SUCC,HO_INTFREQ_ATT,FAIL_ENB_HO_PREP_TIME,
    FAIL_ENB_HO_PREP_OTHER,AVG_RTWP_RX_ANT_1,AVG_RTWP_RX_ANT_2,AVG_RTWP_RX_ANT_3,
    AVG_RTWP_RX_ANT_4,PRB_USED_PDSCH,PRB_USED_PUSCH,UL_PRB_UTIL_TTI_LEVEL_1,
    UL_PRB_UTIL_TTI_LEVEL_2,UL_PRB_UTIL_TTI_LEVEL_3,UL_PRB_UTIL_TTI_LEVEL_4,
    UL_PRB_UTIL_TTI_LEVEL_5,UL_PRB_UTIL_TTI_LEVEL_6,UL_PRB_UTIL_TTI_LEVEL_7,
    UL_PRB_UTIL_TTI_LEVEL_8,UL_PRB_UTIL_TTI_LEVEL_9,UL_PRB_UTIL_TTI_LEVEL_10,
    DL_PRB_UTIL_TTI_LEVEL_1,DL_PRB_UTIL_TTI_LEVEL_2,DL_PRB_UTIL_TTI_LEVEL_3,
    DL_PRB_UTIL_TTI_LEVEL_4,DL_PRB_UTIL_TTI_LEVEL_5,DL_PRB_UTIL_TTI_LEVEL_6,
    DL_PRB_UTIL_TTI_LEVEL_7,DL_PRB_UTIL_TTI_LEVEL_8,DL_PRB_UTIL_TTI_LEVEL_9,
    DL_PRB_UTIL_TTI_LEVEL_10,UE_REP_CQI_LEVEL_01,UE_REP_CQI_LEVEL_02,UE_REP_CQI_LEVEL_03,
    UE_REP_CQI_LEVEL_04,UE_REP_CQI_LEVEL_05,UE_REP_CQI_LEVEL_06,UE_REP_CQI_LEVEL_07,
    UE_REP_CQI_LEVEL_08,UE_REP_CQI_LEVEL_09,UE_REP_CQI_LEVEL_10,UE_REP_CQI_LEVEL_11,
    UE_REP_CQI_LEVEL_12,UE_REP_CQI_LEVEL_13,UE_REP_CQI_LEVEL_14,UE_REP_CQI_LEVEL_15,
    UE_REP_CQI_LEVEL_00,PDCP_SDU_DELAY_DL_DTCH_MEAN,PDCP_SDU_DELAY_UL_DTCH_MEAN,
    RRC_CONNECTED_UE_AVG,RRC_CONNECTED_UE_MAX,RRC_CONN_UE_AVG,RRC_CONN_UE_MAX,
    SUM_RRC_CONNECTED_UE,SUM_RRC_CONN_UE,DENOM_RRC_CONNECTED_UE,DENOM_RRC_CONN_UE,
    AvgUEdistance 
    """
ltesql2 = """
    t.'Day', t.'MRBTS name', t.'LNBTS name', t.'LNCEL name', 
    t.'SAMPLES_CELL_AVAIL (M8020C3)', t.'DENOM_CELL_AVAIL (M8020C6)', 
    t.'SAMPLES_CELL_PLAN_UNAVAIL (M8020C4)', t.'RACH_STP_ATT_SMALL_MSG (M8001C6)', 
    t.'RACH_STP_ATT_LARGE_MSG (M8001C7)', t.'RACH_STP_ATT_DEDICATED (M8001C286)', 
    t.'RACH_STP_COMPLETIONS (M8001C8)', t.'SIGN_CONN_ESTAB_ATT_MO_S (M8013C17)', 
    t.'SIGN_CONN_ESTAB_ATT_MT (M8013C18)', t.'SIGN_CONN_ESTAB_ATT_MO_D (M8013C19)', 
    t.'SIGN_CONN_ESTAB_ATT_EMG (M8013C21)', t.'SIGN_CONN_ESTAB_ATT_HIPRIO (M8013C31)', 
    t.'SIGN_CONN_ESTAB_ATT_DEL_TOL (M8013C34)', t.'SIGN_CONN_ESTAB_ATT_OTHERS (M8013C91)', 
    t.'SIGN_CONN_ESTAB_COMP (M8013C5)', t.'SIGN_CONN_ESTAB_ATT_MO_VOICE (M8013C93)', 
    t.'SIGN_CONN_ESTAB_FAIL_OAM_INT (M8013C122)', t.'SIGN_CONN_ESTAB_FAIL_RB_EMG (M8013C27)', 
    t.'SIGN_CONN_ESTAB_FAIL_OVLCP (M8013C65)', t.'SIGN_CONN_ESTAB_FAIL_OVLUP (M8013C66)', 
    t.'SIGN_CONN_ESTAB_FAIL_PUCCH (M8013C67)', t.'SIGN_CONN_ESTAB_FAIL_MAXRRC (M8013C68)', 
    t.'SIGN_CONN_ESTAB_FAIL_OVLMME (M8013C69)', t.'SIGN_CONN_ESTAB_FAIL_CP_POOL (M8013C75)', 
    t.'SIGN_CONN_ESTAB_FAIL_ENB_INT (M8013C96)', t.'SIGN_CONN_ESTAB_FAIL_DEPR_AC (M8013C97)', 
    t.'SIGN_CONN_ESTAB_FAIL_OTHER (M8013C99)', t.'EPS_BEARER_SETUP_ATTEMPTS (M8006C0)', 
    t.'EPS_BEARER_SETUP_COMPLETIONS (M8006C1)', t.'ERAB_REL_HO_PART (M8006C261)', 
    t.'ERAB_REL_ENB (M8006C254)', t.'ERAB_REL_ENB_RNL_INA (M8006C255)', 
    t.'ERAB_REL_ENB_RNL_RED (M8006C258)', t.'EPC_EPS_BEARER_REL_REQ_RNL (M8006C8)', 
    t.'EPC_EPS_BEARER_REL_REQ_OTH (M8006C9)', t.'ERAB_REL_EPC_PATH_SWITCH (M8006C277)', 
    t.'ERAB_REL_TEMP_QCI1 (M8006C301)', t.'ERAB_REL_DOUBLE_S1 (M8006C314)', 
    t.'ERAB_REL_ENB_INI_S1_GLOB_RESET (M8006C309)', t.'ERAB_REL_ENB_INI_S1_PART_RESET (M8006C311)', 
    t.'ERAB_REL_MME_INI_S1_GLOB_RESET (M8006C310)', t.'ERAB_REL_MME_INI_S1_PART_RESET (M8006C312)', 
    t.'ERAB_REL_S1_OUTAGE (M8006C313)', t.'ERAB_REL_HO_SUCC (M8006C263)', 
    t.'EPC_EPS_BEARER_REL_REQ_NORM (M8006C6)', t.'EPC_EPS_BEARER_REL_REQ_DETACH (M8006C7)', 
    t.'EPC_EPS_BEAR_REL_REQ_N_QCI1 (M8006C89)', t.'EPC_EPS_BEAR_REL_REQ_D_QCI1 (M8006C98)', 
    t.'ERAB_REL_SUCC_HO_UTRAN (M8006C303)', t.'ERAB_REL_SUCC_HO_GERAN (M8006C306)', 
    t.'ERAB_ADD_SETUP_FAIL_RNL_RRNA (M8006C248)', t.'ERAB_ADD_SETUP_FAIL_TNL_TRU (M8006C249)', 
    t.'ERAB_ADD_SETUP_FAIL_RNL_UEL (M8006C250)', t.'ERAB_ADD_SETUP_FAIL_RNL_RIP (M8006C251)', 
    t.'ERAB_ADD_SETUP_FAIL_UP (M8006C252)', t.'ERAB_ADD_SETUP_FAIL_RNL_MOB (M8006C253)', 
    t.'ERAB_INI_SETUP_FAIL_NO_UE_LIC (M8006C302)', t.'ERAB_REL_ENB_RNL_PREEM (M8006C341)', 
    t.'PDCP_SDU_VOL_UL (M8012C19)', t.'PDCP_SDU_VOL_DL (M8012C20)', 
    t.'PDCP_DATA_RATE_MAX_DL (M8012C25)', t.'PDCP_DATA_RATE_MAX_UL (M8012C22)', 
    t.'IP_TPUT_VOL_DL_QCI_5 (M8012C125)', t.'IP_TPUT_VOL_DL_QCI_6 (M8012C127)', 
    t.'IP_TPUT_VOL_DL_QCI_7 (M8012C129)', t.'IP_TPUT_VOL_DL_QCI_8 (M8012C131)', 
    t.'IP_TPUT_VOL_DL_QCI_9 (M8012C133)', t.'IP_TPUT_TIME_DL_QCI_5 (M8012C126)', 
    t.'IP_TPUT_TIME_DL_QCI_6 (M8012C128)', t.'IP_TPUT_TIME_DL_QCI_7 (M8012C130)', 
    t.'IP_TPUT_TIME_DL_QCI_8 (M8012C132)', t.'IP_TPUT_TIME_DL_QCI_9 (M8012C134)', 
    t.'IP_TPUT_VOL_UL_QCI_5 (M8012C99)', t.'IP_TPUT_VOL_UL_QCI_6 (M8012C101)', 
    t.'IP_TPUT_VOL_UL_QCI_7 (M8012C103)', t.'IP_TPUT_VOL_UL_QCI_8 (M8012C105)', 
    t.'IP_TPUT_VOL_UL_QCI_9 (M8012C107)', t.'IP_TPUT_TIME_UL_QCI_5 (M8012C100)', 
    t.'IP_TPUT_TIME_UL_QCI_6 (M8012C102)', t.'IP_TPUT_TIME_UL_QCI_7 (M8012C104)', 
    t.'IP_TPUT_TIME_UL_QCI_8 (M8012C106)', t.'IP_TPUT_TIME_UL_QCI_9 (M8012C108)', 
    t.'INTER_ENB_HO_PREP (M8014C0)', t.'ATT_INTER_ENB_HO (M8014C6)', 
    t.'INTER_X2_LB_PREP_FAIL_AC (M8014C44)', t.'SUCC_INTER_ENB_HO (M8014C7)', 
    t.'INTER_X2_HO_PREP_FAIL_QCI (M8014C41)', t.'SUCC_INTRA_ENB_HO (M8009C7)', 
    t.'INTRA_ENB_HO_PREP (M8009C2)', t.'FAIL_ENB_HO_PREP_OTH (M8009C5)', 
    t.'ATT_INTRA_ENB_HO (M8009C6)', t.'FAIL_ENB_HO_PREP_AC (M8009C3)', 
    t.'INTER_ENB_S1_HO_PREP (M8014C14)', t.'INTER_ENB_S1_HO_ATT (M8014C18)', 
    t.'INTER_S1_LB_PREP_FAIL_AC (M8014C45)', t.'INTER_ENB_S1_HO_SUCC (M8014C19)', 
    t.'INTER_S1_HO_PREP_FAIL_TIME (M8014C15)', t.'INTER_S1_HO_PREP_FAIL_NORR (M8014C16)', 
    t.'INTER_S1_HO_PREP_FAIL_OTHER (M8014C17)', t.'INTER_ENB_S1_HO_FAIL (M8014C20)', 
    t.'HO_INTFREQ_SUCC (M8021C2)', t.'HO_INTFREQ_ATT (M8021C0)', 
    t.'FAIL_ENB_HO_PREP_TIME (M8014C2)', t.'FAIL_ENB_HO_PREP_OTHER (M8014C5)', 
    t.'AVG_RTWP_RX_ANT_1 (M8005C306)', t.'AVG_RTWP_RX_ANT_2 (M8005C307)', 
    t.'AVG_RTWP_RX_ANT_3 (M8005C308)', t.'AVG_RTWP_RX_ANT_4 (M8005C309)', 
    t.'PRB_USED_PDSCH (M8011C54)', t.'PRB_USED_PUSCH (M8011C50)', 
    t.'UL_PRB_UTIL_TTI_LEVEL_1 (M8011C12)', t.'UL_PRB_UTIL_TTI_LEVEL_2 (M8011C13)', 
    t.'UL_PRB_UTIL_TTI_LEVEL_3 (M8011C14)', t.'UL_PRB_UTIL_TTI_LEVEL_4 (M8011C15)', 
    t.'UL_PRB_UTIL_TTI_LEVEL_5 (M8011C16)', t.'UL_PRB_UTIL_TTI_LEVEL_6 (M8011C17)', 
    t.'UL_PRB_UTIL_TTI_LEVEL_7 (M8011C18)', t.'UL_PRB_UTIL_TTI_LEVEL_8 (M8011C19)', 
    t.'UL_PRB_UTIL_TTI_LEVEL_9 (M8011C20)', t.'UL_PRB_UTIL_TTI_LEVEL_10 (M8011C21)', 
    t.'DL_PRB_UTIL_TTI_LEVEL_1 (M8011C25)', t.'DL_PRB_UTIL_TTI_LEVEL_2 (M8011C26)', 
    t.'DL_PRB_UTIL_TTI_LEVEL_3 (M8011C27)', t.'DL_PRB_UTIL_TTI_LEVEL_4 (M8011C28)', 
    t.'DL_PRB_UTIL_TTI_LEVEL_5 (M8011C29)', t.'DL_PRB_UTIL_TTI_LEVEL_6 (M8011C30)', 
    t.'DL_PRB_UTIL_TTI_LEVEL_7 (M8011C31)', t.'DL_PRB_UTIL_TTI_LEVEL_8 (M8011C32)', 
    t.'DL_PRB_UTIL_TTI_LEVEL_9 (M8011C33)', t.'DL_PRB_UTIL_TTI_LEVEL_10 (M8011C34)', 
    t.'UE_REP_CQI_LEVEL_01 (M8010C37)', t.'UE_REP_CQI_LEVEL_02 (M8010C38)', 
    t.'UE_REP_CQI_LEVEL_03 (M8010C39)', t.'UE_REP_CQI_LEVEL_04 (M8010C40)', 
    t.'UE_REP_CQI_LEVEL_05 (M8010C41)', t.'UE_REP_CQI_LEVEL_06 (M8010C42)', 
    t.'UE_REP_CQI_LEVEL_07 (M8010C43)', t.'UE_REP_CQI_LEVEL_08 (M8010C44)', 
    t.'UE_REP_CQI_LEVEL_09 (M8010C45)', t.'UE_REP_CQI_LEVEL_10 (M8010C46)', 
    t.'UE_REP_CQI_LEVEL_11 (M8010C47)', t.'UE_REP_CQI_LEVEL_12 (M8010C48)', 
    t.'UE_REP_CQI_LEVEL_13 (M8010C49)', t.'UE_REP_CQI_LEVEL_14 (M8010C50)', 
    t.'UE_REP_CQI_LEVEL_15 (M8010C51)', t.'UE_REP_CQI_LEVEL_00 (M8010C36)', 
    t.'PDCP_SDU_DELAY_DL_DTCH_MEAN (M8001C2)', t.'PDCP_SDU_DELAY_UL_DTCH_MEAN (M8001C5)', 
    t.'RRC_CONNECTED_UE_AVG (M8051C55)', t.'RRC_CONNECTED_UE_MAX (M8051C56)', 
    t.'RRC_CONN_UE_AVG (M8001C199)', t.'RRC_CONN_UE_MAX (M8001C200)', 
    t.'SUM_RRC_CONNECTED_UE (M8051C60)', t.'SUM_RRC_CONN_UE (M8001C318)', 
    t.'DENOM_RRC_CONNECTED_UE (M8051C61)', t.'DENOM_RRC_CONN_UE (M8001C319)', 
    t.'Avg UE distance'    
    """
ltefulsql = """
CREATE TABLE LTE_PARAM2 AS
SELECT DISTINCT
LNCEL.name AS LNCELname, LNBTS.name||substr(LNCEL.name,-1,1) AS KeySector, 
LNCEL.PLMN_id, substr(LNCEL.name,1,3) AS Prefijo, substr(LNCEL.name,-1,1) AS Sector, LNCEL_FDD.earfcnDL, 
CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 2750 and 3449 THEN 2600 
ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 600 and 1199 THEN 1900 ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 9210 and 9659 THEN 700 
ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 2400 and 2649 THEN 850 ELSE NULL END)END)END)END AS Banda, 
LNCEL.MRBTS_id,LNCEL.LNBTS_id,LNCEL.LNCEL_id,
LNBTS.name AS LNBTSname, LNBTS.operationalState AS LNBTS_OpSt, LNCEL.administrativeState AS LNCEL_AdSt, LNCEL.Operationalstate AS LNCEL_OpSt, 
CASE WHEN LNCEL_FDD.dlRsBoost=700 THEN -3 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1000 THEN 0 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1177 THEN 1.77 
ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1300 THEN 3 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1477 THEN 4.77 
ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1600 THEN 6 ELSE NULL END)END)END)END)END)END AS PowerBoost, LNCEL.phyCellId, 
"PLMN-" || LNCEL.PLMN_id || "/MRBTS-" ||LNCEL.mrbts_Id || "/LNBTS-" || LNCEL.lnBts_Id || "/LNCEL-" || LNCEL.lnCel_Id AS DistName, 
CASE WHEN (LNBTS.operationalState=5 AND LNCEL.administrativeState=1 AND LNCEL.operationalState=1) THEN 1 ELSE 0 END AS Estado,
LNCEL.moVersion, LNCEL.tac, (LNCEL.angle)/10 AS tilt,
b.SITIO, b.AMBIENTE_COBERTURA, b.REGION AS Region, b.DEPARTAMENTO AS Depto,	b.MUNICIPIO AS Mun, b.LOCALIDAD AS LocalidadCRC, 
b.GEO_REFERENCIA AS Cluster,
b.UBICACION, b.LATITUD, b.LONGITUD, b.ALTURA_ESTRUCTURA, b.BTS_NAME,b.SECTOR,b.ANTENA_TYPE,b.ALTURA_ANTENA,b.AZIMUTH,
b.TILT_ELECTRICO, b.TILT_MECANICO,b.TWIST,b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,
b.TIPO_AREA_COBERTURA,b.OWA
FROM ((LNCEL LEFT JOIN LNBTS ON (LNCEL.PLMN_Id=LNBTS.PLMN_Id) AND (LNCEL.MRBTS_Id=LNBTS.MRBTS_Id) AND (LNCEL.LNBTS_Id=LNBTS.LNBTS_Id))
LEFT JOIN LNCEL_FDD ON (LNCEL.PLMN_Id=LNCEL_FDD.PLMN_Id) AND (LNCEL.MRBTS_Id=LNCEL_FDD.MRBTS_Id) AND (LNCEL.LNBTS_Id=LNCEL_FDD.LNBTS_Id) AND
(LNCEL.LNCEL_Id=LNCEL_FDD.LNCEL_Id))  
LEFT JOIN baseline AS b ON (b.Sitio = LNBTS.name COLLATE NOCASE) AND (LNCEL.name = b.BTS_Name COLLATE NOCASE) 
WHERE LNCEL.LNCEL_Id IS NOT NULL 
GROUP BY LNCEL.eutraCelId 
ORDER BY LNCEL.name IS NULL OR LNCEL.name='', LNCEL.name;
"""
wcelfulsql = """
CREATE TABLE WCEL_PARAM2 AS
SELECT DISTINCT
WCEL.name AS WCELName, substr(WCEL.name,1,3) AS Prefijo, WCEL.UARFCN, CASE WHEN WCEL.UARFCN < 9685 THEN 850 ELSE 1900 END Banda,
WBTS.name AS WBTSName, WCEL.PLMN_id, RNC.name AS RNCName, RNC.RNC_id AS RNCid, WBTS.WBTS_id, WCEL.WCEL_id, 
SUBSTR(WCEL.name, INSTR(WCEL.name, '_') + 1, LENGTH(WCEL.name) - INSTR(WCEL.name, '_')) AS Sector, 
"PLMN-PLMN/RNC-" || WCEL.RNC_id || "/WBTS-" || WCEL.WBTS_Id || "/WCEL-" || WCEL.WCEL_id AS CellDN,
WBTS.name || "_" ||WCEL.SectorID AS SectorIdName, WCEL.moVersion,WCEL.WCELMCC,WCEL.WCELMNC,WCEL.SectorID, (WCEL.angle)/10 AS tilt,
b.SITIO, b.AMBIENTE_COBERTURA, b.REGION AS Region, b.DEPARTAMENTO AS Depto,	b.MUNICIPIO AS Mun, b.LOCALIDAD AS LocalidadCRC, 
b.GEO_REFERENCIA AS Cluster,
b.UBICACION, b.LATITUD, b.LONGITUD, b.ALTURA_ESTRUCTURA, b.BTS_NAME,b.BSC_NAME,b.SECTOR,b.ANTENA_TYPE,b.ALTURA_ANTENA,b.AZIMUTH,
b.TILT_ELECTRICO, b.TILT_MECANICO,b.TWIST,b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,
b.TIPO_AREA_COBERTURA,b.OWA, WCEL.PtxPrimaryCPICH, WCEL.PtxCellMax, WCEL.MaxDLPowerCapability
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
umtssql4 = """
    WHERE (w.Region = 'Noroccidente' COLLATE NOCASE OR 
    (w.Region = 'oriente' COLLATE NOCASE AND w.Depto = 'Antioquia' COLLATE NOCASE) OR
    (w.Region = 'suroccidente' COLLATE NOCASE AND w.Depto = 'Caldas' COLLATE NOCASE)) 
    """
colnam = {
    'RNC name': 'RNCname', 'WBTS name': 'WBTSname', 'WBTS ID': 'WBTSid',
    'WCEL name': 'WCELname', 'WCEL ID': 'WCELid', 'Average RTWP': 'AvgRTWP',
    'Total CS traffic - Erl': 'AvgCS_ERL',
    'Max simult HSDPA users': 'AvgMaxHSDPAusers', 'avgprach': 'AvgPrach'
    }
colnaml = {
    'MRBTS name': 'MRBTSname', 'LNBTS name': 'LNBTSname', 
    'LNCEL name': 'LNCELname', 'Avg RWTP RX ant 1': 'AvgRWTP1', 
    'Avg RWTP RX ant 2': 'AvgRWTP2', 'Avg RWTP RX ant 3': 'AvgRWTP3',
    'Avg RWTP RX ant 4': 'AvgRWTP4', 'Avg UE distance': 'AvgUEdist',
    'DL_PRB_UTIL_TTI_MEAN (M8011C37)': 'DL_PRB', 'PDCP_SDU_VOL_DL (M8012C20)': 'Data_Vol', 
    'RRC connected users, max': 'RRC_Users_Max'
    }
aggreg = {
    'Day': 'first', 'RNC name': 'first', 'WBTS name': 'first', 
    'WBTS ID': 'first', 'WCEL name': 'first', 'WCEL ID': 'first', 
    'Average RTWP': 'mean', 'Total CS traffic - Erl': 'mean', 
    'Max simult HSDPA users': 'mean', 'avgprach': 'mean'
    }
aggregl = {
    'Day': 'first', 'MRBTS name': 'first', 'LNBTS name': 'first', 
    'LNCEL name': 'first', 'Avg RWTP RX ant 1': 'mean', 'Avg RWTP RX ant 2': 'mean', 
    'Avg RWTP RX ant 3': 'mean', 'Avg RWTP RX ant 4': 'mean', 
    'Avg UE distance': 'mean', 'DL_PRB_UTIL_TTI_MEAN (M8011C37)': 'mean', 
    'PDCP_SDU_VOL_DL (M8012C20)': 'mean', 'RRC connected users, max': 'mean'
    }    
sqlinsert = """
    INSERT INTO RTWPU (Day, RNCname, WBTSname, WBTSid, WCELname, WCELid,
    AvgRTWP, AvgCS_ERL, AvgMaxHSDPAusers, AvgPrach) 
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM temptable AS t 
    WHERE NOT EXISTS (SELECT 1 FROM RTWPU AS r WHERE t.Day = r.Day 
    AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);
    """
sqlinsertl = """
    INSERT INTO RWTPL (Day, MRBTSname, LNBTSname, LNCELname, AvgRWTP1, 
    AvgRWTP2, AvgRWTP3, AvgRWTP4, AvgUEdist, DL_PRB, Data_Vol, RRC_Users_Max, AvgRWTP, PortMeas, DiffRWTP) 
    SELECT t.Day, t.MRBTSname, t.LNBTSname, t.LNCELname, t.AvgRWTP1, 
    t.AvgRWTP2, t.AvgRWTP3, t.AvgRWTP4, t.AvgUEdist, t.DL_PRB, 
    t.Data_Vol, t.RRC_Users_Max, t.AvgRWTP, t.PortMeas, t.DiffRWTP 
    FROM temptable AS t 
    WHERE NOT EXISTS (SELECT 1 FROM RWTPL AS r WHERE t.Day = r.Day 
    AND t.MRBTSname = r.MRBTSname AND t.LNCELname = r.LNCELname);
    """    
sqlinsert1 = ("INSERT INTO UMTS (" + columtssql + ") " +
" SELECT " + umtssql2 + " FROM temptable AS t " +
"WHERE NOT EXISTS " + "(SELECT 1 FROM UMTS AS r WHERE t.Day = r.Day " +
"AND t.RNCname = r.RNCname AND t.WCELid = r.WCELid);")

sqlinsert2 = ("INSERT INTO LTE (" + colltesql + ") " +
" SELECT " + ltesql2 + " FROM temptable AS t " + 
"WHERE NOT EXISTS " + "(SELECT 1 FROM LTE AS r WHERE t.'Day' = r.Day " + 
"AND t.'MRBTS name' = r.MRBTSname AND t.'LNCEL name' = r.LNCELname);")
rtwpsql1 = """
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach, w.Cluster,
    w.Sector, w.SectorID, w.Banda, w.UARFCN, c.Responsable  
    """
rtwpsql3 = """
    FROM ((RTWPU AS t LEFT JOIN wcel_param AS w ON t.WCELname = w.WCELName COLLATE NOCASE) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster COLLATE NOCASE) 
    INNER JOIN temptable AS r ON 
    """    
sqlxtrtcer1 = (rtwpsql1 + rtwpsql3 +  
" (t.WCELname = r.WCELName COLLATE NOCASE) " + umtssql4)
sqlxtrtcer2 = (rtwpsql1 + rtwpsql3 + 
" (w.Prefijo = r.Prefijo COLLATE NOCASE) " + umtssql4)
sqlxtrtcer3 = (rtwpsql1 + rtwpsql3 + 
" (w.Cluster = r.Cluster COLLATE NOCASE) " + umtssql4)
sqlxtrtcer4 = (rtwpsql1 + rtwpsql3 + 
" (c.Responsable = r.Responsable COLLATE NOCASE) " + umtssql4)
sqlxtrtcer5 = (rtwpsql1 + rtwpsql3 + 
" (t.WBTSname = r.WBTSname COLLATE NOCASE) " + umtssql4)
rwtpsql1 = """
    SELECT t.Day, t.MRBTSname, t.LNBTSname, t.LNCELname, t.AvgRWTP1, 
    t.AvgRWTP2, t.AvgRWTP3, t.AvgRWTP4, t.AvgUEdist, t.DL_PRB, 
    t.Data_Vol, t.RRC_Users_Max, t.AvgRWTP, t.PortMeas, t.DiffRWTP, w.Cluster,
    w.Sector, w.Banda, w.earfcnDL, c.Responsable  
    """
rwtpsql3 = """
    FROM ((RWTPL AS t LEFT JOIN lte_param AS w ON t.LNCELname = w.LNCELname COLLATE NOCASE) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster COLLATE NOCASE) 
    INNER JOIN temptable AS r ON 
    """ 
sqlxtrtcerl1 = (rwtpsql1 + rwtpsql3 + 
" (t.LNBTSname = r.LNBTSname COLLATE NOCASE) " + umtssql4)  # query selection for RWTP LNBTS based 
sqlxtrtcerl2 = (rwtpsql1 + rwtpsql3 + 
" (t.LNCELname = r.LNCELname COLLATE NOCASE) " + umtssql4)  # query selection for RWTP LNCEL based 
lkpisql3 = """
    FROM ((LTE AS t LEFT JOIN lte_param AS w ON t.LNCELname = w.LNCELname COLLATE NOCASE) 
    LEFT JOIN cluster AS c ON w.Cluster = c.Cluster COLLATE NOCASE)     
    INNER JOIN temptable AS r ON 
    """
lkpisql1 = """
SELECT 
t.Day,t.MRBTSname,t.LNBTSname,t.LNCELname,t.SAMPLES_CELL_AVAIL,t.DENOM_CELL_AVAIL,
t.SAMPLES_CELL_PLAN_UNAVAIL,t.RACH_STP_ATT_SMALL_MSG,
t.RACH_STP_ATT_LARGE_MSG,t.RACH_STP_ATT_DEDICATED,t.RACH_STP_COMPLETIONS,t.SIGN_CONN_ESTAB_ATT_MO_S,
t.SIGN_CONN_ESTAB_ATT_MT,t.SIGN_CONN_ESTAB_ATT_MO_D,
    t.SIGN_CONN_ESTAB_ATT_EMG,t.SIGN_CONN_ESTAB_ATT_HIPRIO,t.SIGN_CONN_ESTAB_ATT_DEL_TOL,
    t.SIGN_CONN_ESTAB_ATT_OTHERS,t.SIGN_CONN_ESTAB_COMP,t.SIGN_CONN_ESTAB_ATT_MO_VOICE,
    t.SIGN_CONN_ESTAB_FAIL_OAM_INT,t.SIGN_CONN_ESTAB_FAIL_RB_EMG,t.SIGN_CONN_ESTAB_FAIL_OVLCP,
    t.SIGN_CONN_ESTAB_FAIL_OVLUP,t.SIGN_CONN_ESTAB_FAIL_PUCCH,t.SIGN_CONN_ESTAB_FAIL_MAXRRC,
    t.SIGN_CONN_ESTAB_FAIL_OVLMME,t.SIGN_CONN_ESTAB_FAIL_CP_POOL,t.SIGN_CONN_ESTAB_FAIL_ENB_INT,
    t.SIGN_CONN_ESTAB_FAIL_DEPR_AC,t.SIGN_CONN_ESTAB_FAIL_OTHER,t.EPS_BEARER_SETUP_ATTEMPTS,
    t.EPS_BEARER_SETUP_COMPLETIONS,t.ERAB_REL_HO_PART,t.ERAB_REL_ENB,t.ERAB_REL_ENB_RNL_INA,
    t.ERAB_REL_ENB_RNL_RED,t.EPC_EPS_BEARER_REL_REQ_RNL,t.EPC_EPS_BEARER_REL_REQ_OTH,
    t.ERAB_REL_EPC_PATH_SWITCH,t.ERAB_REL_TEMP_QCI1,t.ERAB_REL_DOUBLE_S1,
    t.ERAB_REL_ENB_INI_S1_GLOB_RESET,t.ERAB_REL_ENB_INI_S1_PART_RESET,
    t.ERAB_REL_MME_INI_S1_GLOB_RESET,t.ERAB_REL_MME_INI_S1_PART_RESET,t.ERAB_REL_S1_OUTAGE,
    t.ERAB_REL_HO_SUCC,t.EPC_EPS_BEARER_REL_REQ_NORM,t.EPC_EPS_BEARER_REL_REQ_DETACH,
    t.EPC_EPS_BEAR_REL_REQ_N_QCI1,t.EPC_EPS_BEAR_REL_REQ_D_QCI1,t.ERAB_REL_SUCC_HO_UTRAN,
    t.ERAB_REL_SUCC_HO_GERAN,t.ERAB_ADD_SETUP_FAIL_RNL_RRNA,t.ERAB_ADD_SETUP_FAIL_TNL_TRU,
    t.ERAB_ADD_SETUP_FAIL_RNL_UEL,t.ERAB_ADD_SETUP_FAIL_RNL_RIP,t.ERAB_ADD_SETUP_FAIL_UP,
    t.ERAB_ADD_SETUP_FAIL_RNL_MOB,t.ERAB_INI_SETUP_FAIL_NO_UE_LIC,t.ERAB_REL_ENB_RNL_PREEM,
    t.PDCP_SDU_VOL_UL,t.PDCP_SDU_VOL_DL,t.PDCP_DATA_RATE_MAX_DL,t.PDCP_DATA_RATE_MAX_UL,
    t.IP_TPUT_VOL_DL_QCI_5,t.IP_TPUT_VOL_DL_QCI_6,t.IP_TPUT_VOL_DL_QCI_7,t.IP_TPUT_VOL_DL_QCI_8,
    t.IP_TPUT_VOL_DL_QCI_9,t.IP_TPUT_TIME_DL_QCI_5,t.IP_TPUT_TIME_DL_QCI_6,
    t.IP_TPUT_TIME_DL_QCI_7,t.IP_TPUT_TIME_DL_QCI_8,t.IP_TPUT_TIME_DL_QCI_9,t.IP_TPUT_VOL_UL_QCI_5,
    t.IP_TPUT_VOL_UL_QCI_6,t.IP_TPUT_VOL_UL_QCI_7,t.IP_TPUT_VOL_UL_QCI_8,
    t.IP_TPUT_VOL_UL_QCI_9,t.IP_TPUT_TIME_UL_QCI_5,t.IP_TPUT_TIME_UL_QCI_6,t.IP_TPUT_TIME_UL_QCI_7,
    t.IP_TPUT_TIME_UL_QCI_8,t.IP_TPUT_TIME_UL_QCI_9,t.INTER_ENB_HO_PREP,t.ATT_INTER_ENB_HO,
    t.INTER_X2_LB_PREP_FAIL_AC,t.SUCC_INTER_ENB_HO,t.INTER_X2_HO_PREP_FAIL_QCI,t.SUCC_INTRA_ENB_HO,
    t.INTRA_ENB_HO_PREP,t.FAIL_ENB_HO_PREP_OTH,t.ATT_INTRA_ENB_HO,t.FAIL_ENB_HO_PREP_AC,
    t.INTER_ENB_S1_HO_PREP,t.INTER_ENB_S1_HO_ATT,t.INTER_S1_LB_PREP_FAIL_AC,t.INTER_ENB_S1_HO_SUCC,
    t.INTER_S1_HO_PREP_FAIL_TIME,t.INTER_S1_HO_PREP_FAIL_NORR,t.INTER_S1_HO_PREP_FAIL_OTHER,
    t.INTER_ENB_S1_HO_FAIL,t.HO_INTFREQ_SUCC,t.HO_INTFREQ_ATT,t.FAIL_ENB_HO_PREP_TIME,
    t.FAIL_ENB_HO_PREP_OTHER,t.AVG_RTWP_RX_ANT_1,t.AVG_RTWP_RX_ANT_2,t.AVG_RTWP_RX_ANT_3,
    t.AVG_RTWP_RX_ANT_4,t.PRB_USED_PDSCH,t.PRB_USED_PUSCH,t.UL_PRB_UTIL_TTI_LEVEL_1,
    t.UL_PRB_UTIL_TTI_LEVEL_2,t.UL_PRB_UTIL_TTI_LEVEL_3,t.UL_PRB_UTIL_TTI_LEVEL_4,
    t.UL_PRB_UTIL_TTI_LEVEL_5,t.UL_PRB_UTIL_TTI_LEVEL_6,t.UL_PRB_UTIL_TTI_LEVEL_7,
    t.UL_PRB_UTIL_TTI_LEVEL_8,t.UL_PRB_UTIL_TTI_LEVEL_9,t.UL_PRB_UTIL_TTI_LEVEL_10,
    t.DL_PRB_UTIL_TTI_LEVEL_1,t.DL_PRB_UTIL_TTI_LEVEL_2,t.DL_PRB_UTIL_TTI_LEVEL_3,
    t.DL_PRB_UTIL_TTI_LEVEL_4,t.DL_PRB_UTIL_TTI_LEVEL_5,t.DL_PRB_UTIL_TTI_LEVEL_6,
    t.DL_PRB_UTIL_TTI_LEVEL_7,t.DL_PRB_UTIL_TTI_LEVEL_8,t.DL_PRB_UTIL_TTI_LEVEL_9,
    t.DL_PRB_UTIL_TTI_LEVEL_10,t.UE_REP_CQI_LEVEL_01,t.UE_REP_CQI_LEVEL_02,t.UE_REP_CQI_LEVEL_03,
    t.UE_REP_CQI_LEVEL_04,t.UE_REP_CQI_LEVEL_05,t.UE_REP_CQI_LEVEL_06,t.UE_REP_CQI_LEVEL_07,
    t.UE_REP_CQI_LEVEL_08,t.UE_REP_CQI_LEVEL_09,t.UE_REP_CQI_LEVEL_10,t.UE_REP_CQI_LEVEL_11,
    t.UE_REP_CQI_LEVEL_12,t.UE_REP_CQI_LEVEL_13,t.UE_REP_CQI_LEVEL_14,t.UE_REP_CQI_LEVEL_15,
    t.UE_REP_CQI_LEVEL_00,t.PDCP_SDU_DELAY_DL_DTCH_MEAN,t.PDCP_SDU_DELAY_UL_DTCH_MEAN,
    t.RRC_CONNECTED_UE_AVG,t.RRC_CONNECTED_UE_MAX,t.RRC_CONN_UE_AVG,t.RRC_CONN_UE_MAX,
    t.SUM_RRC_CONNECTED_UE,t.SUM_RRC_CONN_UE,t.DENOM_RRC_CONNECTED_UE,t.DENOM_RRC_CONN_UE,
    t.AvgUEdistance  
    """
sqlxtrtcl2 = (lkpisql1 + lkpisql3 +  
" (t.LNBTSname = r.LNBTSname COLLATE NOCASE) " + umtssql4)  # LTE kpi LNBTS based
sqlxtrtcel1 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (t.WCELname = r.WCELName COLLATE NOCASE) " + umtssql4)
sqlxtrtcel2 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (w.Prefijo = r.Prefijo COLLATE NOCASE) " + umtssql4)
sqlxtrtcel3 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (w.Cluster = r.Cluster COLLATE NOCASE) " + umtssql4)
sqlxtrtcel4 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (c.Responsable = r.Responsable COLLATE NOCASE) " + umtssql4)
sqlxtrtcel5 = ("SELECT " + umtssql2 + umtssql5 + umtssql3 + 
" (t.WBTSname = r.WBTSName COLLATE NOCASE) " + umtssql4)
xlspath1 = Path('C:/xml/baseline/TUMTS/')  # UMTS csv directory
xlspath = Path('C:/xml/baseline/RTWP/')  # RTWP csv directory
xlspath3 = Path('C:/xml/baseline/RTWPL/')  # LTE RTWP csv directory
xlspath2 = Path('C:/xml/baseline/TLTE/')  # LTE csv directory
folderc(xlspath2)  # folder creation
folderc(xlspath3)  # folder creation LTE RTWP
folderc(xlspath1)  # folder creation
folderc(xlspath)
dbtgt = Path('C:/sqlite/kpi_sqlite.db')  # working dB kpi actual
dbtgt1 = Path('C:/sqlite/kpi_sqlite1.db')  # kpi1 historic 1 db
dbtgtl = Path('C:/sqlite/lte_sqlite.db')  # working dB
dbtgtl1 = Path('C:/sqlite/lte_sqlite1.db')  # lte1 historic 1 dB
dbtgtr = Path('C:/sqlite/rtwp_sqlite.db')  # working dB RTWP
dbtgtr1 = Path('C:/sqlite/rtwp_sqlite1.db')  # rtwp1 historic 1 RTWP dB
today = date.today()
exe = "C:\\7za\\7za.exe"
pathrep ='C:/Users/germanro/OneDrive - AMDOCS/Custom_Reports/'
conn = sqlite3.connect(dbtgt)  # working dB Kpi
connk1 = sqlite3.connect(dbtgt1)  # hist1 dB Kpi 
connr = sqlite3.connect(dbtgtr)  # working dB RTWP
connr1 = sqlite3.connect(dbtgtr1)  # hist1 dB RTWP 
connl = sqlite3.connect(dbtgtl)  # working dB LTE
connl1 = sqlite3.connect(dbtgtl1)  # working dB LTE
cur = conn.cursor()  # working dB Kpi
curk1 = connk1.cursor()  # hist1 dB Kpi
curr = connr.cursor()  # working dB RTWP
curr1 = connr1.cursor()  # hist1 dB RTWP
curl = connl.cursor()  # working dB LTE
curl1 = connl1.cursor()  # hist1 dB LTE
dbdumplist = glob.glob(str(dbtgt.parent) +'/*_sqlite.dba')  # get latest dump in sqlite dir
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
connd = sqlite3.connect(latestdump)  
curd = connd.cursor()  # latest dump dB
print('dBAct(1), Getdata(2), Both(3), TabSave(4): ')
opt,verif=inputval()  # option selection1 
if verif == 3:  # none option
    print('Default value taken TabSave(4)')
    opt=4
if opt != 4:  # dBAct, Getdata, Both 
    if opt > 1:
        print('Fecha inicial:yy/mm/dd')
        dateini,verif3=inputdate()  # start date for data collection
    print('Kpi(1), RTWP(2), Both(3)')
    opt1,verif1=inputval()  # option selection2
    if verif1 == 3:  # none option
        print('Default value taken Both(3)')
        opt1=3
    print('LTE(1), UMTS(2), Both(3)')
    opt2,verif2=inputval()  # option selection2
    if verif2 == 3:  # none option
        print('Default value taken Both(3)')
        opt2=3
    if (opt2 != 1):  # UMTS or both
        if (opt != 2):  # UPDATE or both
            curd.execute("DROP TABLE IF EXISTS WCEL_PARAM2;")  # prepare wcel_param in dump to copy to kpi.db
            curd.execute(wcelfulsql)
            cur.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")  # copy wcel_param1 to kpi.db
            # curk1.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")  # copy wcel_param1 to kpi.db
            curr.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")  # copy wcel_param1 to kpi.db
            # curr1.execute("DROP TABLE IF EXISTS WCEL_PARAM1;")  # copy wcel_param1 to kpi.db
            df = pd.read_sql_query("select * from WCEL_PARAM2;", connd, index_col=None)  # pandas dataframe from sqlite dump
            df.to_sql('wcel_param', conn, if_exists='replace', index=False, chunksize=10000)  # wcelpar to kpi
            # df.to_sql('wcel_param', connk1, if_exists='replace', index=False, chunksize=10000)  # wcelpar to kpihist
            df.to_sql('wcel_param', connr, if_exists='replace', index=False, chunksize=10000)  #wcelpar to rtwp
            # df.to_sql('wcel_param', connr1, if_exists='replace', index=False, chunksize=10000)  #wcelpar to rtwphist
            cur.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to kpi.db
            dfcluster = pd.read_excel(xlspath.parent / 'distribucion.xlsb', sheet_name='Cluster_Dist', index_col=0 ,engine='pyxlsb')
            dfcluster.to_sql('cluster', conn, if_exists='replace', index=False, chunksize=10000)  # cluster to kpi
            # dfcluster.to_sql('cluster', connk1, if_exists='replace', index=False, chunksize=10000)  # cluster to kpihist
            dfcluster.to_sql('cluster', connr, if_exists='replace', index=False, chunksize=10000)  # cluster to rtwp
            # dfcluster.to_sql('cluster', connr1, if_exists='replace', index=False, chunksize=10000)  # cluster to rtwphist
            if opt1 != 1:  # RTWP or both 
                listrc = ['07', '08'] # RC list for copy iteration
                for rc in listrc:
                    dbdumplist = glob.glob(str(pathrep) +'/NOURT/AMDOCS_NOURT_RC' + rc + '*.gz')  # get rc latest file in customreports
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
                    curr.execute("DROP TABLE IF EXISTS temptable;")
                    tempo2.to_sql(  # temp table
                        'temptable', connr, if_exists='replace', index=False, chunksize=10000)
                    curr.execute(sqlinsert)  # insert avoiding duplicates
                    connr.commit()
                cleandir(xlspath, 'csv')  # delete processed files in root directory
            if opt1 != 2:  # kpi or both
                listrc = ['07', '08'] # RC list for copy iteration
                for rc in listrc:
                    dbdumplist = glob.glob(str(pathrep) +'/NOUKPI/AMDOCS_NOUKPI_RC' + rc + '*.gz')  # get rc latest file in customreports
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
        if (opt != 1):  # DATA XTRACT TO TEMPLATE CSV or both
            if opt1 != 1:  # RTWP or both 
                df3 = totemplate(connr, curr, xlspath)  # info from sector_set csv to rtwp
                totemplateh(connr1,curr1,df3)  # objects to extract into rtwphist
                xtrctyp = list(df3.columns)  # column names from sector_set  
                xtrctyp1 = xtrctypr(xtrctyp[0])  # query selection based on filter option
                if xtrctyp1 == 0:
                    print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
                else:
                    totemplate2(connr, connr1, dateini, xlspath, xtrctyp1)  # END OF RTWP PROCESS
            if opt1 != 2:  # kpi or both
                df3 = totemplate(conn, cur, xlspath1)  # objects to extract into kpi actual
                totemplateh(connk1,curk1,df3)  # objects to extract into kpihist  
                xtrctyp = list(df3.columns)  # extraction type
                xtrctyp1 = xtrctype(xtrctyp[0])  # query selection based on filter option
                if xtrctyp1 == 0:
                    print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
                else:
                    totemplate2(conn, connk1, dateini, xlspath1, xtrctyp1)  # END OF UMTS PROCESS
    if(opt2 !=2):  # LTE or both
        if (opt != 1):  # DATA XTRACT TO TEMPLATE CSV
            if opt1 != 1:  # RWTP or both 
                df3 = totemplate(connr, curr, xlspath3)  # info from sector_set
                totemplateh(connr1,curr1,df3)  # objects to extract into rtwphist
                xtrctyp = list(df3.columns)  # column names from sector_set  
                xtrctyp1 = xtrctypelr(xtrctyp[0])  # query selection based on filter option
                if xtrctyp1 == 0:
                    print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
                else:
                    totemplate2(connr, connr1, dateini, xlspath3, xtrctyp1)  # END OF RTWP PROCESS
            if opt1 != 2:  # LTE or both
                df3 = totemplate(connl, curl, xlspath2)  # objects to extract into LTEkpi actual
                totemplateh(connl1,curl1,df3)  # objects to extract into ltehist  
                xtrctyp = list(df3.columns)  # extraction type
                xtrctyp1 = xtrctypel(xtrctyp[0])  # query selection based on filter option
                if xtrctyp1 == 0:
                    print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
                else:
                    totemplate2(connl, connl1, dateini, xlspath2, xtrctyp1)  # END OF LTE PROCESS
        if (opt != 2):  # update
            curd.execute("DROP TABLE IF EXISTS LTE_Param2;")  # prepare LTE_param in dump to copy to lte.db
            curd.execute(ltefulsql)  # prepare LTE_Param2 in dump to copy to lte.db
            curl.execute("DROP TABLE IF EXISTS lte_param;")  # copy lte_param1 to lte.db
            # curl1.execute("DROP TABLE IF EXISTS lte_param;")  # copy lte_param1 to ltehist1.db
            curr.execute("DROP TABLE IF EXISTS lte_param;")  # copy lte_param1 to rtwp.db
            # curr1.execute("DROP TABLE IF EXISTS lte_param;")  # copy lte_param1 to rtwphist1.db
            df = pd.read_sql_query("select * from LTE_Param2;", connd, index_col=None)  # pandas dataframe from sqlite
            df.to_sql('lte_param', connl, if_exists='replace', index=False, chunksize=10000)
            # df.to_sql('lte_param', connl1, if_exists='replace', index=False, chunksize=10000)
            df.to_sql('lte_param', connr, if_exists='replace', index=False, chunksize=10000)
            # df.to_sql('lte_param', connr1, if_exists='replace', index=False, chunksize=10000)
            curl.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to lte.db
            # curl1.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to ltehist1.db
            curr.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to rtwp.db
            # curr1.execute("DROP TABLE IF EXISTS cluster;")  # copy cluster dist to rtwphist1.db
            dfcluster = pd.read_excel(xlspath.parent / 'distribucion.xlsb', sheet_name='Cluster_Dist', index_col=0 ,engine='pyxlsb')
            dfcluster.to_sql('cluster', connl, if_exists='replace', index=False, chunksize=10000)
            # dfcluster.to_sql('cluster', connl1, if_exists='replace', index=False, chunksize=10000)
            dfcluster.to_sql('cluster', connr, if_exists='replace', index=False, chunksize=10000)
            # dfcluster.to_sql('cluster', connr1, if_exists='replace', index=False, chunksize=10000)
            if opt1 != 1:  # RTWP or both 
                listrc = ['01', '02', '07', '08', '09', '10'] # RC list for copy iteration
                for rc in listrc:
                    dbdumplist = glob.glob(str(pathrep) +'/NOLRT/AMDOCS_NOLRT_RC' + rc + '*.gz')  # get rc latest file in customreports
                    latestdump = max(dbdumplist, key=os.path.getctime)
                    netactimp(latestdump, xlspath3)  # network file import
                for baself in xlspath3.glob('*.csv'):  # file iteration inside directory add files if necessary
                    print('{repfil} processing'.format(repfil=baself))
                    tempo = pd.read_csv(baself, sep=';',index_col=False)  # csv to df
                    tempo[['Day', 'Hour']] = tempo.PERIOD_START_TIME.str.split(
                        " ", expand=True,)  # time text to column
                    mask = np.in1d(tempo['Hour'].values, ['02:00:00', '03:00:00', '04:00:00'])
                    tempo1 = tempo[mask]  # filter hours
                    colnms = list(tempo1.columns.values)
                    if colnms[2] == 'LNBTS type':
                        tempo1.drop('LNBTS type', inplace=True, axis=1)
                    tempo2 = tempo1.groupby(
                        ['MRBTS name', 'LNCEL name', 'Day'],
                        as_index=False).agg(aggregl).rename(columns=colnaml)
                    print(tempo2)
                    tempo2['Day'] = pd.to_datetime(tempo2['Day'])
                    rwtpcols = tempo2.loc[:,['AvgRWTP1', 'AvgRWTP2', 'AvgRWTP3', 'AvgRWTP4']]
                    tempo2['AvgRWTP'] = rwtpcols.mean(axis=1)
                    tempo2['PortMeas'] = rwtpcols.count(axis=1)
                    tempo2['DiffRWTP'] = rwtpcols.max(axis=1) - rwtpcols.min(axis=1) 
                    curr.execute("DROP TABLE IF EXISTS temptable;")
                    tempo2.to_sql(  # temp table
                        'temptable', connr, if_exists='replace', index=False, chunksize=10000)
                    curr.execute(sqlinsertl)  # insert avoiding duplicates
                    connr.commit()
                cleandir(xlspath3, 'csv')  # delete processed files in root directory
            if opt1 != 2:  # KPI OR BOTH
                listrc = ['7', '8'] # RC list for copy iteration
                for rc in listrc:
                    dbdumplist = glob.glob(str(pathrep) +'/NOLKPI/AMDOCS_NOLKPI_RC' + rc + '*.gz')  # get rc latest file in customreports
                    latestdump = max(dbdumplist, key=os.path.getctime)
                    netactimp(latestdump, xlspath2)  # network file import
                for baself in xlspath2.glob('*.csv'):  # file iteration inside directory add files if necessary
                    print('{repfil} processing'.format(repfil=baself))
                    tempo = pd.read_csv(baself, sep=';',index_col=False)  # csv to df
                    # tempo['period start time'] = pd.to_datetime(tempo['period start time'])
                    tempo['PERIOD_START_TIME'] = pd.to_datetime(tempo['PERIOD_START_TIME'])
                    tempo.rename(columns = {'PERIOD_START_TIME':'Day'}, inplace=True)
                    curl.execute("DROP TABLE IF EXISTS temptable;")
                    tempo.to_sql(  # temp table
                        'temptable', connl, if_exists='replace', index=False, chunksize=10000)
                    curl.execute(sqlinsert2)  # insert avoiding duplicates
                    connl.commit()
                cleandir(xlspath2, 'csv')
else:
    proc = [10]
    # proc = [1,6,7,8]
    for iter1 in proc:
        if iter1 == 1:
            tabs = ['rtwp7day', 'rtwp7dayl']
            filen = 'RTWP_Audit'
            sqltabexport(connr, tabs, filen, dbtgt)
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
        if iter1 == 5:
            tabs = ['rtwp7dayl']
            filen = 'RWTP_Info'
            sqltabexport(connr, tabs, filen, dbtgt)
        if iter1 == 6:
            tabs = ['rwtplofdr', 'rtwpuofdr']
            filen = 'RWTP_NQInfo'
            sqltabexport(connr, tabs, filen, dbtgt)
        if iter1 == 7:
            tabs = ['lweek']
            filen = 'lweek'
            sqltabexport(connl, tabs, filen, dbtgt)
        if iter1 == 8:
            tabs = ['uweek']
            filen = 'uweek'
            sqltabexport(conn, tabs, filen, dbtgt)
        if iter1 == 9:
            tabs = ['uday']
            filen = 'uday'
            sqltabexport(conn, tabs, filen, dbtgt)
        if iter1 == 10:
            tabs = ['temptable']
            filen = 'RWTP_Info'
            sqltabexport(connr, tabs, filen, dbtgt)        
cur.close()
conn.close()
print('ok')
