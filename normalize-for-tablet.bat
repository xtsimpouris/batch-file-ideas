@echo off
echo Script by http://1024.gr

pushd %~dp0

for %%x in (%1\*.avi) do (
  echo Proccessing file %%x...
  
  echo %time% Extracting/Converting video..
  ffmpeg -loglevel panic -i "%%x" -map 0:0 -vcodec libx264 -preset fast -profile:v baseline -crf 28 -threads 0 -y "%%x_clean.avi" > nul

  echo %time% Extracting/Decoding audio..
  ffmpeg.exe -loglevel panic -i "%%x" -ac 2 -y "%%x_clean.wav" > nul
   
  echo %time% Getting max amplitude..
  sox "%%x_clean.wav" -n stat -v 2> "%%x_apl.txt" > nul
  Set /P apl_value= < "%%x_apl.txt"
   
  echo %time% Normalizing decoded audio.. gain: %apl_value%
  sox --show-progress -v %apl_value% "%%x_clean.wav" "%%x_norm.wav" > nul

  rundll32 user32.dll,MessageBeep -1
  echo %time% Creating new video file, encoding audio..
  ffmpeg.exe -loglevel panic -i "%%x_clean.avi" -i "%%x_norm.wav" -vcodec copy -acodec libvo_aacenc -ab 128k -y "%%x" > nul

  :clear
  echo %time% Cleaning..
  del %1_clean.wav
  del %1_clean.avi
  del %1_norm.wav
  del %1_apl.txt
)

popd
