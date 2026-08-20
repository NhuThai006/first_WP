@echo off
setlocal

REM ====================================================
REM  Build & Deploy script cho Tomcat 9
REM  Cach dung: deploy.bat
REM ====================================================

REM --- Cau hinh duong dan ---
set JAVA_HOME=%USERPROFILE%\.jdks\openjdk-26.0.2.1
set TOMCAT_HOME=D:\Download\apache-tomcat-9.0.121\apache-tomcat-9.0.121
set APP_NAME=hello_world

set PROJECT_DIR=%~dp0
set SRC_DIR=%PROJECT_DIR%src
set WEB_DIR=%PROJECT_DIR%web
set BUILD_DIR=%PROJECT_DIR%build
set DEPLOY_DIR=%TOMCAT_HOME%\webapps\%APP_NAME%

echo.
echo ========================================
echo  Building %APP_NAME%...
echo ========================================
echo.

REM --- Xoa build cu ---
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%\WEB-INF\classes"

REM --- Compile Java ---
echo [1/3] Compiling Java files...
dir /s /b "%SRC_DIR%\*.java" > "%BUILD_DIR%\sources.txt"

"%JAVA_HOME%\bin\javac" -cp "%TOMCAT_HOME%\lib\servlet-api.jar" -d "%BUILD_DIR%\WEB-INF\classes" @"%BUILD_DIR%\sources.txt"

if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Compile that bai! Kiem tra lai code.
    del "%BUILD_DIR%\sources.txt"
    pause
    exit /b 1
)
del "%BUILD_DIR%\sources.txt"
echo    OK!

REM --- Copy web resources ---
echo [2/3] Copying web resources...
xcopy "%WEB_DIR%\*" "%BUILD_DIR%\" /s /e /y /q >nul
echo    OK!

REM --- Deploy to Tomcat ---
echo [3/3] Deploying to Tomcat...
if exist "%DEPLOY_DIR%" rmdir /s /q "%DEPLOY_DIR%"
xcopy "%BUILD_DIR%\*" "%DEPLOY_DIR%\" /s /e /y /q >nul
echo    OK!

echo.
echo ========================================
echo  Deploy thanh cong!
echo  Truy cap: http://localhost:8080/%APP_NAME%/
echo ========================================
echo.
pause
