#! /bin/python3

from os import popen
import subprocess
from multiprocessing import Pool
import json
from time import sleep

def kill_busy(umount_device):
    result= subprocess.run(['fuser','-mvk',umount_device], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    #print('ERROR',result.stderr)
    #print('RESULT',result.stdout)
    sleep(0.5)

def get_disks(device):
    try:
        lists=device['children']
        result=map(get_disks,lists)
        return {'device_name':device['name'],'tran':device['tran'],'parts':list(result)}
    except Exception as e:
        try:
            if device['type']=='crypt':
                umount_device='/dev/mapper/'+device['name']
            else:
                umount_device='/dev/'+device['name']
        except:
            ##print('falla',device)
            return device
        return {'device_name':device['name'],'type':device['type'],'tran':device['tran'],'parts':umount_device}

def umount(list_disks):
    if type(list_disks['parts'])==type([]):
        e=map(umount,list_disks['parts'])
        return list(e)
    if type(list_disks['parts'])==type(''):
        kill_busy(list_disks['parts'])
        result = subprocess.run(['umount','-f',list_disks['parts']], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        #print('ERROR umount',result.stderr)
        #print('RESULT',result.stdout)
        if list_disks['type']=='crypt':
            try:
                result = subprocess.run(['cryptsetup','close',list_disks['device_name']], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
                #print('ERROR close',result.stderr)
                #print('RESULT',result.stdout)
            except:
                pass
            return 'close '+list_disks['parts']
        pass


def safe_umount(list_disks):
    msg,e='',''
    if list_disks['tran']=='usb':
        if type(list_disks['parts'])==type([]):
            e=list(map(umount,list_disks['parts']))
            msg=''
        result = subprocess.run(['udisksctl','power-off','-b','/dev/'+list_disks['device_name']], stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        #print('ERROR',result.stderr)
        #print('RESULT',result.stdout)
    return (msg,e)

string=popen("lsblk  -J -o 'NAME,TYPE,TRAN,TYPE,FSTYPE,MOUNTPOINT'").read()
list_json=json.loads(string)
blockdevices=list_json['blockdevices']

list_disks = list(map(get_disks,blockdevices))

with Pool(len(list_disks)) as pool:
    result=pool.map_async(safe_umount,list_disks)
    print(result.get())

exit()
