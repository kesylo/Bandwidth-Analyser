import sys

def count(fname):
	with open(fname) as f:
		for i, l in enumerate(f):
			pass
		return i+1


if count("temp") == 3:
	sys.exit()
else:
	print "no"
