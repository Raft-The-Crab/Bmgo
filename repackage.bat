@echo off
setlocal enabledelayedexpansion

echo.
echo ==============================================================
echo    BLOCKMAN GO - COMMUNITY EDITION REPACKAGING
echo ==============================================================
echo.

cd /D "%~dp0"

REM Set apktool path from Downloads
set APKTOOL=%USERPROFILE%\Downloads\apktool.bat

REM Check if apktool exists
if not exist "%APKTOOL%" (
    echo ERROR: apktool not found at %APKTOOL%
    echo Please ensure apktool is in your Downloads folder
    echo.
    pause
    exit /b 1
)

REM Step 1: Build
echo [1/5] Building APK from modified sources...
echo Command: "%APKTOOL%" build -o community_edition_unsigned.apk .
call "%APKTOOL%" build -o community_edition_unsigned.apk .
if errorlevel 1 (
    echo ERROR during build
    pause
    exit /b 1
)
echo ✓ Build successful
echo.

REM Step 2: Generate keystore
echo [2/5] Generating test signing certificate...
if exist "community.jks" (
    echo keystore community.jks already exists, skipping keytool
) else (
    keytool -genkey -v -keystore community.jks ^
      -keyalg RSA -keysize 2048 -validity 9999 ^
      -alias community -storepass blockman123 -keypass blockman123 ^
      -noprompt ^
      -dname "CN=BlockmanGO,O=Community,C=US"
    if errorlevel 1 (
        echo ERROR during keystore generation
        pause
        exit /b 1
    )
)
echo ✓ Certificate ready
echo.

REM Prepare build-tools paths
set BUILD_TOOLS=%ANDROID_SDK_ROOT%\build-tools\35.0.0
if not exist "%BUILD_TOOLS%" set BUILD_TOOLS=%ANDROID_HOME%\build-tools\35.0.0
if not exist "%BUILD_TOOLS%" set BUILD_TOOLS=C:\Android\Sdk\build-tools\35.0.0

REM Step 3: Sign (v1) and prepare for v2/v3 signing
echo [3/5] Signing APK (v1) with test certificate...
echo Command: jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 ^
  -keystore community.jks -storepass blockman123 community_edition_unsigned.apk community
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 ^
  -keystore community.jks ^
  -storepass blockman123 ^
  community_edition_unsigned.apk community
if errorlevel 1 (
    echo ERROR during signing (v1)
    pause
    exit /b 1
)
echo ✓ v1 Signing successful

echo [4/5] ZIP aligning and adding v2/v3 signatures...
if not exist "%BUILD_TOOLS%\zipalign.exe" (
    echo WARNING: zipalign not found at %BUILD_TOOLS%\zipalign.exe — trying system PATH
    set ZIPALIGN=zipalign
) else (
    set ZIPALIGN=%BUILD_TOOLS%\zipalign.exe
)
%ZIPALIGN% -v 4 community_edition_unsigned.apk community_edition_aligned.apk
if errorlevel 1 (
    echo ERROR during zipalign
    pause
    exit /b 1
)
echo ✓ ZIP alignment successful

REM Use apksigner to add v2/v3 signatures
if exist "%BUILD_TOOLS%\apksigner.bat" (
    echo Using apksigner at %BUILD_TOOLS%\apksigner.bat
    call "%BUILD_TOOLS%\apksigner.bat" sign --ks community.jks --ks-key-alias community --ks-pass pass:blockman123 --key-pass pass:blockman123 community_edition_aligned.apk
) else (
    echo ERROR: apksigner not found at %BUILD_TOOLS%\apksigner.bat
    pause
    exit /b 1
)
if errorlevel 1 (
    echo ERROR during apksigner
    pause
    exit /b 1
)

REM Finalize output filename
move /Y community_edition_aligned.apk community_edition.apk

echo ✓ APK signed (v1,v2/v3) and aligned
echo.

REM Step 5: Verify
echo [5/5] Verifying APK signature and structure...
echo.
echo --- Signature Verification ---
jarsigner -verify -verbose community_edition.apk
if errorlevel 1 (
    echo ERROR: Signature verification failed
    pause
    exit /b 1
)
echo.
echo --- APK Structure Check ---
echo.
echo File size:
dir /b community_edition.apk | for /f "tokens=1" %%a in ('findstr .*') do (
    for /r . %%b in (community_edition.apk) do (
        echo %%~zb bytes - %%~tb
    )
)
echo.

echo ==============================================================
echo    REPACKAGING COMPLETE!
echo ==============================================================
echo.
echo Output: community_edition.apk
echo Size: !size! bytes
echo Ready for installation on Android device
echo.
echo Next steps:
echo   1. Connect Android device with USB debugging enabled
echo   2. Run: adb install -r community_edition.apk
echo   3. Launch Blockman GO and verify no "tampered" errors
echo   4. Check Gcubes balance (should be 1,000,000)
echo.
pause
