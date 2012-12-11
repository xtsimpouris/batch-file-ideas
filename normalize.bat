echo off

echo Script by http://1024.gr

cd /d %~dp0
 
echo Extracting audio..
ffmpeg.exe -i %1 -ac 2 -y %1_clean.wav
 
echo Getting max amplitude..
sox %1_clean.wav -n stat -v 2> %1_apl.txt
Set /P apl_value= < %1_apl.txt
 
echo Extracting video..
ffmpeg.exe -i %1 -map 0:0 -vcodec copy -y %1_clean.avi
 
echo Normalizing audio.. gain: %apl_value%
sox --show-progress -v %apl_value% %1_clean.wav %1_norm.wav

rundll32 user32.dll,MessageBeep -1
echo Creating new video file..
ffmpeg.exe -i %1_clean.avi -i %1_norm.wav -vcodec copy %1
 
:clear
echo Cleaning..
del %1_clean.wav
del %1_clean.avi
del %1_norm.wav
del %1_apl.txt
rundll32 user32.dll,MessageBeep -1
pause