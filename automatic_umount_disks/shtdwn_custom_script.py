#! /bin/python3

from os import popen
import subprocess
from time import sleep

def kill_busy(umount_device):
    result= subprocess.run(['fuser','-mvk',umount_device], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    print('ERROR',result.stderr)
    print('RESULT',result.stdout)
    sleep(1)


rs=popen('lsblk')
lines=rs.read().split('\n')
letras=['a','b','c','d','e','f','j']
for letra in letras:
    disco='sd'+letra
    for i,e in enumerate(lines):
        if disco in e:
            c=i+1
            break
        else:
            c=-1
    result = subprocess.run(['udisksctl','power-off','-b','/dev/'+disco], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    #print('ERROR',result.stderr)
    #print('RESULT',result.stdout)
    if c!=-1:
        if lines[c][0]=='└':
            device=lines[c][2:].split(' ')[0]
            if 'luks' in device:
                umount_device='/dev/mapper/'+device
            else:
                umount_device='/dev/'+device
            kill_busy(umount_device)
            result = subprocess.run(['umount','-f',umount_device], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            print('ERROR',result.stderr)
            print('RESULT',result.stdout)
            if 'luks' in device:
                try:
                    result = subprocess.run(['cryptsetup','close',device], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                except Exception as e:
                    print(e)
                    pass
                print('ERROR',result.stderr)
                print('RESULT',result.stdout)
            result = subprocess.run(['udisksctl','power-off','-b','/dev/'+disco], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            print('ERROR',result.stderr)
            print('RESULT',result.stdout)
            if len(result.stderr)>0:
                print('fallo')
rs.close()
exit()
