#!/usr/bin/python
from binascii import hexlify, unhexlify
from Crypto.Cipher import AES
from struct import pack, unpack
from sys import argv, exit
import requests
import re

def modu(dat):
	wad.write(b'\x00' * ((0x40 - (len(dat) % 0x40)) % 0x40))

tik = open(argv[1], 'rb')
temp = tik.read(0x8)
if temp == b'\x00\x00\x00\x20\x49\x73\x00\x00' or temp == b'\x00\x00\x00\x00\x00\x00\x00\x00':
	certsize, = unpack('>I', tik.read(4))
	if certsize == 0:
		certsize = 0xA00
	tik.seek(certsize + 0x40)
	tik = tik.read(0x2A4)
	# open('tik', 'wb').write(tik)
else:
	tik.seek(0)
	tik = tik.read()

tik = b'\x00\x01\x00\x01' + b'\x00' * 0x13C + tik[0x140:0x180] + b'\x00' * 0x3C + tik[0x1BC:0x1D0] + b'\x00' * 0xC + tik[0x1DC:0x2A4]
titid = tik[0x1DC:0x1E4].hex()
region = unhexlify(titid[-2:])
titkey = tik[0x1BF:0x1CF]
hacked_titkeys = [b'OhCrapAnotheriNT', b'BFGRBeFreeeeeee!', b'DaLetterAisan00b', titkey[0:1]+b'kikekakikrules!'] #latter is "kikekakikrules!!" but positioned a byte later
if titkey in hacked_titkeys:
	exit('Hacked title key')
# else:
# 	print(titkey)

if tik[0x1f1] == 0: # & 1 == 0:
	# print('Using normal common key...')
	ckey = unhexlify('EBE42A225E8593E448D9C5457381AAF7') # Standard common key
elif tik[0x1f1] == 1 and region == b'K': # & 1 == 1 and region == b'K':
	# print('Using Korean common key...')
	ckey = unhexlify('63B82BB4F4614E2E13F2FEFBBA4C9B7E') # Korean common key
else:
	# print('Detected scene modified ticket (using normal common key)...')
	# hack
	tik = bytearray(tik)
	tik[0x1f1:0x1f4] = b'\x00' * 3
	# / hack
	ckey = unhexlify('EBE42A225E8593E448D9C5457381AAF7')

print(titid)
# print(hexlify(titkey).decode('ascii'))

iv = unhexlify(titid) + b'\x00' * 8
cipher = AES.new(ckey, AES.MODE_CBC, iv)
titkey = cipher.decrypt(titkey)


baseurl = 'http://nus.cdn.shop.wii.com/ccs/download/'+titid+'/'

tmdurl = baseurl + 'tmd'
try:
	if argv[2]:
		tmdver = True
		tmdurl += '.' + argv[2]
except IndexError:
	tmdver = False
	pass

if requests.head(tmdurl).status_code != 200:
	if tmdver:
		exit('Invalid revision.')
	else:
		open('debug.log', 'a').write(titid+'\n')
		exit('Title not on CDN.')
tmd = requests.get(tmdurl).content

clist = {}
contents, = unpack('>H', tmd[0x1DE:0x1E0])
off = 0x1e4
for i in range(contents):
	cid, = unpack('>I', tmd[off:off+4])
	cidx, = unpack('>H', tmd[off+4:off+6])
	clist[cidx] = '{:08x}'.format(cid)
	off += 0x24

print(clist)

tmd = tmd[:off]

rev, = unpack('>H', tmd[0x1DC:0x1DE])
# print(argv[1], rev)
# exit()

appsize = 0
for c in clist:
	s = int(requests.head(baseurl+clist[c]).headers['Content-Length'])
	appsize += s + (0x40 - (s % 0x40)) % 0x40

temp = requests.get(baseurl + clist[0]).content
cipher = AES.new(titkey, AES.MODE_CBC, b'\x00'*16)
temp = cipher.decrypt(temp)

nameo = {b'J': 0, b'B': 1, b'D': 1, b'E': 1, b'F': 1, b'M':1, b'N': 1, b'L': 1, b'P': 1, b'A': 1, b'K': 9}
if titid[:8] != '00000001':
	if temp[0x80:0x84] != b'IMET':
		if temp[0x40:0x44] != b'WIBN':
			exit('Incorrect title key.')

	nameoff = 0x80 + 0x1c + 0x54 * nameo[region]
	region = {b'J': 'Japan', b'B': 'USA', b'E': 'USA', b'F': 'France', b'D': 'Germany', b'N': 'USA',
	          b'P': 'Europe', b'L': 'Europe', b'M': 'Europe', b'A': 'System', b'K': 'Korea'}[region]
	if titid[6:8] == '05':
		nameoff = 0x60

	name = temp[nameoff:nameoff+0x54].decode('utf-16be').strip('\x00').replace('/', '-').replace('\x00', ' ').replace(': ', ' - ')
	name = re.sub('  +', ' - ', name)
	name = name + ' (' + region + ') (v' + str(rev) + ')'
	print(name)
else:
	if len(clist) > 1:
		name = temp[:0x20].strip(b'\x00').decode('utf-8')
	else:
		name = 'System'

wad = open(name + '.wad', 'wb')

wad.write(b'\x00\x00\x00\x20\x49\x73\x00\x00')
wad.write(pack('>IIIIII', 0xA00, 0, len(tik), len(tmd), appsize, int(requests.head(baseurl+clist[0]).headers['Content-Length'])))
wad.write(b'\x00'*0x20)

wad.write(open('cert.sys', 'rb').read())

wad.write(tik)
modu(tik)

wad.write(tmd)
modu(tmd)

for i in clist:
	i = clist[i]
	print('Downloading '+i)
	fi = requests.get(baseurl + i).content
	wad.write(fi)
	modu(fi)

wad.write(temp)
modu(temp)

wad.close()
