# disk-verifier
Verify Brand New Disks before using them


The purpose of this windows batch file script is to stress test the hell out of any new disks i have purchased prior to putting them into service. 

This script performs the following:

1.) performs a quick SMART test

2.) Perform a full disk format with an extra pass where random data is also written to the disk

3.) copy a file of your choice over-and-over again onto the drive until the drive is as full as possible

4.) perform a CRC check (which reads the entire contents of the disk) of all the different file copies to ensure they are all the same CRC. If the CRC of one or more files is different then either a read error and or write error occurred on the disk

5.) performs a full windows checkdisk ```chkdsk %drive_letter%: /f /r /x```

6.) performs a quick format to get rid of all of the files written to the disk

7.) performs an extended SMART test

8.) saves the final detailed SMART test results data to a log file

on an 18TB disk i tested this on, it took about 9 days at USB 3.0 "super-speed" speeds of around 150 MB/s which is about as fast as a "spinning rust" HDD can be expected to achieve. That is obviously a long time, but that is the point of the test, to heavily test the drive over MANY days to see if the drive fits the bathtub curve for infant mortality. 

I use this script instead of programs like HD Sentinel as this script and the programs it is dependent on are free, does the same thing (writes to the entire drives and re-reads it) but goes even more to stress test the drive. 
