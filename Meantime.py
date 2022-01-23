import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
import subprocess
import glob
from pyexcelerate import Workbook

def folderc(xlspathc):  # folder creation if not available
    (xlspathc / 'output').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'raw').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
    (xlspathc / 'tab').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files    
    return


# xlspath2 = Path('C:/xml/baseline/RTWPL/')  # LTE RTWP csv directory
# folderc(xlspath2)  # folder creation LTE RTWP
# dbtgtr = Path('C:/sqlite/rtwp_sqlite.db')  # working dB RTWP
# today = date.today()
# exe = "C:\\7za\\7za.exe"
# # pathrep ='//USSTLCCOS01/Repository/TMP_Reportes_Netact_Mirror/'
# # pathrep ='C:/Users/germanro/AMDOCS/David Vargas - Custom_Reports/'
# pathrep ='C:/Users/germanro/OneDrive - AMDOCS/Custom_Reports/'
# connr = sqlite3.connect(dbtgtr)  # working dB RTWP 
# curr = connr.cursor()  # working dB RTWP


# new code
def tabsqlinf(tabs1,conn1):  # df dict from sqlite queries. already in Amdocs_200616.py
    dataframe_collection = {}
    for i in tabs1:
        try:
            print('get info to df dict from {item1}'.format (item1=i))
            dataframe_collection[i] = df = pd.read_sql_query("select * from " + i + ";", conn1)  # pandas dataframe from sqlite
        except sqlite3.Error as error:  # sqlite error handling
            print('SQLite error: %s' % (' '.join(error.args)))
        print(dataframe_collection[i])
    return dataframe_collection

def sqlfromfile (filenam, crsr):
    wrkfl = open(filenam, 'r')
    sqlfl = wrkfl.read()
    wrkfl.close()
    sqlcmds = sqlfl.split(';')
    for cmd in sqlcmds:
        try:
            crsr.execute(cmd)
        except sqlite3.Error as error:  # sqlite error handling
            print('SQLite error: %s' % (' '.join(error.args)))
    return

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


# already in Amdocs_200616.py iter21
# dbtgt = Path('C:/sqlite/kpi_sqlite.db')  # working dB
# today = date.today()
# dbdumplist = glob.glob(str(dbtgt.parent) +'/*_sqlite.dba')  # get latest dump in sqlite dir
# latestdump = max(dbdumplist, key=os.path.getctime)
# print(latestdump)
# connd = sqlite3.connect(latestdump)  
# curd = connd.cursor()  # latest dump dB
# xls_file = 'amlprlmiss' + '_' + today.strftime("%y%m%d") + ".xlsx"
# xls_path = dbtgt.parent / 'xlsx' / xls_file  # xls file path-name
# wb = Workbook()
# tabs = ['ANRPRL_AVAIL', 'ANRPRL_MISS_FULL']
# df_anrprl = tabsqlinf(tabs,connd)  # tabs df dictionary 
# dfmiss = df_anrprl['ANRPRL_MISS_FULL'].sort_values('LNBTS_id')  # sort lnbts_ids prepare for anrprl_id fill 
# dfavail = df_anrprl['ANRPRL_AVAIL'].sort_values('LNBTS_id')
# dfmiss['ANRPRL_Id'] = 0  # create empty column
# j = 0  # avail initial
# for i in range (0, dfmiss.shape[0]):  # for dfmiss size
#     while dfmiss.at[i, 'LNBTS_id'] != dfavail.at[j, 'LNBTS_id']:  # condition to copy anrprl_id
#         j+=1  # next avail id until next lnbts_id
#     dfmiss.at[i, 'ANRPRL_Id'] = dfavail.at[j,'ANRPRL_Id']  # copy avail value to miss value
#     j+=1  # next avail id
# data = [dfmiss.columns.tolist()] + dfmiss.values.tolist()  # dataframe to list to pyexcelerate save
# wb.new_sheet('amlprlmiss', data=data)
# print('saving file {iterar}'.format (iterar=str(xls_path)))
# wb.save(xls_path)
# curd.close()
# connd.close()
# print('ok')
#
#
# UMTS Offender query execution
dbtgt = Path('C:/sqlite/kpi_sqlite.db')  # working dB kpi actual
UMTS_Offndr = Path('C:/sqlite/20211003_Kpi.sql')  # UMTS ofender queries 
today = date.today()
conn = sqlite3.connect(dbtgt)  # working dB Kpi
cur = conn.cursor()  # working dB Kpi
UMTS_Offndr = Path('C:/sqlite/20211003_Kpi.sql')  # UMTS ofender queries 
sqlfromfile (UMTS_Offndr, cur)
tabs = ['Avail_Rural', 'Avail_Urban', 'Pwr_Fail_Rural', 'Pwr_Fail_Urban', 'Denied_HS_Rural', 
'Denied_HS_Urban', 'Acc_CS_Rural', 'Acc_CS_Urban', 'Drop_CS_Rural', 'Drop_CS_Urban']
filen = 'UMTS_Offender'
sqltabexport(conn, tabs, filen, dbtgt) 
#
#
#
#
