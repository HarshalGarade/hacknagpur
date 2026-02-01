@echo off
REM Start KrishiSetu Backend - All 4 Categories Working (FIXED VERSION)
echo.
echo ====================================================================
echo KRISHISETU BACKEND - STARTING (ALL 4 CATEGORIES)
echo ====================================================================
echo.
echo ✓ Backend: backend_working.py
echo ✓ Port: 5000
echo ✓ Categories: watering, fertilizer, growth, storage
echo ✓ Crops: 30 (all with complete advisories)
echo.
cd /d "%~dp0"
python backend_working.py
pause

echo This window will stay open - the backend is running
echo.
echo Backend will be available at:
echo - Local:  http://localhost:5000
echo - Network: http://192.168.1.37:5000
echo.
echo To stop the backend, close this window or press Ctrl+C
echo.
echo ======================================================================
echo.

python advisory_backend.py

pause
