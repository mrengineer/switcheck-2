import pandas as pd
import matplotlib.pyplot as plt
import sys, getopt
import numpy as np
from math import sqrt
import glob



print("Args:", len(sys.argv))

if (len(sys.argv) == 2):
    filenames = [sys.argv[1]]
else:
    filenames = glob.glob('./**/*.csv',  recursive=True)
    
plt.rcParams["figure.figsize"] = (30,15)

i = 0
f = 0
for filename in filenames:
    print("plot", filename)
    f = f + 1


    
    data = pd.read_csv(
        filename,
        sep="|",         
        usecols=["Type", "A", "B"]
    )

    # переставляем порядок колонок → сначала B, потом A
    data = data[["B", "A", "Type"]]

    # Create a line plot
    plot = data.plot(kind='line', title=filename)
    plot.set_ylim(-1500,1500)
    plot.set_xlim(0, len(data) - 1)
    
    out_file = filename.replace(".csv", ".png")
    plt.savefig(out_file, dpi=200)
    #plt.show(block=False)
#plt.show()
print(filenames)
