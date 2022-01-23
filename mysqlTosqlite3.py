import pymysql
import pandas as pd
import csv
from pathlib import Path
from configparser import ConfigParser
import os
from pathlib import Path
import sqlite3
from datetime import date
import glob
from pyexcelerate import Workbook


def sqltabexport(conn1, tabs1, filenam, datpath):
    today = date.today()
    xls_file = filenam + '_' + today.strftime("%y%m%d") + ".xlsx"
    xls_path = datpath / 'xlsx' / xls_file  # xls file path-name
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

def _config(key, arg=None):  # db connection info retrieval
    try:
        return cfg.get(read_group, key)
    except Exception:
        return arg

def sqlfromfile (filenam, crsr):  # query exec from sql file
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


tabcsv = []  # dB tables to be copied
tabsrc = Path('C:/sqlite/tabmysql2.csv')
with open(tabsrc, newline='') as inputfile:
    for row in csv.reader(inputfile):
        tabcsv.append(row[0])
print(tabcsv)
TABLES = {}
pthlocal = Path('C:/sqlite/')
dbdumplist = glob.glob(str(pthlocal) +'/*_sqlite.dba')  # get latest dump in sqlite dir
latestdump = max(dbdumplist, key=os.path.getctime)
print(latestdump)
connd = sqlite3.connect(latestdump)  
curd = connd.cursor()  # latest dump dB
read_file = "/mysql/my11.ini" # dB info
cfg = ConfigParser()
# read_group = 'connector_python' # group in .ini file
read_group = 'amdocs_sr' # group in .ini file
cfg.read(read_file) 
DB1_UNAME = _config("user")  # info for sqlalchemy engine 
DB1_PASS = _config("password")
DB_HOST = _config("host")
DB_NAME = _config("database")
portl = int(_config("port", 3306))
charset = _config("charset", "utf8mb4")
try:
    db1 = pymysql.connect(host=DB_HOST, user=DB1_UNAME, passwd=DB1_PASS, port=portl) 
    if db1.open:  # source dB
        cursor1 = db1.cursor()
except pymysql.Error as error:  # mysql error handling 
        print('MySQL error: %s' % (' '.join(error.args)))
try:
    cursor1.execute("USE {Database}".format(Database=DB_NAME))  # 
    print("Database {} connected successfully.".format(DB_NAME))
except pymysql.Error as err:  # mysql error handling 
    if err.errno == errorcode.ER_BAD_DB_ERROR:
        print('Database {} does not exists.'.format(DB_NAME))
    else:
        print(err)
        exit(1)
for tabcs in tabcsv:  # table sql creation
    cursor1.execute("SHOW CREATE TABLE {dBase}.{tabname}".format(dBase=DB_NAME,tabname=tabcs.lower()))
    temporal = list(cursor1.fetchall())
    TABLES[temporal[0][0]] = temporal[0][1]  # dict table: sql creation
for tabcs in tabcsv:  # tgt Db table cleaning   
    curd.execute("DROP TABLE IF EXISTS {tabname}".format(tabname=tabcs.lower()))
for table_name in TABLES:
    table_desplit = TABLES[table_name].split(") ENGINE", 1)  # mysql to sqlite formatting
    table_description = table_desplit[0] + ")"
    try:
        print("Creating table {}".format(table_name))
        curd.execute(table_description)
    except sqlite3.Error as error:  # sqlite error handling
            print('SQLite error: %s' % (' '.join(error.args)))
for tabcs in tabcsv:  # src Db table data retrieving  
    print("Reading table {}".format(tabcs.lower()))
    cursor1.execute("Select * from {dBase}.{tabname}".format(dBase=DB_NAME,tabname=tabcs.lower()))
    desc = cursor1.description
    column_names = [col[0] for col in desc]
    columnsf = ','.join(column_names)
    myDictl = [dict(zip(column_names, row))  
            for row in cursor1]
    # change the myDictl list table info from Dictionary to Tuple type
    # use the dict.values() of each inner dict. The values() will be in key (==input) order as well
    tupt= [tuple(d.values()) for d in myDictl]
    placeholder = ', '.join(['?'] * len(column_names))  # %s for mysql ? for sqlite
    stmt = "insert into `{tabname}` ({columns}) values ({values})".format(tabname=tabcs.lower(), columns=columnsf, values=placeholder)
    print("Populating table {}".format(tabcs.lower()))
    curd.executemany(stmt, tupt)
connd.commit()
rfmod_sql = Path('C:/sqlite/rfmod_211012.sql')  # Rfmod queries 
sqlfromfile (rfmod_sql, curd)  # run queries from sql file
tabs = ['rfportNorOcc']
filen = 'rfport_NorOcc'
sqltabexport(connd, tabs, filen, pthlocal)  # save db table to xlsx file 
cursor1.close()
curd.close
db1.close()
connd.close()
print('ok')