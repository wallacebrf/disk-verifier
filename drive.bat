@ECHO off
@ECHO off
set start_date=%date:~4,2%-%date:~7,2%-%date:~10,4%


REM INSTRUCTIONS:
REM 1.) install smartmontools for windows https://www.smartmontools.org/wiki/Download#InstalltheWindowspackage
REM		make sure to install it at C:\Program Files\smartmontools\
REM 2.) download the exf program from https://www.exactfile.com/downloads/ and place the "exf" executable in your "c:\windows\system 32" directory 
REM 3.) create a folder c:\video
REM 4.) copy a large file of your choice (the bigger the better) to the c:\video folder, and update the line "set video_file_location="C:\video\movie.exe"" with the file name being copied
REM 5.) right click on the file and select properties to get the total number of bytes for the file and update the line Set "movie_size=156750742" to match the file's size in bytes
REM 6.) using 7-zip or other utility, generate a CRC32 value for the file saved to c:\video folder and update the line "set video_file_crc32_value=2517E216" with the correct CRC value
REM 7.) attach the drive to be tested to the machine this script will run on
REM 8.) launch the script as administrator by right clicking the file and "run as administrator", and follow the instructions. 


rem USER VARIABLES
REM set this variable to be the number of bytes the video file to be copied. 
Set movie_size=156750742
set results_file="C:\Users\%USERNAME%\Desktop\results_%start_date%.md5"
set video_file_location="C:\video\movie.exe"
set video_file_crc32_value=2517E216
set log_file="C:\Users\%USERNAME%\Desktop\log_%start_date%.txt"


REM SCRIPT START - DO NOT EDIT ANYTHING PAST THIS LINE
set tmp_file="C:\Users\%USERNAME%\Desktop\tmp.txt"

REM creating required header of the CRC file that will later be used to verify files were written to the disk correctly 
echo ; Checksums generated by ExactFile Console Application 1.0.1.6 BETA > %results_file%
echo ; www.ExactFile.com >> %results_file%
echo ; 1/3/2025 4:48:45 PM >> %results_file%
echo ; >> %results_file%

REM print out menu and get the details on all installed disks and asking the user what disk they wish to test

title Server Disk Replacement Verifier

echo %date% %time% >																																									%tmp_file% && type %tmp_file% && type %tmp_file% > %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo Disk Model and Serial Number of all drives installed on the system: >																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
wmic diskdrive get Model, SerialNumber >																																				%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo Disk Size and Free Space >																																							%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
SETLOCAL enableextensions
(for /f "tokens=1-3" %%a in ('
  WMIC LOGICALDISK GET FreeSpace^,Name^,Size ^|FINDSTR /I /V "Name"
  ') do (
    echo wsh.echo "%%b" ^& " free=" ^& FormatNumber^(cdbl^(%%a^)/1024/1024/1024, 2^)^& " GB"^& " size=" ^& FormatNumber^(cdbl^(%%c^)/1024/1024/1024, 2^)^& " GB" > "%temp%\tmp.vbs"
    if not "%%c"=="" (
      echo( 
      cscript //nologo "%temp%\tmp.vbs"
      del "%temp%\tmp.vbs"
    )
  )
) >																																														%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo Available Drives on the System: >																																					%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
wmic logicaldisk get Caption,volumename > 																																				%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
ECHO What drive shall be tested?
echo.
set /P drive_letter=Drive letter [A-Z]=
echo.

if /I "%drive_letter%" EQU "a" set DRIVE=A
if /I "%drive_letter%" EQU "b" set DRIVE=B
if /I "%drive_letter%" EQU "c" goto :exit_now
if /I "%drive_letter%" EQU "d" set DRIVE=D
if /I "%drive_letter%" EQU "e" set DRIVE=E
if /I "%drive_letter%" EQU "f" set DRIVE=F
if /I "%drive_letter%" EQU "g" set DRIVE=G
if /I "%drive_letter%" EQU "h" set DRIVE=H
if /I "%drive_letter%" EQU "i" set DRIVE=I
if /I "%drive_letter%" EQU "j" set DRIVE=J
if /I "%drive_letter%" EQU "k" set DRIVE=K
if /I "%drive_letter%" EQU "l" set DRIVE=L
if /I "%drive_letter%" EQU "m" set DRIVE=M
if /I "%drive_letter%" EQU "n" set DRIVE=N
if /I "%drive_letter%" EQU "o" set DRIVE=O
if /I "%drive_letter%" EQU "p" set DRIVE=P
if /I "%drive_letter%" EQU "q" set DRIVE=Q
if /I "%drive_letter%" EQU "r" set DRIVE=R
if /I "%drive_letter%" EQU "s" set DRIVE=S
if /I "%drive_letter%" EQU "t" set DRIVE=T
if /I "%drive_letter%" EQU "u" set DRIVE=U
if /I "%drive_letter%" EQU "v" set DRIVE=V
if /I "%drive_letter%" EQU "w" set DRIVE=W
if /I "%drive_letter%" EQU "x" set DRIVE=X
if /I "%drive_letter%" EQU "y" set DRIVE=Y
if /I "%drive_letter%" EQU "z" set DRIVE=Z


echo.
echo WARNING DRIVE "%drive_letter%:" WILL BE FORMATTED ARE YOU SURE YOU WISH TO CONTINUE?
echo 1.) YES
echo x.) Exit
echo.
set /P c=Choose an option [1,x]?


if /I "%c%" EQU "1" goto :option_1
if /I "%c%" EQU "x" goto :pause_exit

:option_1

REM Get SMART status
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Getting Latest SMART status for Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "SMART overall-health self-assessment test result"') do (
 
		echo. %%O | findstr /C:"PASSED" 1>nul

		if errorlevel 1 (
			echo.
			echo !!!!!!!!!!!!!!!!!!! SMART Status for Drive "%drive_letter%:" Failed !!!!!!!!!!!!!!!!!!!
			echo.
			goto :smart_fail
		) ELSE (
			echo SMART Status for Drive "%drive_letter%:" Passed
		)
	) > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

REM Perform quick SMART test
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing quick SMART test on Drive "%drive_letter%:" >																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

smartctl -t short %drive_letter%: >																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo waiting 60 seconds to poll status again >																																			%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
timeout /t 60 > nul

:short_smart_in_progress
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "% of test"') do (
		echo.
		echo.
		echo Extended SMART test on Disk "%drive_letter%:" -- %%O"
 
		echo. %%O | findstr /C:"^%" 1>nul

		if errorlevel 1 (
		  echo %date% %time% SMART test is in progress... waiting 60 seconds to poll status again
		  REM pause for 60 seconds
		  timeout /t 60 > nul
		  goto :short_smart_in_progress
		) ELSE (
		  echo %date% %time% SMART test is not in progress, proceeding with rest of script
		  goto :short_smart_test_complete
		)
	)
	
:short_smart_test_complete

REM performing a full disk format
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing full format of drive "%drive_letter%:" using command "FORMAT %drive_letter%: /FS:NTFS /P:1 /X" >															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/FS:NTFS" -- Formatting file system as NTFS >																																		%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/P:1" --  Zero every sector on the volume.  After that, the volume will be overwritten "1" times using a different random number each time. >										%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/X" -- Forces the volume to dismount first if necessary. >																														%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title Performing full format of drive %drive_letter%:
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
FORMAT %drive_letter%: /FS:NTFS /P:1 /X
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Copying 100,000 copies of file "%video_file_location%" to disk "%drive_letter%:" or until the drive is full whichever occurs first >									%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title Copying file to disk %drive_letter%

for /l %%A in (1,1,100000) do (
	echo %date% %time% Processing file number %%A on Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
	
	REM check if there is enough disk space
	
	for /f "tokens=2" %%O in ('wmic LogicalDisk Get DeviceID^,FreeSpace ^| find /i "D:" 2^> nul') do (
		Echo Free Space="%%O" Bytes Remaining... >																																		%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
		Echo File Size to be Copied="%movie_size%" Bytes >																																%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
 
		If %%O gtr %movie_size% (
			echo %video_file_crc32_value% ?CRC32*movie-%%A.mkv >> %results_file%
			esentutl /y "%video_file_location%" /d "%drive_letter%:\movie-%%A.mkv" /o
		) else (
			Echo Not enough free space on disk %drive_letter% for movie-%%A.mkv > 																										%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
			Echo Copy process is complete..... >																																		%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
			goto :copy_done
		)
	)
)
:copy_done

REM Get SMART status
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Getting Latest SMART status for Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "SMART overall-health self-assessment test result"') do (
 
		echo. %%O | findstr /C:"PASSED" 1>nul

		if errorlevel 1 (
			echo.
			echo !!!!!!!!!!!!!!!!!!! SMART Status for Drive "%drive_letter%:" Failed !!!!!!!!!!!!!!!!!!!
			echo.
			goto :smart_fail
		) ELSE (
			echo SMART Status for Drive "%drive_letter%:" Passed
		)
	) > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing CRC Check of files copied to Drive "%drive_letter%:" >																									%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title Performing CRC Check of files copied to Drive "%drive_letter%:"
echo command is exf -c %results_file% -mt 16 -d "%drive_letter%:\" > 																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
exf -c %results_file% -mt 16 -d "%drive_letter%:\" > 																																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo Were any errors reported from the CRC check?
echo Y.) YES - This script will exit and the drive is probably bad
echo N.) NO - Continue Script
echo.
set /P c=Choose an option [Y,N]?


if /I "%c%" EQU "N" goto :option_2
if /I "%c%" EQU "Y" goto :pause_exit


:option_2
REM Get SMART status
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Getting Latest SMART status for Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "SMART overall-health self-assessment test result"') do (
 
		echo. %%O | findstr /C:"PASSED" 1>nul

		if errorlevel 1 (
			echo.
			echo !!!!!!!!!!!!!!!!!!! SMART Status for Drive "%drive_letter%:" Failed !!!!!!!!!!!!!!!!!!!
			echo.
			goto :smart_fail
		) ELSE (
			echo SMART Status for Drive "%drive_letter%:" Passed
		)
	) > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing full Check Disk of %drive_letter% using commnd chkdsk %drive_letter%: /f /r /x >																			%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/F" -- Fixes errors on the disk. >																																				%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/R" -- Locates bad sectors and recovers readable information >																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/X" -- Forces the volume to dismount first if necessary. >																														%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title Performing full Check Disk of Drive "%drive_letter%:"
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
chkdsk %drive_letter%: /f /r /x

REM Get SMART status
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Getting Latest SMART status for Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "SMART overall-health self-assessment test result"') do (
 
		echo. %%O | findstr /C:"PASSED" 1>nul

		if errorlevel 1 (
			echo.
			echo !!!!!!!!!!!!!!!!!!! SMART Status for Drive "%drive_letter%:" Failed !!!!!!!!!!!!!!!!!!!
			echo.
			goto :smart_fail
		) ELSE (
			echo SMART Status for Drive "%drive_letter%:" Passed
		)
	) > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

REM performing a quick disk format
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- > 																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing quick format of drive "%drive_letter%:" using command "FORMAT %drive_letter%: /FS:NTFS /Q" > 																%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/FS:NTFS" -- Formatting file system as NTFS >																																		%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo "/Q" --  Quick Format >																																							%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title Performing quick format of drive %drive_letter%:
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
FORMAT %drive_letter%: /FS:NTFS /Q




REM Start extended smart test on Disk
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Performing Extended SMART test on Drive "%drive_letter%:" >																											%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- >																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. >																																													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
smartctl -t long %drive_letter%:
echo waiting 60 seconds to poll status again > 																																			%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
timeout /t 60 > nul

:extended_smart_in_progress
for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:\ ^| find /i "% of test"') do (
		echo.
		echo.
		Echo Extended SMART test on Disk "%drive_letter%:" -- %%O"
 
		echo. %%O | findstr /C:"^%" 1>nul

		if errorlevel 1 (
		  echo %date% %time% SMART test is in progress... waiting 60 seconds to poll status again
		  REM pause for 60 seconds
		  timeout /t 60 > nul
		  goto :extended_smart_in_progress
		) ELSE (
		  echo SMART test is not in progress, proceeding with rest of script
		  goto :extended_smart_test_complete
		)
	) 
	
:extended_smart_test_complete



REM display final disk SMART parameters and save to the log file
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- > 																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo %date% %time% Current SMART attributes for Drive "%drive_letter%:" > 																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo --------------------------------------------------------------------------------------------------------------- > 																	%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo. > 																																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

for /f "tokens=*" %%O in ('smartctl -x %drive_letter%:') do (Echo %%O  > 																												%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%)

echo ####################################################### >																															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo ####################################################### > 																															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo ####################################################### >																															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo ####################################################### > 																															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%

echo %date% %time% DONE > 																																								%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
title DONE
pause
exit



:exit_now
echo The disks selected to test was drive C. To prevent system damage the script is exiting. Please ensure to select the correct disk next time > 										%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
pause
exit

:pause_exit
pause
exit

:smart_fail
echo The disk under test was reporting as failed or near failed, so this script will be exiting. Please check the status of your disks using the log file to determine more details on the disk's status and what might be causing the failure> 															%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo Common paramters to check in the log file that should be reporting a value of zero (or using freeware like Crystal Disk Info): > 													%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo 1.) Reallocated_Sector_Ct > 																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo 2.) Hardware_ECC_Recovered > 																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo 3.) Offline_Uncorrectable > 																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo 4.) Current_Pending_Sector > 																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo 5.) Reallocated_Event_Count > 																																						%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
echo     Please note however that different dirves may have different paramters > 																										%tmp_file% && type %tmp_file% && type %tmp_file% >> %log_file%
pause
exit



