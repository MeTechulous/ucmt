@Echo Off
Title Windows Computer Migration Tool

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::  ~~~~~~~~~~~~ Variable Registry ~~~~~~~~~~~~

:: CHROME
::
Set ADLGoogle=%drivetarget%:\Users\%username%\AppData\Local\Google
Set ADRGoogle=%drivetarget%:\Users\%username%\AppData\Roaming\Google
SET chrotarget1=Bookmarks
SET chrotarget2=Bookmarks.bak

:: FIREFOX
::
Set ADLFirefox=%drivetarget%:\Users\%username%\AppData\Local\Mozilla
Set ADRFirefox=%drivetarget%:\Users\%username%\AppData\Roaming\Mozilla
SET firetarget1=places.sqlite
SET firetarget2=places.sqlite-shm
SET firetarget3=places.sqlite-wal

:: INTERNET EXPLORER
::
SET iedir="%drivetarget%\Users\%username%\Favorites"

:: EDGE
::
SET edgedir=

:: UNIQUE DIRECTORIES / VARIABLES
::
SET sr=".\script_resources"
SET rclog=".\BACKUP_DATA\DataMigrationLog.txt"

:: USER DATA BACKUP DIRECTORIES
::
Set Contacts=%drivetarget%:\Users\%username%\Contacts
Set Desktop=%drivetarget%:\Users\%username%\Desktop
Set Documents=%drivetarget%:\Users\%username%\Documents
Set Downloads=%drivetarget%:\Users\%username%\Downloads
Set Favorites=%drivetarget%:\Users\%username%\Favorites
Set Links=%drivetarget%:\Users\%username%\Links
Set Music=%drivetarget%:\Users\%username%\Music
Set Pictures=%drivetarget%:\Users\%username%\Pictures
Set Searches=%drivetarget%:\Users\%username%\Searches
Set Videos=%drivetarget%:\Users\%username%\Videos

:: MICROSOFT OFFICE APP DATA DIRECTORIES
::
Set ADRMDBB=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\"Document Building Blocks"
Set ADRMCrypto=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\Crypto
Set ADRMProof=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\Proof
Set ADRMProtect=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\Protect
Set ADRMSignatures=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\Signatures
Set ADRMStationery=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\Stationery
Set ADRMSysCert=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\SystemCertificates
Set ARMUProof=%drivetarget%:\Users\%username%\AppData\Roaming\Microsoft\UProof



:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

goto start 

=======================================================
--------------------- To-Do List ----------------------
=======================================================

- Fetch Web Browser Profile
    Edge
- List of Intsalled applications


=======================================================
--------------------- CHANGE LOG ----------------------
=======================================================



:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::
:start

Echo.
Echo =======================================================
Echo -------- Windows Computer Migration Tool v0.1 ---------
Echo =======================================================


:: ~~~~~~~~~~~~ Check for Admin ~~~~~~~~~~~~
::
Echo.
Echo Checking Administrative Rights....

openfiles>nul 2>&1
if %errorlevel% EQU 0 goto startscript

Echo.
Echo In order for this script to run properly, it is necessary
Echo for the script to have Administrative Rights.
Echo.
Echo Please rerun this script as an Administrator.
Echo.
Echo Press Enter to close the script...
pause>nul
exit

:startscript

Echo.
Echo The script is running with elevated rights.


::
:: ~~~~~~~~~~~~ Start ~~~~~~~~~~~~
::


:: Navigate to Folder where Script Exists
::
cd %~dp0

:: Create folder for Backup Repository
::
mkdir .\BACKUP_DATA
SET mdrepo=".\BACKUP_DATA"

:: Inquire Target Drive
::
SET /P drivetarget=What is the target Drive Letter? [Default = C:\]:
If "%drivetarget%" EQU "" SET driveletter=C

::
::  ~~~~~ PST FILES ~~~~~
::

:: Backup PST Files using PS
::
Powershell.exe -ExecutionPolicy Bypass -Command .\%sr%\PSTFinder.ps1

:: PST should have been created at C:\PSTRepo.  This will move them to external media.
:: 
SET rctarget="%drivetarget%\PSTRepo"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V

::
::  ~~~~~ WEB BROWSER DATA ~~~~~
::

::  CHROME 
::
SET repo=Chrome_DATA
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%ADLGoogle%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRGoogle%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V


::  FIREFOX 
::
SET repo=Firefox_DATA
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%ADLFirefox%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRFirefox%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V

::  IE 
::
SET repo=IE_DATA
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%Favorites%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V

 
::  EDGE 
::
::mkdir %mdrepo%\Edge_DATA
::SET rctarget="%drivetarget%\%%"
::SET rclog=".\BACKUP_DATA\LOGS\"
::ROBOCOPY %rctarget% .\BACKUP_DATA\PST_Files /E /ZB /J /COPYALL /XJD /R:3 /W:10 /FFT /LOG:"%rclog%" /V


::
:: ~~~~~ MICROSOFT OFFICE ~~~~~
::

:: Office AppData
::
SET repo=Office_DATA
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%ADRMDBB%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMCrypto%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMProof%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMProtect%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMSignatures%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMStationery%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ADRMSysCert%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%ARMUProof%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V

::
:: ~~~~~ GENERAL USER DATA ~~~~~
::

:: User Data
::
SET repo="User_DATA-%username%"
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%Contacts%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Desktop%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Documents%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Downloads%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Favorites%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Links%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Music%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Pictures%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Searches%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V
SET rctarget="%drivetarget%\%Videos%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V



exit

::
::
::
::
::

::  COMMANDS

SET repo=
mkdir %mdrepo%\%repo%
SET rctarget="%drivetarget%\%%"
ROBOCOPY %rctarget% %mdrepo%\%repo% /E /ZB /J /COPYALL /XJD /R:3 /W:1 /FFT /LOG+:"%rclog%" /V



