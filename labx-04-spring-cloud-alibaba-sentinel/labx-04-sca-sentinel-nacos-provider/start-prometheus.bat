@echo off
echo Starting Prometheus...
echo.
echo Please make sure you have downloaded Prometheus to E:\tools\prometheus\prometheus-2.37.9.windows-amd64
echo Or edit this file to change the path
echo.
echo Prometheus will be available at: http://localhost:9090
echo.
echo Press Ctrl+C to stop Prometheus
echo.

cd /d E:\tools\prometheus\prometheus-2.37.9.windows-amd64
prometheus.exe --config.file="E:\IdeaProjects\SpringBoot-Labs\labx-04-spring-cloud-alibaba-sentinel\labx-04-sca-sentinel-nacos-provider\prometheus.yml"

pause
