cls
@echo off
call :ColorText 0E "Script by 1024.gr"

setlocal enableextensions enabledelayedexpansion

pushd %~dp0

call :ColorText 0A "Starting batch process"
for %%x in ("%~1\*.avi" "%~1\*.mp4") do (
  CALL :process "%%x"
)

popd

:process
  echo Proccessing file %~1...
  
  call :ColorText 0A "Extracting & Converting video.."
  ffmpeg -i "%~1" -map 0:0 -vcodec libx264 -preset fast -profile:v baseline -crf 28 -threads 0 -y "%~1_clean.avi"

  call :ColorText 0A "Extracting & Decoding audio.."
  ffmpeg.exe -i "%~1" -ac 2 -y "%~1_clean.wav"
   
  call :ColorText 0A "Getting max amplitude.."
  sox "%~1_clean.wav" -n stat -v 2> "%~1_apl.txt"
  
  Set /P APL_VALUE= < "%~1_apl.txt"
  
  call :ColorText 0A "Normalizing decoded audio with gain %APL_VALUE%.."
  sox --show-progress -v %APL_VALUE% "%~1_clean.wav" "%~1_norm.wav"

  call :ColorText 0A "Creating new video file, encoding audio.."
  ffmpeg.exe -i "%~1_clean.avi" -i "%~1_norm.wav" -vcodec copy -acodec libvo_aacenc -ab 128k -y "%~1"

  call :ColorText 0A "Cleaning.."
  del "%~1_clean.wav"
  del "%~1_clean.avi"
  del "%~1_norm.wav"
  del "%~1_apl.txt"

goto :eof

:: http://stackoverflow.com/questions/2586012/how-to-change-the-text-color-of-comments-line-in-a-batch-file

:ColorText Color String
::
:: Prints String in color specified by Color.
::
::   Color should be 2 hex digits
::     The 1st digit specifies the background
::     The 2nd digit specifies the foreground
::     See COLOR /? for more help
::
::   String is the text to print. All quotes will be stripped.
::     The string cannot contain any of the following: * ? < > | : \ /
::     Also, any trailing . or <space> will be stripped.
::
::   The string is printed to the screen without issuing a <newline>,
::   so multiple colors can appear on one line. To terminate the line
::   without printing anything, use the ECHO( command.
::
setlocal
set /p "=%time% " <nul
pushd %temp%
for /F "tokens=1 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  <nul set/p"=%%a" >"%~2"
)
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
echo(
popd
exit /b