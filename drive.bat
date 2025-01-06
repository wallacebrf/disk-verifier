@ECHO off
@ECHO off
set start_date=%date:~4,2%-%date:~7,2%-%date:~10,4%


REM INSTRUCTIONS:
REM 1.) download the exf program from https://www.exactfile.com/downloads/ and place the "exf" executable in your "c:\windows\system 32" directory 
REM 2.) create a folder c:\video
REM 3.) copy a large file of your choice (the bigger the better) to the c:\video folder, and update the line "set video_file_location="C:\video\movie.mkv"" with the file name being copied
REM 4.) right click on the file and select properties to get the total number of bytes for the file and update the line Set "movie_size=156750742" to match the file's size in bytes
REM 5.) using 7-zip or other utility, generate a CRC32 value for the file saved to c:\video folder and update the line "set video_file_crc32_value=2517E216" with the correct CRC value
REM 6.) attach the drive test to be tested to the machine this script will run on
REM 7.) launch the script as administrator by right clicking the file and "run as administrator", and follow the instructions. 


rem USER VARIABLES
REM set this variable to be the number of bytes the video file to be copied. 
Set movie_size=156750742
set results_file="C:\Users\%USERNAME%\Desktop\results_%start_date%.md5"
set video_file_location="C:\video\movie.mkv"
set video_file_crc32_value=2517E216




REM SCRIPT START - DO NOT EDIT ANYTHING PAST THIS LINE

REM creating required header of the CRC file that will later be used to verify files were written to the disk correctly 
echo ; Checksums generated by ExactFile Console Application 1.0.1.6 BETA > %results_file%
echo ; www.ExactFile.com >> %results_file%
echo ; 1/3/2025 4:48:45 PM >> %results_file%
echo ; >> %results_file%

REM print out menu and get the details on all installed disks and asking the user what disk they wish to test

title Server Disk Replacement Verifier

echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Disk Model and Serial Number of all drives installed on the system:
echo ---------------------------------------------------------------------------------------------------------------
wmic diskdrive get Model, SerialNumber
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Disk Size and Free Space
echo ---------------------------------------------------------------------------------------------------------------
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
)
echo.
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Available Drives on the System:
echo ---------------------------------------------------------------------------------------------------------------
wmic logicaldisk get Caption,volumename
echo.
echo.
ECHO What drive shall be tested?
echo.
set /P drive_letter=Drive letter [A-Z]=
echo.

if /I "%drive_letter%" EQU "a" set DRIVE=A
if /I "%drive_letter%" EQU "b" set DRIVE=B
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
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Getting Latest SMART status for Drive "%drive_letter%:"
echo ---------------------------------------------------------------------------------------------------------------
echo.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get status`) DO (
 
	echo.%%F | findstr /C:"unknown" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo. Error - Disk is reporting as "Unknown"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"bad" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "bad"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"caution" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Caution"
	  goto :smart_fail
	)
	
	echo.%%F | findstr /C:"Pred Fail" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Pred Fail"
	  goto :smart_fail
	)
)

ENDLOCAL

REM starting of the testing process by performing a full disk format
echo ---------------------------------------------------------------------------------------------------------------
echo Performing full format of drive "%drive_letter%:" using command "FORMAT %drive_letter%: /FS:NTFS /P:1 /X"
echo "/FS:NTFS" -- Formatting file system as NTFS
echo "/P:1" --  Zero every sector on the volume.  After that, the volume will be overwritten "1" times using a different random number each time.
echo "/X" -- Forces the volume to dismount first if necessary.
echo ---------------------------------------------------------------------------------------------------------------
echo.
title Performing full format of drive %drive_letter%:
echo.
FORMAT %drive_letter%: /FS:NTFS /P:1 /X




echo.
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Copying 10,000 copies of file "%video_file_location%" to disk "%drive_letter%:" or until the drive is full whichever occurs first
echo ---------------------------------------------------------------------------------------------------------------
echo.
title Copying file to disk %drive_letter%

Set "Blank=               "
for /l %%A in (1,1,10000) do (
	echo Processing file number %%A on Drive "%drive_letter%:"
	
	REM check if there is enough disk space
	
	for /f "tokens=2" %%O in ('wmic LogicalDisk Get DeviceID^,FreeSpace ^| find /i "D:" 2^> nul') do (
		Echo Free Space="%%O" Bytes Remaining...
		Echo Movie Size="%movie_size%" Bytes
 
		If %%O gtr %movie_size% (
			echo %video_file_crc32_value% ?CRC32*movie-%%A.mkv >> %results_file%
			esentutl /y "%video_file_location%" /d "%drive_letter%:\movie-%%A.mkv" /o
			REM goto :copy_done
		) else (
			Echo Not enough free space on disk %drive_letter% for movie-%%A.mkv
			Echo Copy process is complete.....
			goto :copy_done
		)
	)
)
:copy_done

REM Get SMART status
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Getting Latest SMART status for Drive "%drive_letter%:"
echo ---------------------------------------------------------------------------------------------------------------
echo.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get status`) DO (
 
	echo.%%F | findstr /C:"unknown" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo. Error - Disk is reporting as "Unknown"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"bad" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "bad"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"caution" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Caution"
	  goto :smart_fail
	)
	
	echo.%%F | findstr /C:"Pred Fail" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Pred Fail"
	  goto :smart_fail
	)
)

ENDLOCAL

echo Performing CRC Check of files copied to Drive "%drive_letter%:"
title Performing CRC Check of files copied to Drive "%drive_letter%:"
echo command is exf -c %results_file% -mt 16 -d "%drive_letter%:\"
exf -c %results_file% -mt 16 -d "%drive_letter%:\"

REM Get SMART status
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Getting Latest SMART status for Drive "%drive_letter%:"
echo ---------------------------------------------------------------------------------------------------------------
echo.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get status`) DO (
 
	echo.%%F | findstr /C:"unknown" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo. Error - Disk is reporting as "Unknown"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"bad" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "bad"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"caution" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Caution"
	  goto :smart_fail
	)
	
	echo.%%F | findstr /C:"Pred Fail" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Pred Fail"
	  goto :smart_fail
	)
)

ENDLOCAL


echo Were any errors reported from the CRC check?
echo Y.) YES - This script will exit and the drive is probably bad
echo N.) NO - Continue Script
echo.
set /P c=Choose an option [Y,N]?


if /I "%c%" EQU "N" goto :option_2
if /I "%c%" EQU "Y" goto :pause_exit


:option_2
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Performing full Check Disk of %drive_letter% using commnd chkdsk %drive_letter%: /f /r /x
echo "/F" -- Fixes errors on the disk.
echo "/R" -- Locates bad sectors and recovers readable information
echo "/X" -- Forces the volume to dismount first if necessary.
echo ---------------------------------------------------------------------------------------------------------------
echo.
title Performing full Check Disk of Drive "%drive_letter%:"
echo.
chkdsk %drive_letter%: /f /r /x

REM Get SMART status
echo.
echo ---------------------------------------------------------------------------------------------------------------
echo Getting Latest SMART status for Drive "%drive_letter%:"
echo ---------------------------------------------------------------------------------------------------------------
echo.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=* USEBACKQ" %%F IN (`wmic diskdrive get status`) DO (
 
	echo.%%F | findstr /C:"unknown" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo. Error - Disk is reporting as "Unknown"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"bad" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "bad"
	  goto :smart_fail
	)

	echo.%%F | findstr /C:"caution" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Caution"
	  goto :smart_fail
	)
	
	echo.%%F | findstr /C:"Pred Fail" 1>nul

	if errorlevel 1 (
	  REM no error
	) ELSE (
	  echo.  Error - Disk is reporting as "Pred Fail"
	  goto :smart_fail
	)
)

ENDLOCAL

REM performing a quick disk format
echo ---------------------------------------------------------------------------------------------------------------
echo Performing quick format of drive "%drive_letter%:" using command "FORMAT %drive_letter%: /FS:NTFS /Q"
echo "/FS:NTFS" -- Formatting file system as NTFS
echo "/Q" --  Quick Format
echo ---------------------------------------------------------------------------------------------------------------
echo.
title Performing quick format of drive %drive_letter%:
echo.
FORMAT %drive_letter%: /FS:NTFS /Q

echo #######################################################
echo #######################################################
echo #######################################################
echo #######################################################

echo DONE
title DONE
pause
exit



:exit_now
echo One or more of the disks selected was drive C. To prevent system damage the script is exiting
pause
exit

:pause_exit
exit

:smart_fail
echo A disk was reporting as failed or near failed, so this script will be exiting. please check the status of your disks
pause
exit


