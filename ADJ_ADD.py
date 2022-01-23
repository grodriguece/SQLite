import os
import re
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
from pyexcelerate import Workbook
from datetime import date
import subprocess
import glob
from rfpack.adjcreac import ADJSDep, ADJSCrea


def sqlcsvimpNAct(conn1, c, loc, tipo):  # cursor from tgt db
    c.execute("DROP TABLE IF EXISTS " + tipo)
    try:  # import csv files in loc to sqlite by 10000 rows batch
        xlspath = Path('C:/xml/baseline/' + loc + '/')  # 031 csv directory
        for baself in xlspath.glob('*.csv'):  # file iteration inside directory
            print('{basel} data import'.format(basel=baself))
            tempo = pd.read_csv(baself, sep=';', chunksize=50000)
            for chunk in tempo:
                chunk.to_sql(tipo, conn1, if_exists='append', index=False, chunksize=10000)
    except sqlite3.Error as error:  # sqlite error handling
        print('SQLite error: %s' % (' '.join(error.args)))
    return


def cleandir(csvpath,pattern):
    for baself in csvpath.glob('%s' % pattern):  # file iteration inside directory
        try:
            os.remove(baself)  # remove old csv files
        except:
            print("Error while deleting file : ", baself)
    return


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

def totemplate(connt, curt, csvsrc): # get info to load csv info
    df3 = pd.read_csv(csvsrc)
    curt.execute("DROP TABLE IF EXISTS " + str(csvsrc.stem) + ";")
    df3.to_sql(str(csvsrc.stem), connt, if_exists='replace', index=False)  # temp table
    print('Sector Qty: {repfil}'.format(repfil=len(df3)))
    return df3

sqlcreatetab = ['DROP TABLE IF EXISTS ADJS_Add',
    """CREATE TABLE ADJS_Add (
                    rnc_id integer, mcc integer,
                    ncc integer, wcel_ids integer,
                    wcels text, celldnt text,
                    wcelt text, rthop integer,
                    nrthop integer, hshop integer,
                    hsrthop integer)""",
    'DROP TABLE IF EXISTS ADJS_Dep',
    """CREATE TABLE ADJS_Dep (
                    wcels text, wcelt text,
                    rnc_id integer,
                    wbts_id integer,
                    wcel_id integer,
                    adjs_id integer
                    )"""]


def netactimp(netactf, pathdest, cluster):  # file retrieve from network location 
    # cmdir = 'dir "%s"' % (str(PureWindowsPath(netactf))) 
    # subprocess.call(cmdir, shell=True)
    # cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(netactf)), str(PureWindowsPath(pathdest)) )
    # subprocess.call(cmcopy, shell=True)
    if len([file for file in os.listdir(pathdest) if re.search(".*RC" + cluster + ".*gz$", file)]):
        cleandir(pathdest, '*RC' + cluster + '*.csv')  # clear previous csv files only if cluster gz regex file is found
        subprocess.call(exe + " e " + str(PureWindowsPath(pathdest)) + "\*RC" + cluster + "*.gz" + " -o" 
        + str(PureWindowsPath(pathdest)))
        cleandir(pathdest, '*RC' + cluster + '*.gz')
        # cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(pathdest)) + "\*RC" + cluster + "*.csv", str(PureWindowsPath(pathdest)) + "\\raw")
    # subprocess.call(cmcopy, shell=True)
    return

exe = "C:\\7za\\7za.exe"
pthlocal = Path('C:/sqlite/')
dbdumplist = glob.glob(str(pthlocal) +'/*_sqlite.dba')  # get latest dump in sqlite dir
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
conn = sqlite3.connect(latestdump)  
cur = conn.cursor()  # latest dump dB
#
#
#
#
#
# ADJ section
# logname = os.getlogin()
# pathrep ='C:/Users/'+ logname + '/OneDrive - AMDOCS/Custom_Reports/'
# pathdest = Path('C:/xml/baseline/RAN046')
# listrc = ['01', '02', '07', '08', '09', '10'] # RC list for copy iteration
# for rc in listrc:
#     dbdumplist = glob.glob(str(pathrep) +'/RAN046/AMDOCS_RAN046_RC' + rc + '*.gz')  # get rc latest file in customreports
#     if dbdumplist:
#         latestdump = max(dbdumplist, key=os.path.getctime)
#     else:
#         latestdump = ''
#     netactimp(latestdump, pathdest, rc)  # if gz exists clean csv and import, if not, just import csv
# sqlcsvimpNAct(conn, cur, 'RAN046', 'RSRAN046')  # import cluster csv files to sql
# for i in sqlcreatetab:
#     cur.execute(i)
# csvadj = Path('C:/sqlite/file/ADJlist.csv') 
# dfadj = totemplate(conn, cur, csvadj)  # load file into database
# tablefld = 'ADJ_Type'
# adjtype = 'ADJS' 
# dfadjs = dfadj.loc[dfadj[tablefld] == 'ADJS']
# cur.execute("SELECT rowid, * FROM {tabname} WHERE ({colnam} = '{wcels}') ORDER BY Source".format(
#                       tabname=str(csvadj.stem), colnam= tablefld, wcels= adjtype))  # gets table with rowid
# cellsm = cur.fetchall()
#
# sqlcsvimpNAct(connd, curd, 'RAN046', 'RSRAN046')
#
# adjlist table has info with adj to create start from here with cade-adjs-add file
# get info into df
# get ADJS
# verify new ADJ doesn't exist
# runinsert routine
#
# UNDER PROGRESS ADD ADJS FROM ADJlist.CSV FILE
#
#
#
#
# Capacity process
csvcap = Path('C:/sqlite/file/SITE_PRIORITY_PER_WEEK.csv')
planbss = Path('C:/sqlite/file/PlanBSS.csv') 
totemplate(conn, cur, csvcap)  # load file into database
totemplate(conn, cur, planbss)  # load file into database
