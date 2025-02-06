@ECHO OFF
Title BOR Scan Utility
::Assembled by F1X3R

setlocal
setlocal enabledelayedexpansion

:MENU
CLS
COLOR 0A
ECHO.                                   
ECHO     _/_/_/      _/_/    _/_/_/    
ECHO    _/    _/  _/    _/  _/    _/   
ECHO   _/_/_/    _/    _/  _/_/_/      
ECHO  _/    _/  _/    _/  _/    _/     
ECHO _/_/_/      _/_/    _/    _/      
ECHO.                                   


ECHO.
ECHO ===== Select The Required Option ===== 
ECHO --------------------------------------
ECHO 1.  Run Scans on the Local Computer
ECHO 2.  Run Scans on a Remote Computer
ECHO 3.  Look up AD User Information
ECHO 4.  Look up AD Computer
ECHO 5.  Get DNS info from a domain name
ECHO 6.  Perform a DNS Reverse Lookup
ECHO 7.  Generate a HASH from a file
ECHO --------------------------------------
ECHO ==========PRESS 'Q' TO QUIT===========
ECHO.

CHOICE /N /C:1234567Q /M "Please select an option:"%1

IF %ERRORLEVEL% EQU 1 GOTO LOCALMENU
IF %ERRORLEVEL% EQU 2 GOTO REMOTEMENU
IF %ERRORLEVEL% EQU 3 GOTO ADUSER
IF %ERRORLEVEL% EQU 4 GOTO ADCOMP
IF %ERRORLEVEL% EQU 5 GOTO DNSDUMP
IF %ERRORLEVEL% EQU 6 GOTO REVDNS
IF %ERRORLEVEL% EQU 7 GOTO GENHASH
IF %ERRORLEVEL% EQU 8 GOTO END


:LOCALMENU
CLS
ECHO.
ECHO =========== Select The Required Scan =========== 
ECHO ------------------------------------------------
ECHO 1.  Scan Local Computer
ECHO 2.  Display external IP
ECHO 3.  Check BitLocker Compliance
ECHO 4.  Show Current AntiVirus on Local
ECHO 5.  Show Network Shares info on Local
ECHO 6.  Show Network Information on Local
ECHO 7.  Show Stored Wireless Profiles and Passwords
ECHO 8.  Run Scans and Output to File
ECHO 9.  Output Local Services to File
ECHO ------------------------------------------------
ECHO ========PRESS 'Q' TO RETURN TO MAIN MENU========
ECHO.

CHOICE /N /C:123456789Q /M "Please select an option:"%1

IF %ERRORLEVEL% EQU 1 GOTO LOCALSCAN
IF %ERRORLEVEL% EQU 2 GOTO LOCALEXTIP
IF %ERRORLEVEL% EQU 3 GOTO LOCALBITCHECK
IF %ERRORLEVEL% EQU 4 GOTO LOCALVIRUS
IF %ERRORLEVEL% EQU 5 GOTO LOCALSHARED
IF %ERRORLEVEL% EQU 6 GOTO LOCALNETCON
IF %ERRORLEVEL% EQU 7 GOTO LOCALWIFI
IF %ERRORLEVEL% EQU 8 GOTO LOCALDATAOUTPUT
IF %ERRORLEVEL% EQU 9 GOTO LOCALSERVICESOUTPUT
IF %ERRORLEVEL% EQU 10 GOTO MENU


:REMOTEMENU
CLS
ECHO.
ECHO ====== Select The Required Scan ====== 
ECHO --------------------------------------
ECHO 1.  Scan Network Computer
ECHO 2.  Look up Logged in User on Remote
ECHO 3.  Check BitLocker Compliance on Remote
ECHO 4.  Show Current AntiVirus on Remote
ECHO 5.  Show Network Shares Info on Remote
ECHO 6.  Show Network Information on Remote
ECHO 7.  Run Scans and Output to File
ECHO 8.  Output Remote Services to File
ECHO --------------------------------------
ECHO ===PRESS 'Q' TO RETURN TO MAIN MENU===
ECHO.

SET FEEDMENU=Z
CHOICE /N /C:12345678Q /M "Please select an option:"%1 

IF %ERRORLEVEL% EQU 1 SET FEEDMENU=SCAN && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 2 SET FEEDMENU=USER && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 3 SET FEEDMENU=BITLOCK && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 4 SET FEEDMENU=VIRUS && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 5 SET FEEDMENU=SHARED && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 6 SET FEEDMENU=NETCON && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 7 SET FEEDMENU=OUTPUTSCAN && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 8 SET FEEDMENU=OUTPUTSERVICES && GOTO REMOTEINPUT
IF %ERRORLEVEL% EQU 9 GOTO MENU

	
:ADUSER
	CLS
	ECHO Enter an Active Directory user name or Q FOR the previous menu.
	ECHO.
	SET ADU=Z
	SET /P ADU=
	IF /I %ADU% EQU Q GOTO MENU
	IF /I %ADU% EQU Z GOTO ADUSER
	net user %ADU% /domain
	PAUSE
	GOTO ADUSER

:ADCOMP
	CLS
	ECHO Enter the name of a Domain joined computer or Q FOR the previous menu.
	ECHO.
	SET ADC=Z
	SET /P ADC=
	IF /I %ADC% EQU Q GOTO MENU
	IF /I %ADC% EQU Z GOTO ADUSER
			REM Presetting the variables
	SET ADName="Information not in AD"
	SET ADDes="Information not in AD"
	SET ADDN="Information not in AD"
	SET ADLALO="Information not in AD"
	SET ADLALOHR="Information not in AD"
	FOR /f "tokens=* delims==" %%f in ('dsquery * domainroot -filter "(&(objectCategory=computer)(name=%ADC%))" -attr name') do SET "ADName=%%f"
	FOR /f "tokens=* delims==" %%f in ('dsquery * domainroot -filter "(&(objectCategory=computer)(name=%ADC%))" -attr description') do SET "ADDes=%%f"
	FOR /f "tokens=* delims==" %%f in ('dsquery * domainroot -filter "(&(objectCategory=computer)(name=%ADC%))" -attr DistinguishedName') do SET "ADDN=%%f"
	FOR /f "tokens=* delims== " %%f in ('dsquery * domainroot -filter "(&(objectCategory=computer)(name=%ADC%))" -attr lastLogonTimestamp') do SET "ADLALO=%%f"
		REM The following command used to isolate the number portion of the variable
	SET ADLALO=%ADLALO:  =%
		REM Using w32tm.exe to convert the 18-digit LDAP timestamp to human readable
	FOR /f "tokens=2 delims==-" %%f in ('w32tm.exe /ntte %ADLALO%') do SET "ADLALOHR=%%f"
	ECHO.
	ECHO ____________Domain Computer Information_____________________________________________________________
	ECHO.
	ECHO          System Name  =%ADName%
	ECHO.
	ECHO   System Description  =%ADDes%
	ECHO.
	ECHO            System OU  =%ADDN%
	ECHO.
	ECHO System Last AD Logon  = %ADLALOHR%
	ECHO.
	ECHO.
	PAUSE
	GOTO ADCOMP

:DNSDUMP
	CLS
	ECHO.        
	ECHO ^*^* Note: Some DNS Providers will obscure the results, i.e. CloudFlare. ^*^*
	ECHO.
	ECHO                Enter a Domain name or Q FOR the previous menu.     
	ECHO.
	SET DNAME=Z
	SET /P DNAME=
	IF /I %DNAME% EQU Q GOTO MENU
	IF /I %DNAME% EQU Z GOTO DNSDUMP
	ECHO.
	nslookup -type=any %DNAME%
	ECHO.
	ECHO.
	ECHO Saving output to the file %cd%\DNSDump_%DNAME%.txt
	nslookup -type=any %DNAME% > DNSDump_%DNAME%.txt
	PAUSE
	GOTO DNSDUMP

:REVDNS
	CLS
	ECHO.
	ECHO ^*^* Note: Some DNS Providers will obscure the results, i.e. CloudFlare. ^*^*
	for /F  %%I in ('curl -s http://ifconfig.me') do set ExtIP=%%I
	ECHO              (Your current external IP is likely %ExtIP%.)
	ECHO.
	ECHO    Enter an external IP Address to look up, or Q FOR the previous menu.
	ECHO.
	SET REVNAME=Z
	SET /P REVNAME=
	IF /I %REVNAME% EQU Q GOTO MENU
	IF /I %REVNAME% EQU Z GOTO REVDNS
	ECHO.
    for /f "tokens=1-4 delims=." %%a in ("%REVNAME%") do (set revip=%%d.%%c.%%b.%%a.in-addr.arpa)
	ECHO Using current name server to reverse lookup %REVIP%.
	ECHO.
	nslookup -type=ptr %REVIP%
	ECHO.
	PAUSE
	GOTO REVDNS
	
:GENHASH
	CLS
	ECHO BOR File Hash Utility
	ECHO =====================
	ECHO.
	GOTO HASHFILE

:HASHFILE
	:: Prompt user for the file path
	ECHO Enter the full path to the file or Q to quit: 
	ECHO.
	SET hashfilepath=Z
	SET /P hashfilepath=
	IF /I %hashfilepath% EQU Z GOTO HASHFILE
	IF /I %hashfilepath% EQU Q GOTO MENU
	ECHO.
	:: Check if file exists
	IF not exist "%hashfilepath%" ECHO File not found, try again. & GOTO HASHFILE > nul
	GOTO HASHTYPE

:HASHTYPE
	ECHO == Select Hash Type == 
	ECHO ----------------------
	ECHO 1.  MD4
	ECHO 2.  MD5
	ECHO 3.  SHA1
	ECHO 4.  SHA256 
	ECHO 5.  SHA512
	ECHO ----------------------
	ECHO ==PRESS 'Q' TO QUIT===
	ECHO.

	SET HASHTYPE=Z
	CHOICE /N /C:12345Q /M "Please select an option:"%1
 
	IF %ERRORLEVEL% EQU 1 SET HASHTYPE=MD4 && GOTO GENERATE
	IF %ERRORLEVEL% EQU 2 SET HASHTYPE=MD5 && GOTO GENERATE
	IF %ERRORLEVEL% EQU 3 SET HASHTYPE=SHA1 && GOTO GENERATE
	IF %ERRORLEVEL% EQU 4 SET HASHTYPE=SHA256 && GOTO GENERATE
	IF %ERRORLEVEL% EQU 5 SET HASHTYPE=SHA512 && GOTO GENERATE
	IF %ERRORLEVEL% EQU 6 GOTO MENU

:GENERATE
	FOR /f "skip=1 tokens=*" %%i IN ('certutil -hashfile "%hashfilepath%" %HASHTYPE% ^| findstr /v "CertUtil"') DO (
        SET hash=%%i
		)
	:: Display the resulting hash
	ECHO.
	ECHO The %HASHTYPE% hash for %hashfilepath% is:
	ECHO.
	ECHO %hash%	
	ECHO.
	PAUSE
	GOTO GENHASH

:LOCALSCAN
	SET PC=%computername%
	SET FEEDMENU=SCANLOCAL
	WMIC.EXE /? >NUL 2>&1 || GOTO REMOTEWMI
	GOTO LOCALSCAN2
	
:LOCALSCAN2
	ECHO.
	ECHO ^*^*^* Scanning %computername% . . . ^*^*^*
	ECHO. 
	FOR /f "tokens=2 delims==" %%f in ('wmic computersystem get domain /value') do SET "LocalDomain=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic systemenclosure get SMBIOSAssetTag /value') do SET "LocalAssetTag=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get Identifyingnumber /value') do SET "LocalSN=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get Name /value') do SET "LocalModel=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get vendor /value') do SET "LocalVendor=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get version /value') do SET "LocalVersion=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get Caption /value') do SET "LocalOSName=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get Version /value') do SET "LocalOSVers=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get OSArchitecture /value') do SET "LocalOSArch=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic path softwarelicensingservice get OA3xOriginalProductKey /value') do SET "LocalProdKey=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get LastBootUpTime /value') do SET "LOSLB=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get LocalDateTime /value') do SET "LOSDT=%%f"
	SET LocalOSLastBoot=%LOSLB:~0,4%-%LOSLB:~4,2%-%LOSLB:~6,2% %LOSLB:~8,2%:%LOSLB:~10,2%:%LOSLB:~12,2%
	SET LocalOSDateTime=%LOSDT:~0,4%-%LOSDT:~4,2%-%LOSDT:~6,2% %LOSDT:~8,2%:%LOSDT:~10,2%:%LOSDT:~12,2%
	ECHO __SOFTWARE________________________________________________________________________________
	ECHO               System Name = %computername%
	ECHO           Computer Domain = %LocalDomain%
	ECHO             Serial Number = %LocalSN%
	ECHO                 Asset Tag = %LocalAssetTag%
	ECHO            Make and Model = %LocalVendor%  %LocalModel%
	ECHO          Operating System = %LocalOSName% - %LocalOSVers% - %LocalOSArch% 
	ECHO               Product Key = %LocalProdKey%
	ECHO         Last Startup Time = %LocalOSLastBoot%
	ECHO     Current Date and Time = %LocalOSDateTime%
	ECHO.
	ECHO __PROCESSOR_______________________________________________________________________________
	wmic cpu get DeviceID,Name,NumberofCores,NumberOfLogicalProcessors
	ECHO __MEMORY__________________________________________________________________________________
	wmic MEMORYCHIP get banklabel, capacity, devicelocator, partnumber
	ECHO __HARD DRIVE______________________________________________________________________________
	wmic diskdrive get Model, Size, SerialNumber, mediaType
	ECHO __LOGICAL DISK____________________________________________________________________________
	wmic logicaldisk GET name,freespace,SystemName,FileSystem,Size,VolumeSerialNumber
	ECHO __NETWORK_________________________________________________________________________________
	wmic nic WHERE PhysicalAdapter="TRUE" get Name, MACAddress, NetConnectionID	
	PAUSE
	GOTO LOCALMENU
	
:LOCALEXTIP
	CLS
	ECHO.
	ECHO ^*^*^* Collecting %computername%'s External IP . . . ^*^*^*
	ECHO.
	for /F  %%I in ('curl -s http://ifconfig.me') do set ExtIP=%%I
	ECHO.
	ECHO Your likely external IP is %ExtIP%.
	ECHO.
	SET ExtLoopCount=1
	for /f "skip=2 delims=" %%a in ('nslookup %ExtIP%') do (
		if !ExtLoopCount!==1 set RevHost=%%a
		SET ExtLoopCount=0
		)
	ECHO Reverse IP Host %RevHost%
	ECHO.
	PAUSE
	GOTO LOCALMENU
	
:LOCALBITCHECK
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %computername% FOR BitLocker Status . . . ^*^*^*
	ECHO.
	manage-bde -status
	PAUSE
	GOTO LOCALMENU

:LOCALVIRUS
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %computername% FOR installed AntiVirus . . . ^*^*^*
	ECHO.
	wmic /namespace:\\root\securitycenter2 path antivirusproduct get displayname,pathToSignedReportingExe,timestamp
	PAUSE
	GOTO LOCALMENU

:LOCALNETCON
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %computername% FOR Network adapter information . . . ^*^*^*
	ECHO.
	ipconfig /all
	PAUSE
	GOTO LOCALMENU

:LOCALWIFI
	CLS
	ECHO Wireless profile names and passphrases found on %computername%
	ECHO.
	ECHO Wireless Profile Name               Wireless Passphrase
	ECHO ---------------------               -------------------
		FOR /F "tokens=2 delims=:" %%a IN ('netsh wlan show profile') DO (
		SET wifi_pwd=
		FOR /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| findstr "Key Content"`) DO (
			SET wifi_pwd=%%F
		)
		CALL :PrintWiFiAligned "%%a" "!wifi_pwd!"
	)
	ECHO.
	ECHO.
	PAUSE
	GOTO LOCALMENU
	
:PrintWiFiAligned
	SET "spaces=                                                  "
	SET "wifi_name=%~1"
	SET "passphrase=%~2"
	SET "paddedname=%wifi_name%%spaces%
	ECHO !paddedname:~0,35! %passphrase%
	GOTO :EOF

:LOCALSHARED
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %computername% FOR Network Shares . . . ^*^*^*
	ECHO.
	net view /all \\%computername%
	PAUSE
	GOTO LOCALMENU

:REMOTEINPUT
	CLS
	ECHO Enter computer name, IP address, or Q FOR the previous menu.
	ECHO.
	SET PC=Z
	SET /P PC=
	IF /I %PC% EQU Q GOTO REMOTEMENU
	IF /I %PC% EQU Z GOTO REMOTEINPUT
	PING %PC% -n 2 2>NUL | FIND "TTL=" >NUL || GOTO REMOTEPING
	WMIC.EXE /node:"%PC%" /? >NUL 2>&1 || GOTO REMOTEWMI
	If /I %FEEDMENU% EQU SCAN GOTO REMOTESCAN
	If /I %FEEDMENU% EQU USER GOTO REMOTEUSER
	If /I %FEEDMENU% EQU BITLOCK GOTO REMOTEBITCHECK
	IF /I %FEEDMENU% EQU VIRUS GOTO REMOTEVIRUS
	If /I %FEEDMENU% EQU SHARED GOTO REMOTESHARED
	If /I %FEEDMENU% EQU NETCON GOTO REMOTENETCON
	If /I %FEEDMENU% EQU OUTPUTSCAN GOTO REMOTEDATAOUTPUT
	If /I %FEEDMENU% EQU OUTPUTSERVICES GOTO REMOTESERVICEOUTPUT
	If /I %FEEDMENU% EQU Z GOTO MENU

:REMOTEPING
	ECHO Unable to locate %PC% on the network, returning to previous.
	PAUSE
	GOTO REMOTEINPUT

:REMOTEWMI
	ECHO WMI Tools are not installed on %PC%, returning to previous.
	PAUSE
	If /I %FEEDMENU% EQU SCANLOCAL GOTO LOCALMENU
	GOTO REMOTEINPUT

:REMOTESCAN
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC%. . . ^*^*^*
	ECHO. 
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" computersystem get domain /value') do SET "RemoteDomain=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" systemenclosure get SMBIOSAssetTag /value') do SET "RemoteAssetTag=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get Identifyingnumber /value') do SET "RemoteSN=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get Name /value') do SET "RemoteModel=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get vendor /value') do SET "RemoteVendor=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get Caption /value') do SET "RemoteOSName=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get Version /value') do SET "RemoteOSVers=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get OSArchitecture /value') do SET "RemoteOSArch=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" path softwarelicensingservice get OA3xOriginalProductKey /value') do SET "RemoteProdKey=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get LastBootUpTime /value') do SET "ROSLB=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get LocalDateTime /value') do SET "ROSDT=%%f"
	SET RemoteOSLastBoot=%ROSLB:~0,4%-%ROSLB:~4,2%-%ROSLB:~6,2% %ROSLB:~8,2%:%ROSLB:~10,2%:%ROSLB:~12,2%
	SET RemoteOSDateTime=%ROSDT:~0,4%-%ROSDT:~4,2%-%ROSDT:~6,2% %ROSDT:~8,2%:%ROSDT:~10,2%:%ROSDT:~12,2%
	ECHO __SOFTWARE________________________________________________________________________________
	ECHO               System Name = %PC%
	ECHO           Computer Domain = %RemoteDomain%
	ECHO             Serial Number = %RemoteSN%
	ECHO                 Asset Tag = %RemoteAssetTag%
	ECHO            Make and Model = %RemoteVendor%  %RemoteModel%
	ECHO          Operating System = %RemoteOSName% - %RemoteOSVers% - %RemoteOSArch%
	ECHO               Product Key = %RemoteProdKey%
	ECHO         Last Startup Time = %RemoteOSLastBoot%
	ECHO     Current Date and Time = %RemoteOSDateTime%
	ECHO.
	ECHO __PROCESSOR_______________________________________________________________________________
	wmic /node:"%PC%" cpu get DeviceID,Name,NumberofCores,NumberOfLogicalProcessors
	ECHO __MEMORY__________________________________________________________________________________
	wmic /node:"%PC%" MEMORYCHIP get banklabel, capacity, devicelocator, partnumber
	ECHO __HARD DRIVE______________________________________________________________________________
	wmic /node:"%PC%" diskdrive get Model, Size, SerialNumber, mediaType
	ECHO __LOGICAL DISK____________________________________________________________________________
	wmic /node:"%PC%" logicaldisk GET name,freespace,SystemName,FileSystem,Size,VolumeSerialNumber
	ECHO __NETWORK_________________________________________________________________________________
	wmic /node:"%PC%" nic WHERE PhysicalAdapter="TRUE" get Name, MACAddress, NetConnectionID	
	SET RemoteSN= 
	SET RemoteAssetTag= 
	SET RemoteVendor= 
	SET RemoteModel= 
	SET RemoteOSName= 
	SET RemoteOSArch= 
	SET RemoteProdKey= 
	SET RemoteDomain= 
	SET RemoteOSLastBoot= 
	SET RemoteOSDateTime= 
	SET ROSLB= 
	SET ROSDT= 
	PAUSE
	GOTO REMOTEINPUT

:REMOTEUSER
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR Current User . . . ^*^*^*
	ECHO.
	ECHO The User logged into %PC% is ...
	ECHO.
	wmic /node:"%PC%" computersystem get username
	pause
	GOTO REMOTEINPUT

:REMOTESHARED
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR Network Shares . . . ^*^*^*
	ECHO.
	net view /all \\%PC%
	PAUSE
	GOTO REMOTEINPUT

:REMOTEBITCHECK
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR BitLocker Status . . . ^*^*^*
	ECHO.
	manage-bde -status -computername %PC%
	PAUSE
	GOTO REMOTEINPUT

:REMOTEVIRUS
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR installed AntiVirus . . . ^*^*^*
	ECHO.
	wmic /node:"%PC%" /namespace:\\root\securitycenter2 path antivirusproduct get displayname,pathToSignedReportingExe,timestamp
	PAUSE
	GOTO REMOTEINPUT

:REMOTENETCON
	CLS
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR Network adapter information . . . ^*^*^*
	ECHO.
	wmic /node:"%PC%" nicconfig WHERE IPEnabled=true get MACAddress,DHCPEnabled,DHCPServer,defaultIPGateway,IPAddress,IPSubnet,Caption,DNSServerSearchOrder /format:list
	PAUSE
	GOTO REMOTEINPUT

:LOCALDATAOUTPUT
	CLS
	ECHO.
	ECHO Running scans and outputting data, please wait.
	ECHO. 
	FOR /f "tokens=2 delims==" %%f in ('wmic computersystem get domain /value') do SET "LocalDomain=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic systemenclosure get SMBIOSAssetTag /value') do SET "LocalAssetTag=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get Identifyingnumber /value') do SET "LocalSN=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get Name /value') do SET "LocalModel=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get vendor /value') do SET "LocalVendor=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic csproduct get version /value') do SET "LocalVersion=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get Caption /value') do SET "LocalOSName=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get Version /value') do SET "LocalOSVers=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get OSArchitecture /value') do SET "LocalOSArch=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic path softwarelicensingservice get OA3xOriginalProductKey /value') do SET "LocalProdKey=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get LastBootUpTime /value') do SET "LOSLB=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic os get LocalDateTime /value') do SET "LOSDT=%%f"
	SET LocalOSLastBoot=%LOSLB:~0,4%-%LOSLB:~4,2%-%LOSLB:~6,2% %LOSLB:~8,2%:%LOSLB:~10,2%:%LOSLB:~12,2%
	SET LocalOSDateTime=%LOSDT:~0,4%-%LOSDT:~4,2%-%LOSDT:~6,2% %LOSDT:~8,2%:%LOSDT:~10,2%:%LOSDT:~12,2%
	ECHO Information from %computername% > "InfoDump_%computername%.txt"
	ECHO. >> "InfoDump_%computername%.txt"
	ECHO __SOFTWARE________________________________________________________________________________ >> "InfoDump_%computername%.txt"
	ECHO               System Name = %computername% >> "InfoDump_%computername%.txt"
	ECHO           Computer Domain = %LocalDomain% >> "InfoDump_%computername%.txt"
	ECHO             Serial Number = %LocalSN% >> "InfoDump_%computername%.txt"
	ECHO                 Asset Tag = %LocalAssetTag% >> "InfoDump_%computername%.txt"
	ECHO            Make and Model = %LocalVendor%  %LocalModel% >> "InfoDump_%computername%.txt"
	ECHO          Operating System = %LocalOSName% - %LocalOSVers% - %LocalOSArch% >> "InfoDump_%computername%.txt"
	ECHO               Product Key = %LocalProdKey% >> "InfoDump_%computername%.txt"
	ECHO         Last Startup Time = %LocalOSLastBoot% >> "InfoDump_%computername%.txt"
	ECHO     Current Date and Time = %LocalOSDateTime% >> "InfoDump_%computername%.txt"
	ECHO. >> "InfoDump_%computername%.txt"
	ECHO __PROCESSOR_______________________________________________________________________________ >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" cpu get DeviceID,Name,NumberofCores,NumberOfLogicalProcessors
	ECHO __MEMORY__________________________________________________________________________________ >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" MEMORYCHIP get banklabel, capacity, devicelocator, partnumber
	ECHO __HARD DRIVE______________________________________________________________________________ >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" diskdrive get Model, Size, SerialNumber, mediaType
	ECHO __LOGICAL DISK____________________________________________________________________________ >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" logicaldisk GET name,freespace,SystemName,FileSystem,Size,VolumeSerialNumber
	ECHO __NETWORK_________________________________________________________________________________ >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" nic WHERE PhysicalAdapter="TRUE" get Name, MACAddress, NetConnectionID
	for /F  %%I in ('curl -s http://ifconfig.me') do set ExtIP=%%I
	ECHO.
	ECHO Your likely external IP is %ExtIP%. >> "InfoDump_%computername%.txt"
	ECHO.
	nslookup %ExtIP% >> "InfoDump_%computername%.txt"
	ECHO.
	ECHO The User logged into %computername% is ... >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" computersystem get username
	ECHO ^*^*^* The Current Network Shares . . . ^*^*^* >> "InfoDump_%computername%.txt"
	net view /all \\%computername% >> "InfoDump_%computername%.txt"
	ECHO ^*^*^* The Installed AntiVirus, if any, is . . . ^*^*^* >> "InfoDump_%computername%.txt"
	ECHO. >> "InfoDump_%computername%.txt"
	wmic  /append:"%cd%\InfoDump_%computername%.txt" /namespace:\\root\securitycenter2 path antivirusproduct get displayname,pathToSignedReportingExe,timestamp
	ECHO. >> "InfoDump_%computername%.txt"
	ECHO ^*^*^* The Current Network Adapter Information is . . . ^*^*^* >> "InfoDump_%computername%.txt"
	ipconfig /all >> "InfoDump_%computername%.txt"
	ECHO.
	ECHO. >> "InfoDump_%computername%.txt"
	ECHO ^*^*^* The Installed Updates and Hotfixes . . . ^*^*^* >> "InfoDump_%computername%.txt"
	ECHO. >> "InfoDump_%computername%.txt"
	wmic /append:"%cd%\InfoDump_%computername%.txt" qfe get Caption, Description, HotFixID, InstalledOn
	CLS
	ECHO Output file "InfoDump_%computername%.txt" created in
	ECHO the directory this script was run from,
	ECHO probably %CD%.
	ECHO.
	PAUSE
	GOTO LOCALMENU

:LOCALSERVICESOUTPUT
	CLS
	ECHO The output file will be saved to %cd%.
	ECHO.
	ECHO ^*^*^* Scanning %computername% FOR Services Status . . . ^*^*^*
	ECHO.
	wmic /output:"%cd%\%computername%_services.txt" service get DisplayName, ProcessID, Started, StartMode, State
	ECHO File created at "%cd%\%computername%_services.txt".
	PAUSE
	GOTO LOCALMENU

:REMOTEDATAOUTPUT
	CLS
	ECHO.
	ECHO Running scans and outputting data, please wait.
	ECHO. 
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" computersystem get domain /value') do SET "RemoteDomain=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" systemenclosure get SMBIOSAssetTag /value') do SET "RemoteAssetTag=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get Identifyingnumber /value') do SET "RemoteSN=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get Name /value') do SET "RemoteModel=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" csproduct get vendor /value') do SET "RemoteVendor=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get Caption /value') do SET "RemoteOSName=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get Version /value') do SET "RemoteOSVers=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get OSArchitecture /value') do SET "RemoteOSArch=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" path softwarelicensingservice get OA3xOriginalProductKey /value') do SET "RemoteProdKey=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get LastBootUpTime /value') do SET "ROSLB=%%f"
	FOR /f "tokens=2 delims==" %%f in ('wmic /node:"%PC%" os get LocalDateTime /value') do SET "ROSDT=%%f"
	SET RemoteOSLastBoot=%ROSLB:~0,4%-%ROSLB:~4,2%-%ROSLB:~6,2% %ROSLB:~8,2%:%ROSLB:~10,2%:%ROSLB:~12,2%
	SET RemoteOSDateTime=%ROSDT:~0,4%-%ROSDT:~4,2%-%ROSDT:~6,2% %ROSDT:~8,2%:%ROSDT:~10,2%:%ROSDT:~12,2%
	ECHO Information from %PC% > InfoDump_%PC%.txt
	ECHO. >> InfoDump_%PC%.txt
	ECHO __SOFTWARE________________________________________________________________________________ >> InfoDump_%PC%.txt
	ECHO               System Name = %PC% >> InfoDump_%PC%.txt
	ECHO           Computer Domain = %RemoteDomain% >> InfoDump_%PC%.txt
	ECHO             Serial Number = %RemoteSN% >> InfoDump_%PC%.txt
	ECHO                 Asset Tag = %RemoteAssetTag% >> InfoDump_%PC%.txt
	ECHO            Make and Model = %RemoteVendor%  %RemoteModel% >> InfoDump_%PC%.txt
	ECHO          Operating System = %RemoteOSName% - %RemoteOSVers% - %RemoteOSArch% >> InfoDump_%PC%.txt
	ECHO               Product Key = %RemoteProdKey% >> InfoDump_%PC%.txt
	ECHO         Last Startup Time = %RemoteOSLastBoot% >> InfoDump_%PC%.txt
	ECHO     Current Date and Time = %RemoteOSDateTime% >> InfoDump_%PC%.txt
	ECHO. >> InfoDump_%PC%.txt
	ECHO __PROCESSOR_______________________________________________________________________________ >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" cpu get DeviceID,Name,NumberofCores,NumberOfLogicalProcessors
	ECHO __MEMORY__________________________________________________________________________________ >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" MEMORYCHIP get banklabel, capacity, devicelocator, partnumber
	ECHO __HARD DRIVE______________________________________________________________________________ >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" diskdrive get Model, Size, SerialNumber, mediaType
	ECHO __LOGICAL DISK____________________________________________________________________________ >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" logicaldisk GET name,freespace,SystemName,FileSystem,Size,VolumeSerialNumber
	ECHO __NETWORK_________________________________________________________________________________ >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" nic WHERE PhysicalAdapter="TRUE" get Name, MACAddress, NetConnectionID
	SET RemoteSN= 
	SET RemoteAssetTag= 
	SET RemoteVendor= 
	SET RemoteModel= 
	SET RemoteOSName= 
	SET RemoteOSArch= 
	SET RemoteProdKey= 
	SET RemoteDomain= 
	SET RemoteOSLastBoot= 
	SET RemoteOSDateTime= 
	SET ROSLB= 
	SET ROSDT= 
	ECHO The User logged into %PC% is ... >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" computersystem get username
	ECHO. >> InfoDump_%PC%.txt
	ECHO ^*^*^* The Current Network Shares . . . ^*^*^* >> InfoDump_%PC%.txt
	net view /all \\%PC% >> InfoDump_%PC%.txt
	ECHO.
	ECHO ^*^*^* The Installed AntiVirus, if any, is . . . ^*^*^* >> InfoDump_%PC%.txt
	ECHO. >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" /namespace:\\root\securitycenter2 path antivirusproduct get displayname,pathToSignedReportingExe,timestamp
	ECHO. >> InfoDump_%PC%.txt
	ECHO ^*^*^* The Current Network Adapter Information is . . . ^*^*^* >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" nicconfig WHERE IPEnabled=true get MACAddress,DHCPEnabled,DHCPServer,defaultIPGateway,IPAddress,IPSubnet,Caption,DNSServerSearchOrder /format:list
	ECHO.
	ECHO. >> InfoDump_%PC%.txt
	ECHO ^*^*^* The Installed Updates and Hotfixes . . . ^*^*^* >> InfoDump_%PC%.txt
	ECHO. >> InfoDump_%PC%.txt
	wmic /append:"%cd%\InfoDump_%PC%.txt" /node:"%PC%" qfe get Caption, Description, HotFixID, InstalledOn
	CLS
	ECHO Output file "InfoDump_%PC%.txt" created in
	ECHO the directory this script was run from,
	ECHO probably %CD%.
	ECHO.
	PAUSE
	GOTO REMOTEINPUT

:REMOTESERVICEOUTPUT
	CLS
	ECHO The output file will be saved to %cd%.
	ECHO.
	ECHO ^*^*^* Scanning %PC% FOR Services Status . . . ^*^*^*
	ECHO.
	wmic /node:%PC% /output:"%cd%\%PC%_services.txt" service get DisplayName, ProcessID, Started, StartMode, State
	ECHO File created at "%cd%\%PC%_services.txt".
	PAUSE
	GOTO REMOTEINPUT

:END
	endlocal
	CLS
	COLOR
	TITLE Command Prompt
	EXIT /B 1