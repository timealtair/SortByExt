@echo off

:: Make temp dir

mkdir temp

:: Change working dir to temp

cd temp

:: Download Python 3.13 embedded zip
curl -o "python-3.13.0-embed-amd64.zip" "https://www.python.org/ftp/python/3.13.0/python-3.13.0-embed-amd64.zip"

:: Unzip Python embedded distribution
PowerShell -Command "Expand-Archive -Path 'python-3.13.0-embed-amd64.zip' -DestinationPath 'python-3.13.0-embed-amd64'"

:: Create the ._pth file
(
    echo python313.zip
    echo .
    echo import site
) > python-3.13.0-embed-amd64\python313._pth

:: Download get-pip.py to install pip
curl -o "python-3.13.0-embed-amd64\get-pip.py" "https://bootstrap.pypa.io/get-pip.py"

:: Install pip using the embedded Python
python-3.13.0-embed-amd64\python.exe python-3.13.0-embed-amd64\get-pip.py

:: Install PyInstaller using pip
python-3.13.0-embed-amd64\Scripts\pip.exe install -U pyinstaller

:: Create an executable for SortByExt.py
python-3.13.0-embed-amd64\Scripts\PyInstaller.exe --onefile --name SortByExt.exe --icon=../source/sort_by_ext.ico --noconsole ../source/sort_by_ext.py

:: Create an executable for AddToContextMenu.py
python-3.13.0-embed-amd64\Scripts\PyInstaller.exe --onefile --name AddToContextMenu.exe --icon=../source/sort_by_ext.ico --noconsole ../source/add_to_contex_menu.py

:: Move SortByExt.exe to base directory

Move dist\SortByExt.exe ..\SortByExt.exe

:: Move SortByExt.exe to base directory

Move dist\AddToContextMenu.exe ..\AddToContextMenu.exe

:: Done

echo Done, tempotary files located in "temp" dir, feel free to delete

pause