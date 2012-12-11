echo off
echo Script by http://1024.gr

for %%x in (%1\*.avi) do (
  echo "Proccessing file %%x..."
  normalize-for-tablet.bat "%%x"
)
for %%x in (%1\*.mp4) do (
  echo "Proccessing file %%x..."
  normalize-for-tablet.bat "%%x"
)

pause

