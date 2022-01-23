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

def xtrctypl(filtype):
    switcher = {
        'LNCELName': sqlxtrtcl2,
        'LNBTSname': sqlxtrtcl2,
        'Prefijo': sqlxtrtcl2,
        'Cluster': sqlxtrtcl2,
        'Responsable': sqlxtrtcl2,
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
    cur2.execute("DROP TABLE IF EXISTS temptable;")
    df3.to_sql('temptable', conn, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    return df3

def totemplate1(conn, xlspath, sqlxtrtcel): # get info to load xlsb template    
    df = pd.read_sql_query(sqlxtrtcel, conn)
    cleandir(xlspath / 'output', 'csv')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
    return

colltesql = """
    Period_start_time,MRBTSname,LNBTSname,LNCELname,SAMPLES_CELL_AVAIL,DENOM_CELL_AVAIL,
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
    t.'PERIOD_START_TIME', t.'MRBTS name', t.'LNBTS name', t.'LNCEL name', 
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

lkpisql3 = """
    FROM LTE AS t INNER JOIN temptable AS r ON 
    """
lkpisql1 = """
    SELECT *  
    """
sqlxtrtcl2 = (lkpisql1 + lkpisql3 +  
" (t.LNBTSname = r.LNBTSname COLLATE NOCASE) " )

sqlinsert2 = ("INSERT INTO LTE (" + colltesql + ") " +
" SELECT " + ltesql2 + " FROM temptable AS t ;") 
#+ "WHERE NOT EXISTS " + "(SELECT 1 FROM LTE AS r WHERE t.'PERIOD_START_TIME' = r.Period_start_time " +
# "AND t.'MRBTS name' = r.MRBTSname AND t.'LNCEL name' = r.LNCELname);")

xlspath2 = Path('C:/xml/baseline/TLTE/')  # LTE csv directory
folderc(xlspath2)  # folder creation
dbtgt = Path('C:/sqlite/lte_sqlite.db')  # working dB
today = date.today()
exe = "C:\\7za\\7za.exe"
# pathrep ='//USSTLCCOS01/Repository/TMP_Reportes_Netact_Mirror/'
# pathrep ='C:/Users/germanro/AMDOCS/David Vargas - Custom_Reports/'
pathrep ='C:/Users/germanro/OneDrive - AMDOCS/Custom_Reports/'
conn2 = sqlite3.connect(dbtgt)
cur2 = conn2.cursor()
listrc = ['7', '8'] # RC list for copy iteration
for rc in listrc:
    # dbdumplist = glob.glob(str(pathrep) +'/CustomReports/AMDOCS_NOURT_RC' + rc + '*.gz')
    dbdumplist = glob.glob(str(pathrep) +'/NOLKPI/AMDOCS_NOLKPI_RC' + rc + '*.gz')  # get rc latest file in customreports
    latestdump = max(dbdumplist, key=os.path.getctime)
    netactimp(latestdump, xlspath2)  # network file import
for baself in xlspath2.glob('*.csv'):  # file iteration inside directory add files if necessary
    print('{repfil} processing'.format(repfil=baself))
    tempo = pd.read_csv(baself, sep=';',index_col=False)  # csv to df
    # tempo['period start time'] = pd.to_datetime(tempo['period start time'])
    tempo['PERIOD_START_TIME'] = pd.to_datetime(tempo['PERIOD_START_TIME'])
    cur2.execute("DROP TABLE IF EXISTS temptable;")
    tempo.to_sql(  # temp table
        'temptable', conn2, if_exists='replace', index=False, chunksize=10000)
    cur2.execute(sqlinsert2)  # insert avoiding duplicates
    conn2.commit()
cleandir(xlspath2, 'csv')



# df3 = totemplate(conn2, xlspath2)  # info from sector_set
# xtrctyp = list(df3.columns)  # column names from sector_set  
# xtrctyp1 = xtrctyp1(xtrctyp[0])  # query selection based on filter option
# if xtrctyp1 == 0:
#     print('No valid sector_set {repfil} filter type'.format(repfil=xtrctyp[0]))
# else:
#     totemplate1(conn2, xlspath2, xtrctyp1)



cur2.close()
conn2.close()
print('ok')