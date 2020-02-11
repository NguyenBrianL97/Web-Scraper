from selenium import webdriver
from bs4 import BeautifulSoup, Tag
import mysql.connector
import requests
import constant

#login to MySQL Server
cnx = mysql.connector.connect(user='root', password=constant.password,
                              host='127.0.0.1',
                              database='trnds',
                              use_pure=False) #pure Python interface or C Extension, warning fix
cursor = cnx.cursor()
#cnx.close(); to close connection

#Creates a TABLE in database
def create_table(tablename, cols=[], *args):    
    table_description="CREATE TABLE `{}` (".format(tablename) #create table
    table_description=table_description+"  `{}` VARCHAR(8),".format(cols[0]) #first col is string, rest is float(5)
    
    colcount=len(cols)
    for i in range(1,colcount-1):
        table_description=table_description+"  `{}` FLOAT(5),".format(cols[i])#middle cols have same format
        
    table_description=table_description+"  `{}` FLOAT(5)".format(cols[colcount-1]) #last col to add, no comma
    table_description=table_description+") ENGINE=InnoDB"

    cursor.execute(table_description)
    print("Added table to database.")

#INSERTS a row into TABLE, special case of TmAvg and sum   
def upload_dataS(tablename, row=[], *args):
    if row[0]=="":
        row[0]="TSPEx"
    if row[0]=="LgAvg":
        row[0]="LgAvgTSP"
    add_row_info = ("INSERT IGNORE INTO {} "
                "VALUES ('{}', {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, 0, 0, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},{},{},{},{},{},{},{}, {})".format(tablename,row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[14],row[15],row[16],row[17],row[18],row[19],row[20],row[21],row[22],row[23],row[24],row[25],row[26],row[27],row[28], row[29], row[30], row[31], row[32],row[33], row[34],row[35]) )
    cursor.execute(add_row_info)
    cnx.commit()
    print("Uploaded data (S)")
#INSERTS a row into TABLE
def upload_data(tablename, row=[], *args):
    if tablename=="team_standard_batting":
        if row[0]=="":
            row[0]="TSBEx"
        if row[0]=="LgAvg":
            row[0]="LgAvgTSB"
        add_row_info = ("INSERT INTO {} "            
                   "VALUES ('{}', {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {})".format(tablename,row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13],row[14],row[15],row[16],row[17],row[18],row[19],row[20],row[21],row[22],row[23],row[24],row[25],row[26],row[27],row[28]) )
    else:
        add_row_info = ("INSERT IGNORE INTO {} "
                    "VALUES ('{}', {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {},{},{},{},{},{},{},{}, {})".format(tablename,row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13],row[14],row[15],row[16],row[17],row[18],row[19],row[20],row[21],row[22],row[23],row[24],row[25],row[26],row[27],row[28], row[29], row[30], row[31], row[32],row[33], row[34],row[35]) )
    cursor.execute(add_row_info)
    cnx.commit()
    print("Uploaded data")

#Javascript
browser = webdriver.Chrome() #selecting chrome as browser
browser.get(constant.url) #use chrome to get url
innerHTML = browser.execute_script("return document.body.innerHTML") #get HTML from loaded site
soup = BeautifulSoup(innerHTML, features="html.parser" ) #soupify innerHTML; parse data

table = soup.find('table', attrs={'id':'teams_standard_batting'}) #find table within soup
rows = [[td.text  for td in row if isinstance(td, Tag)] for row in table.select("tr")] #Holds table rows

#Create and fill Team Standard Batting TABLE
create_table("team_standard_batting", rows[0])
rowscount=len(rows)
for i in range(1,rowscount-1):
   upload_data("team_standard_batting", rows[i])

#update table for pitching
table = soup.find('table', attrs={'id':'teams_standard_pitching'}) #find table within soup
rows = [[td.text  for td in row if isinstance(td, Tag)] for row in table.select("tr")] #Holds table rows

#Create and fill Team Standard Pitching TABLE
create_table("team_standard_pitching", rows[0]) 
rowscount=len(rows)
for i in range(1,rowscount-3):
    upload_data("team_standard_pitching", rows[i])
upload_dataS("team_standard_pitching", rows[31])
upload_dataS("team_standard_pitching", rows[32])
