@echo off
echo Starting Grafana 4.6.5...
echo.
echo Grafana will be available at: http://localhost:3000
echo Login: admin / admin
echo.
echo Press Ctrl+C to stop Grafana
echo.

cd /d E:\tools\grafana\grafana-4.6.5.windows-x64\grafana-4.6.5\bin
grafana-server.exe

pause
