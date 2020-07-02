mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

cmake .. -G "MinGW Makefiles"
if errorlevel 1 exit 1
make
if errorlevel 1 exit 1