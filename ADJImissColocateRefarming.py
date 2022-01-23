import os
from pathlib import Path
import pandas as pd
import sqlite3
import numpy as np
from datetime import date
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

sql1 = 'DROP TABLE IF EXISTS adji_ref_audit;'
sql2 = """
CREATE TABLE adji_ref_audit AS
SELECT DISTINCT
w1.AnilloRF, w1.Sitio, w1.WCEL_Name, w1.FechaEstimada, 
DATE('1899-12-30', ('+' ||w1.Ejecucion|| ' day')) AS Ejecucion, w1.Sector, w2.RNC_id AS SourceRncId,
732 AS SourceMCC, 101 AS SourceMNC, w2.CId AS SourceCI,
w1.WCEL_Name AS name, w4.CellDN AS targetcelldn, w3.WCEL_Name AS Target, w2.version, a.ADJI_id, w2.Banda AS SrcBand, 
w4.Banda AS TgtBand, w2.Estado AS EstadoS, w4.Estado AS EstadoT   
FROM ((WCEL_PARAM2 w1 INNER JOIN WCEL_PARAM1 w2 ON w1.WCEL_Name = w2.WCELName) 
LEFT JOIN WCEL_PARAM2 w3 INNER JOIN WCEL_PARAM1 w4 ON w3.WCEL_Name = w4.WCELName)
LEFT JOIN ADJI a ON w4.CellDN = a.TargetCellDN AND w2.RNC_id = a.RNC_id AND w2.CId = a.WCEL_id 
WHERE (w2.WBTSName = w4.WBTSName) AND (w2.WCELName <> w4.WCELName) 
AND w2.UARFCN <> 9685 AND w4.UARFCN <> 9685 AND (w2.UARFCN <> w4.UARFCN) AND a.ADJI_id ISNULL
ORDER BY w1.Ejecucion IS NULL OR w1.Ejecucion='', w1.Ejecucion, w1.WCEL_Name;
"""

# xlsx3="c:/sqlite/file/Refarming 1900 BH_V2_NorOcc_Cronograma_0605.xlsb"  # cell info file
xlsx3="c:/sqlite/file/Cronograma Liberaciones 1900 FASE1.xlsb"  # cell info file
sheetn = 'EBs X Anillo'  # cell info sheet
# sheetn = 'wcels'  # cell info sheet
dbpath= Path(xlsx3).parents[1]  # second level path
df =  pd.read_excel(xlsx3,sheet_name=sheetn,engine='pyxlsb',index_col=0)  # cell info to audit
print('Sector Qty: {repfil}'.format(repfil=len(df)))
dbtgt = Path('C:/sqlite/kpi_sqlite.db')  # working path
dbdumplist = glob.glob(str(dbpath) +'/*_sqlite.dba')  # get latest dump in sqlite dir
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
conn = sqlite3.connect(latestdump)
cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS WCEL_PARAM2;")  # prepare wcel_param2 in dump to copy ADJI cell info
df.to_sql('WCEL_PARAM2', conn, if_exists='replace', index=False, chunksize=10000)
cur.execute(sql1)  # prepare adji_ref_audit 
cur.execute(sql2)  # fill adji_ref_audit
proc = [1]
for iter1 in proc:
    if iter1 == 1:
        tabs = ['adji_ref_audit']  # table to be retrieved
        filen = 'ADJI_Refarm_Audit'  # xlsx file destination
        sqltabexport(conn, tabs, filen, dbtgt)
cur.close()
conn.close()
print('ok') 
