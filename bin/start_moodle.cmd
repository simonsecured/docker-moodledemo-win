@ECHO OFF
SET MOODLE_VERSION=MOODLE_39_STABLE
:: the first parameter is an optional flag
IF "%1"=="setup" ( SET "INSTALLSTEP=INSTALLMOODLE" & SET "NGROKSTEP=NGROKSKIP") ELSE ( SET "INSTALLSTEP=FINISH" & SET "NGROKSTEP=NGROKSKIP")
IF "%1"=="ngrok" ( SET "INSTALLSTEP=FINISH" & SET "NGROKSTEP=NGROKENABLE")

echo.
echo **************************************************
echo *** Running: %~n0%~x0
echo *** Parameters: %*
echo.
echo *** Moodle Version: %MOODLE_VERSION%
echo.

PUSHD %cd%
CD %~dp0..
SET BASEDIR=%cd%
POPD

SET VOLUMEDIR=%BASEDIR%\volumes
SET MOODLE_LOCAL_HOST=http://127.0.0.1:8000

SET NUL=NUL
IF "%OS%"=="Windows_NT" SET NUL=

echo.
echo *** Create volume folders if they dont exist
echo.
IF not exist %VOLUMEDIR% (mkdir %VOLUMEDIR%)
IF not exist %VOLUMEDIR%\moodle (mkdir %VOLUMEDIR%\moodle)
IF not exist %VOLUMEDIR%\moodledata (mkdir %VOLUMEDIR%\moodledata)
IF not exist %VOLUMEDIR%\mysql (mkdir %VOLUMEDIR%\mysql)

:MOODLEDATAEXISTS
IF EXIST %VOLUMEDIR%\moodle\%MOODLE_VERSION%\version.php GOTO FETCHMOODLE

:CLONE
echo.
echo *** Cloning Moodle branch: %MOODLE_VERSION%
echo.
git clone --branch %MOODLE_VERSION% --depth 1 --single-branch git://github.com/moodle/moodle %VOLUMEDIR%\moodle\%MOODLE_VERSION%
echo.
GOTO FINISH

:FETCHMOODLE
PUSHD %cd%
CD %VOLUMEDIR%\moodle\%MOODLE_VERSION%
echo.
echo *** Reset from branch %MOODLE_VERSION%
echo.
git reset HEAD --hard
echo.
echo *** Show Git Status
echo.
git status
echo.
POPD

goto %NGROKSTEP%

:NGROKENABLE
IF not exist ngrok.exe ( goto MISSINGNGROK )
echo.
echo *** Launching NGROK
START ngrok http %MOODLE_LOCAL_HOST%
echo.
echo *** Waiting for NGROK to be ready
TIMEOUT /T 10 /NOBREAK
echo.
echo *** Retrieving NGROK HTTPS hostname
FOR /F "usebackq tokens=*" %%i IN (`call bin\get_ngrok_host.cmd`) DO SET MOODLE_DOCKER_HOST=%%i
echo %MOODLE_DOCKER_HOST%
goto NGROKCONTINUE

:NGROKSKIP
SET MOODLE_DOCKER_HOST=%MOODLE_LOCAL_HOST%

goto NGROKCONTINUE

:NGROKCONTINUE
echo.
echo *** Ensure customized config.php for the Docker containers is in place
echo.
copy config.docker-template.php %VOLUMEDIR%\moodle\%MOODLE_VERSION%\config.php
echo.

echo.
echo *** Bring up the Docker containers
echo.
call %BASEDIR%\bin\moodle-docker-compose up -d
echo.

goto %INSTALLSTEP%

:INSTALLMOODLE
echo.
echo *** Run the Moodle CLI script: admin/cli/install_database.php
echo.
call %BASEDIR%\bin\moodle-docker-compose exec webserver php admin/cli/install_database.php --agree-license --fullname="Docker moodle" --shortname="docker_moodle" --adminpass="test" --adminemail="admin@example.com"
echo.
goto FINISH

:FINISH
echo.
echo *** Moodle is running please. Browse to - %MOODLE_DOCKER_HOST%
echo *** Moodle Admin Username: admin
echo *** Moodle Admin password: test
echo.
goto END

:MISSINGNGROK
echo.
echo *** ERROR - Missing Files for running NGROK ***
echo.
echo *** NGROK Executable is not in %BASEDIR%
echo *** Download from https://ngrok.com/download and copy ngrok.exe to %BASEDIR%
echo.
goto END

:END
