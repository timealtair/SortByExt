import os
import sys
import shutil


def get_extention(file_path, no_ext):
    ext = os.path.splitext(file_path)[1][1:]
    return ext if ext else no_ext


def move_with_backup(src, dst):
    try:
        base, ext = os.path.splitext(dst)

        count = 1
        while os.path.exists(dst):
            dst = f"{base}({count}){ext}"
            count += 1

        shutil.move(src, dst)

    except Exception as e:
        print(f"Skipping due to error: {e}")


def move_file_to_ext_dir(file_path, base_dir, func, no_ext):
    ext = get_extention(file_path, no_ext)
    dir_name = os.path.join(base_dir, func(ext))
    if not os.path.isdir(dir_name):
        os.mkdir(dir_name)

    dest_name = os.path.join(dir_name, os.path.split(file_path)[-1])

    try:
        move_with_backup(file_path, dest_name)
    except Exception as e:
        print(e)


def get_file_paths_from_dir(directory):
    base_files = []

    for item in os.listdir(directory):
        full_path = os.path.join(directory, item)
        if os.path.isfile(full_path):
            base_files.append(full_path)

    return base_files


def sort_files_by_ext(base_dir, func, no_ext):
    for file_path in get_file_paths_from_dir(base_dir):
        move_file_to_ext_dir(file_path, base_dir, func, no_ext)


if __name__ == '__main__':
    base_dir = sys.argv[1] if len(sys.argv) > 1 else '.'
    sort_files_by_ext(base_dir, str.capitalize, ' ')
