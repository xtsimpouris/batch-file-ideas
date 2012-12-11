@echo off

echo Script by http://1024.gr

pushd %~dp0
 
echo Extracting/Converting video..
ffmpeg -i %1 -map 0:0 -vcodec libx264 -preset fast -profile:v baseline -crf 28 -threads 0 -y %1_clean.avi > nul

echo Extracting/Decoding audio..
ffmpeg.exe -i %1 -ac 2 -y %1_clean.wav > nul
 
echo Getting max amplitude..
sox %1_clean.wav -n stat -v 2> %1_apl.txt > nul
Set /P apl_value= < %1_apl.txt
 
echo Normalizing decoded audio.. gain: %apl_value%
sox --show-progress -v %apl_value% %1_clean.wav %1_norm.wav > nul

rundll32 user32.dll,MessageBeep -1
echo Creating new video file, encoding audio..
ffmpeg.exe -i %1_clean.avi -i %1_norm.wav -vcodec copy -acodec libvo_aacenc -ab 128k -y %1 > nul

:clear
echo Cleaning..
del %1_clean.wav
del %1_clean.avi
del %1_norm.wav
del %1_apl.txt

popd
