import os
from pathlib import Path,PureWindowsPath
import pandas as pd
import sqlite3
from pyexcelerate import Workbook
from datetime import date
import subprocess


def cleandir(csvpath,exten):
    for baself in csvpath.glob('*.%s' % exten):  # file iteration inside directory
        try:
            os.remove(baself)  # remove old csv files
        except:
            print("Error while deleting file : ", baself)
    return


def sqlcopybl(db1, db2):
    conn = sqlite3.connect(db1)  # connection to src db
    c = conn.cursor()
    try:
        c.execute("ATTACH DATABASE '" + str(db2) + "' AS db_2")  # add conn to tgt db
        c.execute("DROP TABLE IF EXISTS db_2.baseline")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_UMTS")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_LTE")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_GSM")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_700FU")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_LTemp")
        c.execute("DROP TABLE IF EXISTS db_2.Baseline_LTempF")
        c.execute("CREATE TABLE db_2.baseline AS SELECT * FROM baseline")
        c.execute("CREATE TABLE db_2.Baseline_UMTS AS SELECT * FROM Baseline_UMTS")
        c.execute("CREATE TABLE db_2.Baseline_LTE AS SELECT * FROM Baseline_LTE")
        c.execute("CREATE TABLE db_2.Baseline_GSM AS SELECT * FROM Baseline_GSM")
        c.execute("CREATE TABLE db_2.Baseline_700FU AS SELECT * FROM Baseline_700FU")
        c.execute("CREATE TABLE db_2.Baseline_LTemp AS SELECT * FROM Baseline_LTemp")
        c.execute("CREATE TABLE db_2.Baseline_LTempF AS SELECT * FROM Baseline_LTempF")
    except sqlite3.Error as error:  # sqlite error handling
        print('SQLite error: %s' % (' '.join(error.args)))
    c.close()
    conn.close()
    return


def sqlcsvimport(c, tipo, tec):  # cursor from tgt db
    c.execute("DROP TABLE IF EXISTS " + tipo)
    try:  # import baseline csv to sqlite by 10000 rows batch
        xlspath = Path('C:/xml/baseline/')  # baseline csv directory
        print('{basel} data import'.format(basel=tipo))
        base = pd.read_csv(xlspath / Path('bl' + tec + '.csv'), encoding='latin-1')
        base.to_sql(tipo, conn, if_exists='append', index=False, chunksize=10000)
    except sqlite3.Error as error:  # sqlite error handling
        print('SQLite error: %s' % (' '.join(error.args)))
    return


def sqlcsvimpNAct(c, loc, tipo):  # cursor from tgt db
    c.execute("DROP TABLE IF EXISTS " + tipo)
    colnames = ['PERIOD_START_TIME', 'Source PLMN name', 'Source MRBTS name', 'Source LNBTS type',
                'Source LNBTS name', 'Source LNCEL name', 'Target PLMN name', 'Target MRBTS name',
                'Target LNBTS type', 'Target LNBTS name', 'Target LNBTS ID', 'Target LNCEL name',
                'Target LNCEL TAC', 'Target LCR ID', 'mcc_id', 'mnc_id', 'eci_id',
                'Intra eNB neighbor HO: Prep SR', 'Intra eNB neighbor HO: SR',
                'Intra eNB neighbor HO: Att', 'Intra eNB neighbor HO: Cancel R',
                'Inter eNB neighbor HO: Prep SR', 'Inter eNB neighbor HO: SR',
                'Inter eNB neighbor HO: Att', 'Inter eNB neighbor HO: FR',
                'Load Balancing HO, per neighbor: SR', 'Load Balancing HO, per neighbor: Att',
                'Late/Early HO ratio, per neighbor: Late HO',
                'Late/Early HO ratio, per neighbor: Early HO, type 1',
                'Late/Early HO ratio, per neighbor: Early HO, type 2']
    try:  # import report LTE031 csv to sqlite by 10000 rows batch
        xlspath = Path('C:/xml/baseline/' + loc + '/')  # 031 csv directory
        for baself in xlspath.glob('*.csv'):  # file iteration inside directory
            # if tipo == 'RSLTE031':
            #     tempo = pd.read_csv(baself, sep=';', chunksize=50000, names=colnames, header=0)
            #     # csv read in 50K rows blocks, header=0 to be able to replace existing names
            # else:
            print('{basel} data import'.format(basel=baself))
            tempo = pd.read_csv(baself, sep=';', chunksize=50000)
            for chunk in tempo:
                chunk.to_sql(tipo, conn, if_exists='append', index=False, chunksize=10000)
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


def amleprsqlconcat(tabs1, conn2):
    dfconcat = pd.DataFrame()
    for i in tabs1:
        try:
            print('processing query {iterar}'.format (iterar=i))
            df = pd.read_sql_query("select * from " + i + ";", conn2)  # pandas dataframe from sqlite
            dfconcat = dfconcat.append(df, ignore_index=True)
        except sqlite3.Error as error:  # sqlite error handling
            print('SQLite error: %s' % (' '.join(error.args)))
    data = [dfconcat.columns.tolist()] + dfconcat.values.tolist()  # dataframe to list to pyexcelerate save
    return data

def sqlcsvexport(conn1, tabs1, databm):
    today = date.today()
    # csv_path = databm.parent / 'csv' / fold # xls file path-name
    for i in tabs1:
        try:
            print('saving file {iterar}'.format (iterar=i))
            df = pd.read_sql_query("select * from " + i + ";", conn1)  # pandas dataframe from sqlite
            df.to_csv(str(databm) + '/' + i + '_' + today.strftime("%y%m%d") + ".csv", index=False, chunksize=10000)
        except mysql.Error as error:  # mysql error handling 
            print('MySQL error: %s' % (' '.join(error.args)))
    return  

def concat(cspath, tec):
    xlspath = cspath / tec  # tec baselines from RF page directory
    conca = pd.DataFrame()
    for baself in xlspath.glob('*.xls'):  # file iteration inside directory
        tempo = pd.read_html(str(baself))
        conca = conca.append(tempo)
        try:
            os.remove(baself)  # remove src xls file
        except:
            print("Error while deleting file : ", baself)
    conca.to_csv(xlspath.parent / Path('bl' + tec + '.csv'))
    return

# dateini = '0514'
# dbsrc = Path('C:/sqlite/2021' + dateini + '_sqlite.dba')
# datesq = '0515'
# dbtgt = Path('C:/sqlite/2021' + datesq + '_sqlite.dba')
# sqlcopybl(dbsrc, dbtgt)  # bl copy old rutine
# stage1
#
# BASELINE SATURDAY
# csvpath = Path('C:/xml/baseline/')  # tec baselines from RF page directory
# for baself in csvpath.glob('*.csv'):  # file iteration inside directory
#     try:
#         os.remove(baself)  # remove old csv files
#     except:
#         print("Error while deleting file : ", baself)
# concat(csvpath, 'UMTS')
# concat(csvpath, 'LTE')
# concat(csvpath, 'Sitios')
# concat(csvpath, 'GSM')
# zfile = '\\baseline' + today.strftime("%y%m%d") + ".7z"
# source = str(PureWindowsPath(csvpath)) + '\\*.csv'
# target = str(PureWindowsPath(csvpath)) + zfile 
# subprocess.call(exe + " a -t7z \"" + target + "\" \"" + source + "\" -mx=9")
#
#
#
pathdb = '//USSTLCCOS01/Repository/CM_Dumps/CM_processed/Nokia/'
pathrep ='//USSTLCCOS01/Repository/TMP_Reportes_Netact_Mirror/'
pathdest = Path('C:/xml/baseline/031')
pthlocal = Path('C:/sqlite/')
today = date.today()
tdyfrmt = today.strftime("%Y%m%d")
exe = "C:\\7za\\7za.exe"
dbtgtini = tdyfrmt + "_sqlite"
dbtgtz = pathdb + dbtgtini + '.7z'
dbtgtzl = 'c:/sqlite/' + dbtgtini + '.7z'
dbtgt = pthlocal / (dbtgtini + '.dba')
# datesq = '0519'
# dbtgt = Path('C:/sqlite/2021' + datesq + '_sqlite.dba')
#
#
#
# stage2
#
# db copy network to local
# dbcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(dbtgtz)), str(PureWindowsPath(pthlocal)) )
# print('dB {dbnetwork} copy in process'.format(dbnetwork=dbtgtini))
# subprocess.call(dbcopy, shell=True)
# subprocess.call(exe + " e " + str(PureWindowsPath(dbtgtzl)) + " -o" 
# + str(PureWindowsPath(pthlocal)))
# cleandir(pathdest, 'csv')  # retrieve 031 network files
# netactf = pathrep + today.strftime("%Y%m%d") + "/AMDOCS_NOL031_RC*.gz"
# cmdir = 'dir "%s"' % (str(PureWindowsPath(netactf))) 
# subprocess.call(cmdir, shell=True)
# cmcopy = 'copy "%s" "%s"' % (str(PureWindowsPath(netactf)), str(PureWindowsPath(pathdest)) )
# subprocess.call(cmcopy, shell=True)
# subprocess.call(exe + " e " + str(PureWindowsPath(pathdest)) + "\*.gz" + " -o" 
# + str(PureWindowsPath(pathdest)))
# cleandir(pathdest, 'gz')
# conn = sqlite3.connect(dbtgt)
# cur = conn.cursor()
# sqlcsvimport(cur, 'baseline_Site', 'Sitios')  # Bl to new daily dB 
# sqlcsvimport(cur, 'BaselineLTE', 'LTE')
# sqlcsvimport(cur, 'BaselineUMTS', 'UMTS')
# sqlcsvimport(cur, 'BaselineGSM', 'GSM')
# sqlcsvimpNAct(cur, '031', 'RSLTE031')
# cur.close()
# conn.close()
#
#
#
# stage3
#
# proc = [15]
proc = [1, 2, 3, 4, 5, 13]
cont = sqlite3.connect(dbtgt)  # database connection for all iterations
cur = cont.cursor()
for iter1 in proc:
    if iter1 == 1:
        tabs = ['LNREL_PART_NOCOLOC', 'LNREL_PART_NOCOSCTR', 'LNREL_PART_NOCOSITE',
                'LNREL_PART_UNDFND', 'LNMME_Miss', 'PCI_DistF1', 'RSI_DistF1']
        filen = 'Mob_Audit'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 2:
        tabs = ['NRBTS_Full', 'NRCELL_Full', 'LTE_Param', 'WCEL_PARAM1',
                'BTS_PARAM', 'ADJcount3G']
        filen = 'NET_Params'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 3:
        path031 = dbtgt.parent / 'csv/LTE031' # csv file path-name
        for baself in path031.glob('*.csv'):  # file iteration inside directory
            try:
                os.remove(baself)  # remove old csv files
            except:
                print("Error while deleting file : ", baself)
        tabs = ['T031_PAR_LNREL_RA', 'T031_PAR_LNREL_ER9', 'T031_PAR_LNREL_ER1', 'T031_PAR_LNREL_ER2',
                'T031_PAR_LNREL_ER7', 'T031_PAR_LNREL_ER8', 'T031_PAR_LNREL_ER10']
        sqlcsvexport(cont, tabs, path031)
        zfile = '\\LTE031_LNREL' + today.strftime("%y%m%d") + ".7z"
        source = str(PureWindowsPath(path031)) + '\\*.csv'
        target = str(PureWindowsPath(path031)) + zfile 
        subprocess.call(exe + " a -t7z \"" + target + "\" \"" + source + "\" -mx=9")
    elif iter1 == 4:
        tabs = ['IRFIM_Miss', 'AMLEPR_MISS', 'LNHOIF_Miss', 'LNREL_COS_MISS', 'ADJL_DISC', 'ADJL_AUD9560', 'ADJL_AUD9560G',
                'ADJL_AUD626', 'ADJL_AUD626G', 'ADJL_AUD651', 'ADJL_AUD651G', 'ADJL_AUD3075', 'ADJL_AUD3075G',
                'ADJL_AUD3225', 'ADJL_AUD3225G']
        filen = 'IRFIM_ADJL_Missing'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 5:
        filet = 'LTE2051_1841_Disc'
        xls_file = filet + '_' + today.strftime("%y%m%d") + ".xlsx"
        xls_path = dbtgt.parent / 'xlsx' /xls_file  # xls file path-name
        wb = Workbook()
        tabs = ['IRFIM_626AUD', 'IRFIM_651AUD', 'IRFIM_9560AUD', 'IRFIM32253075AUD', 'IRFIM30753225AUD',
                'IRFIM_3075AUD', 'IRFIM_3225AUD']
        filen = 'IRFIM_DISC'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        tabs = ['LNHOIF_3075_3225', 'LNHOIF_3075_651', 'LNHOIF_3075_626', 'LNHOIF_3075_9560', 'LNHOIF_3225_3075',
                'LNHOIF_3225_651', 'LNHOIF_3225_626', 'LNHOIF_3225_9560', 'LNHOIF_651_3075', 'LNHOIF_651_3225',
                'LNHOIF_651_626', 'LNHOIF_651_9560', 'LNHOIF_626_3075', 'LNHOIF_626_3225', ' LNHOIF_626_651',
                'LNHOIF_626_9560', 'LNHOIF_9560_3075', 'LNHOIF_9560_3225', 'LNHOIF_9560_651', 'LNHOIF_9560_626']
        filen = 'LNHOIF_DISC'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        tabs = ['AMLEPR_3075_3225', 'AMLEPR_3075_651', 'AMLEPR_3075_626', 'AMLEPR_3075_9560', 'AMLEPR_3225_3075',
                'AMLEPR_3225_651', 'AMLEPR_3225_626', 'AMLEPR_3225_9560', 'AMLEPR_651_3075', 'AMLEPR_651_3225',
                'AMLEPR_651_626', 'AMLEPR_651_9560', 'AMLEPR_626_3075', 'AMLEPR_626_3225', ' AMLEPR_626_651',
                'AMLEPR_626_9560', 'AMLEPR_9560_3075', 'AMLEPR_9560_3225', 'AMLEPR_9560_651', 'AMLEPR_9560_626']
        filen = 'AMLEPR_DISC'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        tabs = ['LNCEL_IDCONGEN_15_20', 'LNCEL_IDCONGEN_10', 'LNCEL_IDCONGEN_5']  # next audit
        filen = 'LNCEL_IDCONGEN'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        tabs = ['LNCEL_AUD1841_15_20', 'LNCEL_AUD1841_10', 'LNCEL_AUD1841_5']  # next audit
        filen = 'LNCEL_2051_1841'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        tabs = ['LNBTS_AUD2051']
        filen = 'WBTS_DISC'
        data1 = amleprsqlconcat(tabs, cont)
        wb.new_sheet(filen, data=data1)
        wb.save(xls_path)
    elif iter1 == 6:
        tabs = ['T031_PAR_LNRELT']
        filen = '031_LNREL'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 7:
        tabs = ['LNCEL_Full', 'IRFIM_ref']
        filen = 'IRFIM'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 8:
        tabs = ['MISS3', 'ADJS_Add', 'ADJS_Dep']
        filen = 'ADJS_OPT'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 9:
        tabs = ['T031_LNREL_ATL', 'T031_LNREL_BOL', 'T031_LNREL_MGC', 'T031_LNREL_SC', 'T031_LNREL_OTHER']
        filen = 'T031_LNREL_RC10'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 10:  # different 031 processed
        tabs = ['T031_PAR_LNRELS']
        filen = 'T031_LNREL_RCx'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 11:  # adji info
        path031 = dbtgt.parent / 'csv/ADJI' # csv file path-name
        for baself in path031.glob('*.csv'):  # file iteration inside directory
            try:
                os.remove(baself)  # remove old csv files
            except:
                print("Error while deleting file : ", baself)
        tabs = ['adjicustom']
        sqlcsvexport(cont, tabs, path031)
        zfile = '\\ADJI_Info' + today.strftime("%y%m%d") + ".7z"
        source = str(PureWindowsPath(path031)) + '\\*.csv'
        target = str(PureWindowsPath(path031)) + zfile 
        subprocess.call(exe + " a -t7z \"" + target + "\" \"" + source + "\" -mx=9")
    elif iter1 == 13:  # hw inv tables
        tabs = ['LTE_tiltAud', 'UMTS_tiltAud', 'RMOD_LTE', 'RET_LTE']
        filen = 'HW_info'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 14:
        tabs = ['hopicustom']
        filen = 'hopicustom'
        sqltabexport(cont, tabs, filen, dbtgt)
    elif iter1 == 15:
        tabs = ['adjicustom']
        filen = 'adjicustom'
        sqltabexport(cont, tabs, filen, dbtgt)    
cur.close()
cont.close()


# stage4 Tables for ADJS Missing
#
# conn = sqlite3.connect(dbtgt)  # database connection
# cur = conn.cursor()
# sqlcsvimpNAct(cur, 'DET', 'DET_SET')
# sqlcsvimpNAct(cur, 'DRAFMS', 'DRP_AFT_MISSING')
# sqlcsvimpNAct(cur, '046', 'RSRAN046')
# sqlcsvimpNAct(cur, 'ADJS', 'ADJS_COMP')
# cur.close()
# conn.close()
#
#
print('ok')
