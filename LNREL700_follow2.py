import sqlite3
from datetime import date
import matplotlib.pyplot as plt
from pathlib import Path
import pandas as pd
import io


def labelbar(axr):
    for patch in axr.patches:
        # xy coords of the lower left corner of the rectangle
        bl = patch.get_xy()
        x = 0.2 * patch.get_width() + bl[0]
        # change 0.2 to move the text up and down
        y = 0.2 * patch.get_height() + bl[1]
        axr.text(x, y, "%d" % (patch.get_height()),
                 ha='center', rotation='vertical', fontsize=7, weight='bold', color='black')
    return


Dict = {0: 'Centro',
        1: 'Costa',
        2: 'NorOccidente',
        3: 'Oriente',
        4: 'SurOccidente',
        # 5: 'NotInBL',  # removed after COLLATE NOCASE sql improvement
        }


tab_par = "LNREL_700_Follow"
datesq = '0122'
dbtgt = Path('C:/sqlite/2022' + datesq + '_sqlite.dba')
today = date.today()
dat_dir = dbtgt.parent
(dat_dir / 'csv').mkdir(parents=True, exist_ok=True)  # create csv folder to save temp files
ftab1 = tab_par + '.csv'  # tables and parameters to audit
ftab2 = tab_par + '.xlsx'
dfini = pd.read_csv(dat_dir / 'csv' / ftab1, index_col=False)  # Date is not chosen as index
cont = sqlite3.connect(dbtgt)  # database connection for all iterations
cur = cont.cursor()
sql1 = "select L.Region, count(*) as 'Cantidad' from LNREL_PAR AS L where "
sql2 = " group by L.Region;"
cond1 = "L.earfcnDL = 9560"
cond2 = "(L.earfcnDL = 9560 AND L.amleAllowed = 0 AND L.handoverAllowed = 0)"
datsrcf = pd.read_sql_query(sql1 + cond1 + sql2, con=cont, index_col="Region")
datsrcf1 = pd.read_sql_query(sql1 + cond2 + sql2, con=cont, index_col="Region")
datsrcf = datsrcf.merge(datsrcf1, how='left', left_index=True, right_index=True)
datsrcf['Perc'] = datsrcf['Cantidad_y'] / datsrcf['Cantidad_x']
datsrcf.rename(columns={"Cantidad_y": "LNREL700_AMLE_Disc", "Cantidad_x": "LNREL700_Tot"}, inplace=True)
datsrcf = datsrcf.reset_index()
datsrcf.insert(0, 'Date', '22' + datesq)
index_names = datsrcf[datsrcf['Region'].isnull()].index
datsrcf.drop(index_names, inplace=True)  # drop None row indexes from datsrcf
# datsrcf['Region'].fillna('NotInBL', inplace=True)  # removed after COLLATE NOCASE sql improvement
dfini = dfini.append(datsrcf, ignore_index=True)
dfini.to_csv(dat_dir / 'csv' / ftab1, index=False)
print(datsrcf)
cur.close()
cont.close()
# plot generation
# create all axes we need
frames = {i: dat for i, dat in dfini.groupby('Region')}  # dataframe dict per region
fig = plt.figure()
#
for i in Dict:
    rslt_df = frames[Dict[i]]
    rslt_df.reset_index(drop=True, inplace=True)  # index starts from 0 for xticks sequence
    axtemp = plt.subplot(2, 3, i + 1)  # 2 rows, 3 columns, plot position
    rslt_df[['LNREL700_Tot', 'LNREL700_AMLE_Disc']].plot(kind='bar', ax=axtemp, figsize=(20, 10),
                                                         use_index=True, legend=False)  # xticks from 0 to row number -1
    axtemp.xaxis.set_ticklabels(rslt_df['Date'])  # update xtick label with Date info
    labelbar(axtemp)  # labels for each bar
    axtempi = axtemp.twinx()  # secondary axis graph
    axtempi.plot(axtemp.get_xticks(), rslt_df[['Perc']].values, linestyle='-', marker='o', linewidth=2.0,
                 label='Percentage', color="r")  # get_xticks() takes ticks from main graph
    axtemp.set_title(Dict[i])
    locals()['axtemp{0}'.format(i)] = axtempi  # for secondary axis sharing
    if i == 0:  # set legend in first plot
        axtempi.legend(loc=0)
        axtempi.legend(bbox_to_anchor=(0.05, 1.02, 1., .102), loc='lower left',
                       ncol=1, mode="expand", borderaxespad=0, frameon=False)
        axtemp.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left',
                      ncol=2, mode="expand", borderaxespad=1.5, frameon=False)
# share the secondary axes
# axtemp0.get_shared_y_axes().join(axtemp0, axtemp1, axtemp2, axtemp3, axtemp4, axtemp5)
# removed after COLLATE NOCASE sql improvement
axtemp0.get_shared_y_axes().join(axtemp0, axtemp1, axtemp2, axtemp3, axtemp4)
# Place a legend above this subplot, expanding itself to fully use the given bounding box.
fig.suptitle('LNREL700 amleAllowed = 0, handoverAllowed = 0')
fig.tight_layout(pad=3.0)  # row separation
# plt.show()
# Create Pandas Excel writer. XlsxWriter as the engine.
writer = pd.ExcelWriter(str(dat_dir / 'csv' / ftab2), engine='xlsxwriter')
# Convert the dataframe to an XlsxWriter Excel object
dfini.to_excel(writer, sheet_name='Data', index=False)  # avoid sequence index in first column
workbook = writer.book  # Get the xlsxwriter objects from the dataframe writer object.
# workbook = xlsxwriter.Workbook('LNREL700.xlsx')
# worksheet = writer.sheets['Data']
wks1 = workbook.add_worksheet('Chart')
# wks1.write(0,0,'test')
imgdata = io.BytesIO()
fig.savefig(imgdata, format='png')
wks1.insert_image(1, 1, '', {'image_data': imgdata})
workbook.close()
# Close the Pandas Excel writer and output the Excel file.
# writer.save()

