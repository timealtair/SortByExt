import winreg as reg
import os
import ctypes
import sys
import shutil


def is_admin():
    return ctypes.windll.shell32.IsUserAnAdmin()


def run_as_admin():
    ctypes.windll.shell32.ShellExecuteW(None, "runas",
                                        sys.executable,
                                        " ".join(sys.argv),
                                        None, 1)


def add_context_menu(app_name, app_path, cmd, registry_path, icon_path=None):
    registry_path = registry_path.format(app_name)

    try:
        with reg.CreateKey(reg.HKEY_CLASSES_ROOT, registry_path) as key:
            reg.SetValueEx(key, "", 0, reg.REG_SZ, app_name)

            with reg.CreateKey(key, "command") as command_key:
                command = cmd.format(app_path)
                reg.SetValueEx(command_key, "", 0, reg.REG_SZ, command)

            if icon_path:
                reg.SetValueEx(key, "Icon", 0, reg.REG_SZ, icon_path)

        print(f'Successfully added "{app_name}" to the context menu.')
    except Exception as e:
        print(f'Failed to add context menu entry: {e}')


if __name__ == "__main__":
    if not is_admin():
        print("This script requires administrator privileges.")
        run_as_admin()
        sys.exit()

    app_name = "SortByExt"
    dir_name = r"C:\SortByExt"
    file_path = r"SortByExt.exe"
    reg_back_path = r'Directory\Background\shell\{}'
    back_cmd = r'"{}"'
    dir_cmd = r'"{}" "%1"'
    reg_dir_path = r'Directory\shell\{}'

    if not os.path.isdir(dir_name):
        os.mkdir(dir_name)

    source_file_path = os.path.abspath(file_path)
    destination_file_path = os.path.join(dir_name, os.path.basename(file_path))

    shutil.copyfile(source_file_path, destination_file_path)

    app_path = os.path.abspath(destination_file_path)
    icon_path = app_path
    if not os.path.isfile(app_path.replace('"', '')):
        print(f"The specified app path does not exist: {app_path}")
    elif icon_path and not os.path.isfile(icon_path.replace('"', '')):
        print(f"The specified icon path does not exist: {icon_path}")
    else:
        add_context_menu(app_name, app_path, back_cmd,
                         reg_back_path, icon_path)
        add_context_menu(app_name, app_path, dir_cmd,
                         reg_dir_path, icon_path)
