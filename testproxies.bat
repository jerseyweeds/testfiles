@echo off
setlocal enabledelayedexpansion

set username=XXXXXXXX
set password=XXXXXXXX

set proxylist=.\proxylist.txt
set portlist=.\portlist.txt
set logfile=.\proxytests.log
set /a num_lines=0
set /a position=0

move /Y !logfile! !logfile!.old

for /f %%l in (!proxylist!) do ( set /a num_lines=!num_lines!+1)

set curlexe="C:\ProgramData\Anaconda3\Library\bin\curl.exe"
set testfile="http://cachefly.cachefly.net/5mb.test"
set junkfile=-o .\testfile.txt

echo {date}	{time}	{proxy}	{port}	{response_code}	{size_download}	{speed_download}	{time_appconnect}	{time_connect}	{time_namelookup}	{time_pretransfer}	{time_redirect}	{time_starttransfer}	{time_total} >> !logfile!

for /f %%a in (!proxylist!) do (
  set /a position=!position!+1
  set proxy=%%a
  
  echo Testing !position! of !num_lines!: !proxy!
  
  for /f %%b in (!portlist!) do (
    set port=%%b
    set curlopts=-s --socks5 !username!:!password!@!proxy!:!port!
    set curloutput=--write-out "!date!\t!time!\t!proxy!\t!port!\t%%{response_code}\t%%{size_download}\t%%{speed_download}\t%%{time_appconnect}\t%%{time_connect}\t%%{time_namelookup}\t%%{time_pretransfer}\t%%{time_redirect}\t%%{time_starttransfer}\t%%{time_total}\n"

    !curlexe! !testfile! !junkfile! !curlopts! !curloutput! >> !logfile!
    )  
 )   
