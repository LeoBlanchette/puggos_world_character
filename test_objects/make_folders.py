import os

folder_1 = "body_objects"
folder_2 = "body_textures"

for x in range(34):
    os.mkdir(folder_1+"/slot_%i"%(x+1))
    os.mkdir(folder_2+"/slot_%i"%(x+1))
