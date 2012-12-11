@echo off
echo Script by http://1024.gr

pushd %~dp0

del %1\log.txt > nul
echo %time% Starting batch process > %1\log.txt

for %%x in (%1\*.avi) do (
  echo Proccessing file %%x...
  echo %time% Proccessing file %%x... >> %1\log.txt
  
  echo %time% Extracting/Converting video..
  echo %time% Extracting/Converting video.. >> %1\log.txt
  ffmpeg -loglevel panic -i "%%x" -map 0:0 -vcodec libx264 -preset fast -profile:v baseline -crf 28 -threads 0 -y "%%x_clean.avi" >> %1\log.txt

  echo %time% Extracting/Decoding audio..
  echo %time% Extracting/Decoding audio.. >> %1\log.txt
  ffmpeg.exe -loglevel panic -i "%%x" -ac 2 -y "%%x_clean.wav" >> %1\log.txt
   
  echo %time% Getting max amplitude..
  echo %time% Getting max amplitude.. >> %1\log.txt
  sox "%%x_clean.wav" -n stat -v 2> "%%x_apl.txt"
  Set /P apl_value= < "%%x_apl.txt"
   
  echo %time% Normalizing decoded audio.. gain: %apl_value%
  echo %time% Normalizing decoded audio.. gain: %apl_value% >> %1\log.txt
  sox --show-progress -v %apl_value% "%%x_clean.wav" "%%x_norm.wav" >> %1\log.txt

  echo %time% Creating new video file, encoding audio..
  echo %time% Creating new video file, encoding audio.. >> %1\log.txt
  ffmpeg.exe -loglevel panic -i "%%x_clean.avi" -i "%%x_norm.wav" -vcodec copy -acodec libvo_aacenc -ab 128k -y "%%x" >> %1\log.txt

  :clear
  echo %time% Cleaning..
  del "%%x_clean.wav"
  del "%%x_clean.avi"
  del "%%x_norm.wav"
  del "%%x_apl.txt"
)

popd
