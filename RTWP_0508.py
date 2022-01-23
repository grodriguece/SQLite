import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
import subprocess


def cleandir(csvpath,exten):
    for baself in csvpath.glob('*.%s' % exten):  # file iteration inside directory
        try:
            os.remove(baself)  # remove old csv files
        except:
            print("Error while deleting file : ", baself)
    return


xlspath = Path('C:/xml/baseline/RTWP/')  # RTWP csv directory
(xlspath / 'output').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
(xlspath / 'raw').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
(xlspath / 'tab').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
dbtgt = Path('C:/sqlite/kpi_sqlite.db')
tipo = 'RTWP'
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
sqlxtrtcel = """
    SELECT t.Day, t.RNCname, t.WBTSname, t.WBTSid, t.WCELname, t.WCELid,
    t.AvgRTWP, t.AvgCS_ERL, t.AvgMaxHSDPAusers, t.AvgPrach 
    FROM RTWP AS t INNER JOIN temptable AS r ON (t.WCELname = r.WCELName);
    """
today = date.today()
exe = "C:\\7za\\7za.exe"
pathrep ='//USSTLCCOS01/Repository/TMP_Reportes_Netact_Mirror/'
pathdest = Path('C:/xml/baseline/RTWP')
verif = 0
print('dBAct(1), Getdata(2), Both(3): ')
while verif < 4:
    try:
        opt = int(input())
        if opt <1 or opt >3:
            print('Please enter correct value.')
            verif+=1
        else:
            verif = 5
    except ValueError:
        print('No valid integer! Please try again ...')
if verif == 4:
    print('Default value taken Getdata(2)')
    opt=2
if (opt != 2):
    cleandir(pathdest, 'csv')
    netactf = pathrep + today.strftime("%Y%m%d") + "/Analisis_RTWP_3G_NorOcc*.gz"
    cmdir = 'dir "%s"' % (str(PureWindowsPath(netactf))) 
    subprocess.call(cmdir, shell=True)
    cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(netactf)), str(PureWindowsPath(pathdest)) )
    subprocess.call(cmcopy, shell=True)
    subprocess.call(exe + " e " + str(PureWindowsPath(pathdest)) + "\*.gz" + " -o" 
    + str(PureWindowsPath(pathdest)))
    cleandir(pathdest, 'gz')
    cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(pathdest)) + "\*.csv", str(PureWindowsPath(pathdest)) + "\\raw")
    subprocess.call(cmcopy, shell=True)
    conn = sqlite3.connect(dbtgt)
    cur = conn.cursor()
    # report import to kpi_sqlite.db
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
if (opt != 1):  # data extract to xls template
    ftab1 = 'sector_set.csv'  # sector names to extract
    df3 = pd.read_csv(xlspath / 'tab' / ftab1)
    cur.execute("DROP TABLE IF EXISTS temptable;")
    df3.to_sql('temptable', conn, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    df = pd.read_sql_query(sqlxtrtcel, conn)
    cleandir(xlspath / 'output')  # clean output dir
    df.to_csv(xlspath / 'output' / Path('totemplate.csv'), index=False)
cur.close()
conn.close()
print('ok')