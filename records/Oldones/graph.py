import pandas as pd
import matplotlib.pyplot as plt
import sys, getopt
import numpy as np
from math import sqrt
import glob


def my_alg(v, m):
    res = 0

    my_alg.v_prev.append(v)
    my_alg.v_prev.pop(0)

    my_alg.m_prev.append(m)
    my_alg.m_prev.pop(0)

    cnt         = len(my_alg.v_prev)
        
    left        = cnt//2

    c_left      = 0
    c_right     = 0

    #stage 1 Is it bigger than treshold?
    if (my_alg.v_prev[left] > v_tres and my_alg.m_prev[left] > m_tres):
        #print("MIDDLE", my_alg.prev[left], ",")

        #stage 2 Is it rise + fall
        for i in range (1, left+1):
            c_left  +=  my_alg.v_prev[i] - my_alg.v_prev[i-1]

        for i in range (left+1, cnt):
            c_right +=  my_alg.v_prev[i] - my_alg.v_prev[i-1]

        if (c_left > 0 and c_right < 0):
            res = 150

    return res


print("Args:", len(sys.argv))

if (len(sys.argv) == 2):
    filenames = [sys.argv[1]]
else:
    filenames = glob.glob('./*.txt')
    
plt.rcParams["figure.figsize"] = (30,15)

i = 0
f = 0
for filename in filenames:
    print("plot", filename)
    f = f + 1


    
    data = pd.read_csv(filename, header=None, sep=' ', skiprows=0, nrows=100, names=['adc'], usecols=[1])

    '''
    #Для улучшения производительности суммируем I и Q каналов а не магнитуды
    data['II'] = ((data['i0']**2 + data['q0']**2))**0.5 + ((data['i1']**2 + data['q1']**2))**0.5

    data['i0'] = None
    data['i1'] = None
    data['q0'] = None
    data['q1'] = None

    data['ewm'] = (data['II']).ewm(span=2, adjust=False).mean()

    data['ewm_hard'] = (data['ewm']).ewm(span=7, adjust=False).mean()  #Важно! Сглаживание уже сглаженных данных!
    data['dewm_hard'] = (data['ewm_hard']).diff().ewm(span=4, adjust=False).mean()

    trishold = data['ewm_hard'][0:580].max()*1.3
    
    d_trishold_max = data['dewm_hard'][0:580].max()*1.3
    d_trishold_min = data['dewm_hard'][0:580].min()*1.3

    data['trishold'] = trishold
    data['d_trishold_max'] = d_trishold_max
    data['d_trishold_min'] = d_trishold_min
    data['trigger']     = None
    data['trigger1']    = None
    data['trigger2']    = None

    i = 0
    cnt = 0 


    data['adaptive_trishold'] = data['ewm_hard'].ewm(span=400, adjust=False).mean()

    for i in range(1, data['dewm_hard'].count()):
        
        if (data['ewm_hard'][i] > trishold):
            data['trigger'][i]   = -20
            data['trigger'][i-1] = -20
            data['trigger'][i+1] = None

            if (data['ewm_hard'][i] > data['adaptive_trishold'][i]):
                data['trigger1'][i]     = -40
                data['trigger1'][i-1]   = -40
                data['trigger1'][i+1]   = None

                if (data['dewm_hard'][i-1] >= 0 and data['dewm_hard'][i] <= 0):
                    data['trigger2'][i]     = 60
                    data['trigger2'][i-1]   = -60
                    data['trigger2'][i+1]   = None
                    cnt = cnt + 1
                else:
                    data['trigger2'][i] = None
            else:
                data['trigger1'][i] = None
        else:
            data['trigger'][i] = None
    

    

        #На пике может быть зазубринка с одной из его сторон. Это может быть или шум или от смыкание второго контакта
        #Будем считать, что воторой пик - это результат смыкания второго контакта, если он образован фронтом минимум 2 точек, идущих наверх

    print ("\n----------------------------------------------\n")
    print ("max d=", data['dewm_hard'].max())
    print ("min d=", data['dewm_hard'].min())

    data['0'] = 0
    #data['m'] = None
    data['ema'] = None
    data['ewm'] = None
    data['II'] = None

    print("\ntrishold", trishold)
    print("d_trishold_max=", d_trishold_max)
    print("d_trishold_min=", d_trishold_min)
    print("\nFOUND", cnt)
    '''

    # Create a line plot
    plot = data.plot(kind='line', title=filename)
    #plot.set_ylim(-40,230)
    plot.set_xlim(0, 100)
    
    out_file = filename.replace(".txt", ".png")
    plt.savefig(out_file, dpi=100)
    #plt.show(block=False)
#plt.show()
print(filenames)
