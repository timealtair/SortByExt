@echo off

:: Step 1: Download Python 3.13 embedded zip
curl -o "python-3.13.0-embed-amd64.zip" "https://www.python.org/ftp/python/3.13.0/python-3.13.0-embed-amd64.zip"

:: Step 2: Unzip Python embedded distribution
PowerShell -Command "Expand-Archive -Path 'python-3.13.0-embed-amd64.zip' -DestinationPath 'python-3.13.0-embed-amd64'"

:: Step 3: Delete the zip file
del "python-3.13.0-embed-amd64.zip"

:: Step 4: Create the ._pth file
(
    echo python313.zip
    echo .
    echo import site
) > python-3.13.0-embed-amd64/python313._pth

:: Step 5: Download get-pip.py to install pip
curl -o "python-3.13.0-embed-amd64\get-pip.py" "https://bootstrap.pypa.io/get-pip.py"

:: Step 6: Install pip using the embedded Python
python-3.13.0-embed-amd64\python.exe python-3.13.0-embed-amd64\get-pip.py

:: Step 7: Install PyInstaller using pip
python-3.13.0-embed-amd64\Scripts\pip.exe install -U pyinstaller

:: Step 8: Create an executable for SortByExt.py
python-3.13.0-embed-amd64\Scripts\PyInstaller.exe --onefile --name SortByExt.exe --icon=./source/sort_by_ext.ico --noconsole ./source/sort_by_ext.py

:: Step 9: Create an executable for AddToContextMenu.py
python-3.13.0-embed-amd64\Scripts\PyInstaller.exe --onefile --name AddToContextMenu.exe --icon=./source/sort_by_ext.ico --noconsole ./source/add_to_contex_menu.py

:: Step 10: Move SortByExt.exe to bas directory

Move dist\SortByExt.exe SortByExt.exe

:: Step 11: Move SortByExt.exe to bas directory

Move dist\AddToContextMenu.exe AddToContextMenu.exe

:: Step 12: Clean the mess

setlocal enabledelayedexpansion

:: Specify the files to keep
set keepFile1=SortByExt.exe
set keepFile2=AddToContextMenu.exe
set keepFile3=compile.cmd

:: Specify the directory to keep
set keepDir=source

:: Loop through all files in the current directory
for %%f in (*) do (
    if not "%%f"=="%keepFile1%" (
        if not "%%f"=="%keepFile2%" (
            if not "%%f"=="%keepFile3%" (
                echo Deleting file %%f
                if exist "%%f" (
                    del /q "%%f" 2>nul
                )
            )
        )
    )
)

:: Loop through all directories and delete them
for /d %%d in (*) do (
    if not "%%d"=="%keepDir%" (  :: Check only against the directory to keep
        echo Deleting directory %%d
        rd /s /q "%%d"
    )
)

echo "Done, click 'Enter' to exit."

pause