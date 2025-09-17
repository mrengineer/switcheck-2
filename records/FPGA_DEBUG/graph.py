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
    filenames = glob.glob('./*.csv')
    
plt.rcParams["figure.figsize"] = (30,15)

i = 0
f = 0
for filename in filenames:
    print("plot", filename)
    f = f + 1


    
    data = pd.read_csv(
        filename,
        sep=";", 
        nrows=100,
        usecols=["Ix", "Type", "B (signed)"]
    )


    '''
    #Для улучшения производительности суммируем I и Q каналов а не магнитуды
    data['II'] = ((data['i0']**2 + data['q0']**2))**0.5 + ((data['i1']**2 + data['q1']**2))**0.5

    data['i0'] = None


            data['trigger'][i] = None
    
    '''

    # Create a line plot
    plot = data.plot(kind='line', title=filename)
    #plot.set_ylim(-40,230)
    plot.set_xlim(0, 100)
    
    out_file = filename.replace(".csv", ".png")
    plt.savefig(out_file, dpi=100)
    #plt.show(block=False)
#plt.show()
print(filenames)
