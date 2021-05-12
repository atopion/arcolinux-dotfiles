#!/usr/bin/env python

import os
from os.path import join, isdir, isfile
import shutil
import toml
import sys

from functools import reduce

HOME = "/home/atopi/themes/TEST"  #  os.getenv("HOME")
FOLDER_THEMES = "/home/atopi/themes/"


def get_variable(key, variables):
    return reduce(lambda x,y : x.get(y, {}), key.split("."), variables)


def list_themes():
    files = []
    for f in os.listdir(FOLDER_THEMES):
        if isdir(join(FOLDER_THEMES, f)) and isfile(join(FOLDER_THEMES, f, "variables.toml")):
            files.append(f)

    return files


def create_backup(theme):
    # Create backup folder
    backup_folder = join(FOLDER_THEMES, ".backup")
    shutil.rmtree(backup_folder)
    os.mkdir(backup_folder)

    for root, dirs, files in os.walk(join(FOLDER_THEMES, theme, "home")):
        for file in files:
            if file.endswith(".base"):
                file = file[0:-5]

            new_path  = root.replace(join(FOLDER_THEMES, theme, "home"), join(FOLDER_THEMES, ".backup", "home"))
            orig_path = join(root.replace(join(FOLDER_THEMES, theme, "home"), HOME), file)

            if not os.path.exists(new_path):
                os.makedirs(new_path)

            shutil.copyfile(orig_path, join(new_path, file))


def restore_backup():
    backup_folder = join(FOLDER_THEMES, ".backup")

    for root, dirs, files in os.walk(join(FOLDER_THEMES, ".backup", "home")):
        for file in files:
            
            new_path  = root.replace(join(FOLDER_THEMES, ".backup", "home"), HOME)
            orig_path = join(root, file) 
            
            if not os.path.exists(new_path):
                os.makedirs(new_path)

            shutil.copyfile(orig_path, join(new_path, file))


def switch_theme(theme):
    theme_folder = join(FOLDER_THEMES, theme)

    if not isfile(join(theme_folder, "variables.toml")):
        print("Variable-file not found for theme:", theme)

    variables = toml.load(join(theme_folder, "variables.toml"))
    
    for root, dirs, files in os.walk(join(FOLDER_THEMES, theme, "home")):
        for file in files:
            
            new_path  = root.replace(join(FOLDER_THEMES, theme, "home"), HOME)
            orig_path = join(root, file)

            if not os.path.exists(new_path):
                os.makedirs(new_path)

            if not file.endswith(".base"):
                shutil.copyfile(orig_path, join(new_path, file))
                continue
    
            file = file[0:-5]        

            if os.path.exists(join(new_path, file)):
                os.remove(join(new_path, file))

            old_file = open(orig_path, "r")
            new_file = open(join(new_path, file), "w")

            for line in old_file:

                i1 = line.find("${")
                if i1 >= 0:
                    i2 = line.find("}", i1)
                    if i2 < 1:
                        new_file.write(line)
                        continue
                    
                    #print("File:", root, "  Key:", line[i1+2:i2])
                    variable = get_variable(line[i1+2:i2], variables)
                    if variable == {}:
                        raise Exception("Cannot find key: " + line[i1+2:i2] + " (was requested in file: " + orig_path + ").\nAll changes were restored")

                    new_file.write(line[0:i1] + str(variable) + line[i2+1:])
                else:
                    new_file.write(line)

            new_file.close()
            old_file.close()



if __name__ == "__main__":
    themes = list_themes()

    if sys.argv[1] == "list":
        for t in themes:
            print(t)
        quit() 

    if sys.argv[1] == "switch":
        if sys.argv[2] in themes:
            #create_backup(sys.argv[2])
            try:
                switch_theme(sys.argv[2])
                print("Switch to theme:", sys.argv[2])
            except Exception as err:
                #restore_backup()
                print(err)

        else:
            print("Unknown theme:", sys.argv[2])

    else:
        print("Unknown command:", sys.argv[2])


