#!/usr/bin/python2.7
import sys
sys.path.append('/home/pi/.local/lib/python2.7/site-packages')
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import datetime

# Variables
date = '12/12/2001'
ping, dwn, up = '12.1', '12.1', '12.1'
scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name('speedtest-b6e9772e5bb1.json', scope)

def count(fname):
	with open(fname) as f:
		for i, l in enumerate(f):
			pass
		return i+1


if count("temp") == 4:
	# Read file and get data
	f = open("temp")
	for x, line in enumerate(f):
		if x == 0:
			date = line.rstrip()
		elif x == 1:
			ping = line.rstrip()
		elif x == 2:
			dwn = line.rstrip()
		elif x == 3:
			up = line.rstrip()
	f.close()
else:
	sys.exit()



# grant access to script
gc = gspread.authorize(creds)

sheet = gc.open("BXL-speedtests").get_worksheet(int(sys.argv[1]))
#print(sheet.get_all_records())

print (date)
print (ping)
print (dwn)
print (up)

# Write to sheet
print("Sending data to sheet...")
sheet.append_row([date, float(ping), float(dwn), float(up)])
