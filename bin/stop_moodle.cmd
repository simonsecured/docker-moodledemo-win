@ECHO OFF
echo.
echo **************************************************
echo *** Running: %~n0%~x0
echo.

PUSHD %cd%
CD %~dp0..
SET BASEDIR=%cd%
POPD
SET VOLUMEDIR=%BASEDIR%\volumes

echo.
echo *** Bring down the Docker containers
echo.
call %BASEDIR%\bin\moodle-docker-compose down
echo.
