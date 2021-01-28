@ECHO OFF
echo.
echo **************************************************
echo *** Running: %~n0%~x0
echo *** Parameters: %*
echo.

PUSHD %cd%
CD %~dp0..
SET BASEDIR=%cd%

echo.
echo *** Run the Moodle CLI script: admin/cli/cron.php
echo.
call %BASEDIR%\bin\moodle-docker-compose exec webserver php admin/cli/cron.php
echo.