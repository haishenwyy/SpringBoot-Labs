@echo off
echo Starting Alertmanager...
echo.
echo Please make sure you have downloaded Alertmanager to E:\tools\alertmanager
echo And configured alertmanager.yml with your SMTP settings!
echo.
echo Alertmanager will be available at: http://localhost:9093
echo.
echo Press Ctrl+C to stop Alertmanager
echo.

cd /d E:\tools\alertmanager\alertmanager-0.31.1.windows-amd64
alertmanager.exe --config.file="E:\IdeaProjects\SpringBoot-Labs\labx-04-spring-cloud-alibaba-sentinel\labx-04-sca-sentinel-nacos-provider\alertmanager.yml"

pause
