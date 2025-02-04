# disk-verifier
Verify Brand New Disks before using them


The purpose of this windows batch file script is to stress test the hell out of any new disks i have purchased prior to putting them into service. 

This script performs the following:

1.) install smartmontools for windows https://www.smartmontools.org/wiki/Download#InstalltheWindowspackage
		make sure to install it at C:\Program Files\smartmontools\

2.) download the exf program from https://www.exactfile.com/downloads/ and place the "exf" executable in your "c:\windows\system 32" directory 

3.) create a folder c:\video

4.) copy a large file of your choice (the bigger the better) to the c:\video folder, and update the line "set video_file_location="C:\video\movie.exe"" with the file name being copied

5.) right click on the file and select properties to get the total number of bytes for the file and update the line Set "movie_size=156750742" to match the file's size in bytes

6.) using 7-zip or other utility, generate a CRC32 value for the file saved to c:\video folder and update the line "set video_file_crc32_value=E6242C96" with the correct CRC value

7.) attach the drive to be tested to the machine this script will run on

8.) under My Computer right click on the drive to be tested and click properties. using the number of bytes of the drive (for example 17,999,805,546,496 bytes for a 18TB drive)
	divide the number of bytes in the drive by the size of "movie_size" and enter the whole number into "num_copies" so we can fill the drive as much as possible 

9.) launch the script as administrator by right clicking the file and "run as administrator", and follow the instructions. 

on an 18TB disk i tested this on, it took about 9 days at USB 3.0 "super-speed" speeds of around 150 MB/s which is about as fast as a "spinning rust" HDD can be expected to achieve. That is obviously a long time, but that is the point of the test, to heavily test the drive over MANY days to see if the drive fits the bathtub curve for infant mortality. 

I use this script instead of programs like HD Sentinel as this script and the programs it is dependent on are free, does the same thing (writes to the entire drives and re-reads it) but goes even more to stress test the drive. 
