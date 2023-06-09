# Tkinters file dialog window to get a file name with full path, you can also use this to get filenames for a console program askopenfilename() gives one selected filename
# with Python25 use ...
# import Tkinter as tk
# from tkFileDialog import askopenfilename
# with Python30 use ...
import tkinter as tk
from tkinter.filedialog import askopenfilename

root = tk.Tk()
# show askopenfilename dialog without the Tkinter window
root.withdraw()
# default is all file types
file_name = askopenfilename()
print(file_name)

# Change dots for commas:
with open(file_name, "r") as data:
    plaintext = data.read()
    plaintext = plaintext.replace(".", ",")
    data.close()

f = open(file_name + ".PaC", "w")
f.write(plaintext)
f.close()
