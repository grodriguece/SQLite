import glob
import os
from pathlib import Path,PureWindowsPath


def missing():
    import sqlite3
    from rfpack.adjcreac import ADJSDep, ADJSCrea

    def insert_crea(crea):
        with conn:
            c.execute(
                "INSERT INTO ADJS_Add VALUES (:rnc_id, :mcc, :mnc, :wcel_ids, :wcels, :celldnt, :wcelt, :rthop, :nrthop, :hshop, :hsrthop)",
                {'rnc_id': crea.sourcerncid, 'mcc': crea.mcc, 'mnc': crea.mnc,
                 'wcel_ids': crea.sourceci, 'wcels': crea.sourcename,
                 'celldnt': crea.targetcelldn, 'wcelt': crea.targetname,
                 'rthop': crea.rthop, 'nrthop': crea.nrthop, 'hshop': crea.hshop, 'hsrthop': crea.hsrthop}
            )

    def insert_depu(depu):
        with conn:
            c.execute("INSERT INTO ADJS_Dep VALUES (:wcels, :wcelt, :rnc_id, :wbts_id, :wcel_id, :adjs_id)",
                      {'wcels': depu.sourcename, 'wcelt': depu.targetname, 'rnc_id': depu.sourcerncid,
                       'wbts_id': depu.wbtsids,
                       'wcel_id': depu.sourceci, 'adjs_id': depu.adjsid}
                      )

    def get_046y(exist):
        with conn:
            c.execute("SELECT rowid, * FROM S046_DistTY WHERE (WCELS = (:wcels))",
                      {'wcels': exist})  # gets table with rowid for wcel source
            return c.fetchall()
    dbtgt = Path('C:/sqlite/')  # working dB dir
    dbdumplist = glob.glob(str(dbtgt) +'/*_sqlite.dba')  # get latest dump in sqlite dir
    latestdump = max(dbdumplist, key=os.path.getctime)
    print(latestdump)
    conn = sqlite3.connect(latestdump)  # latest dump dB
    c = conn.cursor()
    c.execute("DROP TABLE IF EXISTS ADJS_Add")
    c.execute("""CREATE TABLE ADJS_Add (
                    rnc_id integer, mcc integer,
                    ncc integer, wcel_ids integer,
                    wcels text, celldnt text,
                    wcelt text, rthop integer,
                    nrthop integer, hshop integer,
                    hsrthop integer
                    )""")
    c.execute("DROP TABLE IF EXISTS ADJS_Dep")
    c.execute("""CREATE TABLE ADJS_Dep (
                    wcels text, wcelt text,
                    rnc_id integer,
                    wbts_id integer,
                    wcel_id integer,
                    adjs_id integer
                    )""")
    c.execute("SELECT rowid, * FROM MISS3 ORDER BY MISS3.WCELS")  # gets table with rowid
    cellsm = c.fetchall()
    i = 0                               # miss row counter initialize
    n = len(cellsm)                        # misscell amnt
    while i < n:                        # while <> EOlist
        k = cellsm[i][27]  # missed qty MISS_QTY
        if cellsm[i][14] is None:  # for empty ADJS list
            adjsq = 0  # adjs qty
        else:
            adjsq = cellsm[i][14]  # ADJS qty for missed src
        if adjsq == 0:  # when adjs list is empty adjQTY
            o = 0  # add control up to k
            while o < k:  # rows to add
                crea = ADJSCrea(cellsm[i][5], cellsm[i][6], cellsm[i][3], cellsm[i][7], cellsm[i][4])
                insert_crea(crea)  # raw inset into ADJS_Add db with ADJSCrea class
                i += 1  # general miss row id
                if i == n:
                    break
                o += 1  # control for set of miss cells added
            while (cellsm[i][3] == cellsm[i - 1][3]) and i < n:
                i += 1  # increase row miss pointer until next  diff cell
                if i == n:
                    break
        else:
            en = 1  # break control for att comparison
            deps = 0  # max adjmiss addd allowed control
            j = 0  # SY row counter
            celldep = get_046y(cellsm[i][3])  # 046 Yes cell list belonging to missed cel
            if not celldep:  # missed not in 046Yes, add up to k. No info for depuration
                if (k + adjsq) < 30: # missed+ adjsqty<30
                    o = 0  # add control up to k
                    while o < k:  # rows to add < miss qty
                        crea = ADJSCrea(cellsm[i][5], cellsm[i][6], cellsm[i][3], cellsm[i][7], cellsm[i][4])
                        insert_crea(crea)  # raw inset into ADJS_Add db with ADJSCrea class
                        i += 1  # general miss row id
                        if i == n:
                            break
                        o += 1  # control for set of miss cells added
                    while (cellsm[i][3] == cellsm[i - 1][3]) and i < n:
                        i += 1  # increase row miss pointer until next  diff cell
                        if i == n:
                            break
                else:
                    i += 1 # missed+046yesqty>=30 next missed
                    if i == n:
                        break
            else:  # miss cell is in 046 Yes and in missed list
                m = len(celldep)  # 046 Yes cell amnt
                o = 0  # miss add counter
                if (k + adjsq) < 30: # missed qty MISS_QTY+ adjs qty
                    while o < k:  # rows to add
                        crea = ADJSCrea(cellsm[i][5], cellsm[i][6], cellsm[i][3], cellsm[i][7], cellsm[i][4])
                        insert_crea(crea)  # raw inset into ADJS_Add db with ADJSCrea class
                        i += 1  # general miss row id
                        if i == n:
                            break
                        o += 1  # control for set of miss cells added
                else:  # missed qty MISS_QTY+ adjs qty >=30
                    while (o + adjsq) < 30:  # fill list without depuration
                        crea = ADJSCrea(cellsm[i][5], cellsm[i][6], cellsm[i][3], cellsm[i][7], cellsm[i][4])
                        insert_crea(crea)  # raw inset into ADJS_Add db with ADJSCrea class
                        i += 1  # general miss row id
                        if i == n:
                            break
                        o += 1  # control for set of miss cells added
                    # list full depuration start
                    while (cellsm[i][3] == celldep[0][3]) and (m - deps) > 3 and en == 1 and i < n and j < m:
                        # cellname is the same in celldep list. while 046y - deps >3 to avoid depurate all cells
                        print(i, n)
                        if cellsm[i][17] > celldep[j][16]:
                            crea = ADJSCrea(cellsm[i][5], cellsm[i][6], cellsm[i][3], cellsm[i][7], cellsm[i][4])
                            insert_crea(crea)  # raw insert into ADJS_Add db with ADJSCrea class
                            depu = ADJSDep(celldep[j][5], celldep[j][7], celldep[j][3], celldep[j][9], celldep[j][4],
                                           celldep[j][6], celldep[j][8])
                            insert_depu(depu)  # raw insert into ADJS_Dep db with ADJSDep class
                            i += 1  # next miss, watchout when i=n
                            j += 1  # next SY
                            deps += 1  # miss add qty control
                        else:
                            en = 0  # break condition
                            i += 1  # next miss cell
                        if i == n:
                            break
                    if i == 0 and i < n:
                        # increase row miss pointer until next diff cell for first misscell if cond is not passed
                        while cellsm[i][3] == celldep[0][3]:
                            i += 1
                            if i == n:
                                break
                    else:
                        if i == n:
                            break
                        # increase row miss pointer until next  diff cell
                        while (cellsm[i][3] == cellsm[i - 1][3]) and i < n:
                            i += 1
                            if i == n:
                                break
    conn.commit()
    conn.close()


print('start')
missing()
print('ok')
