import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
from pyexcelerate import Workbook
from datetime import date
import glob


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


pthlocal = Path('C:/sqlite/')
dbdumplist = glob.glob(str(pthlocal) +'/*_sqlite.dba')  # get latest dump in sqlite dir
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
conn = sqlite3.connect(latestdump)  
cur = conn.cursor()  # latest dump dB
ADJI_sql = Path('C:/sqlite/ADJI_S_Miss_211114.sql')  # ADJI_Miss queries 
sqlfromfile (ADJI_sql, cur)  # run queries from sql file
tabs = ['ADJI_Miss', 'ADJS_Miss']
filen = 'ADJI_S_Miss'
sqltabexport(conn, tabs, filen, Path(latestdump))  # save db table to xlsx file 
cur.close()
conn.close()