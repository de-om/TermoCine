import os
import shutil

# Lista de archivos en Source
pathSource  = r'D:\TFGdev\Source'
list_of_files = []
lof_names = []

for root, dirs, files in os.walk(pathSource):
	for file in files:
		list_of_files.append(os.path.join(root,file))
		lof_names.append(file)
# for name in list_of_files:
#     print(name)

# Para cada archivos:
# 1. Mover a D:\TFGdev\WIP 
# 2. Correr FFMPEG
pathWIP     = r'D:/TFGdev/WIP/'
pathFFMPEG  = r'D:\TFGdev\programs\ffmpeg-2021-03-24-git-a77beea6c8-full_build\bin\ffmpeg.exe'
for path in list_of_files:
    shutil.move(path,pathWIP)

# current_dir = r"D:\TFGdev\programs\ffmpeg-2021-03-24-git-a77beea6c8-full_build\bin\ffmpeg.exe"
# subprocess.Popen(os.path.join(current_dir,"file.exe"))