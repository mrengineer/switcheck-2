import os
import pandas as pd
import matplotlib.pyplot as plt
import sys, getopt
import numpy as np
from math import sqrt
import glob

# попытка импортировать scipy.find_peaks
try:
    from scipy.signal import find_peaks
    HAVE_SCIPY = True
except Exception:
    HAVE_SCIPY = False

def find_peaks_simple(x, distance=50, threshold=0):
    """
    Простой детектор пиков:
    - x: 1D numpy array или list
    - distance: минимальное расстояние между пиками (в сэмплах)
    - threshold: минимальная высота пика
    Возвращает numpy array индексов пиков.
    """
    x = np.asarray(x)
    N = len(x)
    peaks = []
    last_peak = -distance
    i = 1
    while i < N - 1:
        # локальный максимум
        if x[i] > x[i - 1] and x[i] >= x[i + 1] and x[i] > threshold and (i - last_peak) >= distance:
            # refine: найти настоящий максимум в небольшом окне вокруг i
            left = max(0, i - 2)
            right = min(N, i + 3)
            local_max = i
            for j in range(left, right):
                if x[j] > x[local_max]:
                    local_max = j
            if (local_max - last_peak) >= distance:
                peaks.append(local_max)
                last_peak = local_max
                i = local_max + 1
                continue
        i += 1
    return np.array(peaks, dtype=int)

# --- основной код ---
start = 0
end = 0

print("Args:", len(sys.argv), sys.argv)

if (len(sys.argv) >= 2):
    filenames = [sys.argv[1]]
else:
    filenames = glob.glob('./**/*.csv',  recursive=True)

if (len(sys.argv) >= 3):    
    start = int(sys.argv[2])
if (len(sys.argv) >= 4):    
    end = int(sys.argv[3])

plt.rcParams["figure.figsize"] = (45,15)

min_distance = 1     # под сигнал
rolling_window = 20  # запасной вариант

for filename in filenames:
    print("plot", filename)
    data = pd.read_csv(
        filename,
        sep="|",         
        usecols=["Type", "A", "B"]
    )

    data = data[["B", "A", "Type"]]

    bias = 150
    data["A"] = -1 * (data["A"] - bias)
    data["B"] = data["B"] - bias
    data["Type"] = data["Type"] * 100 - 500

    # сумма модулей
    data["abs_sum"] = data["A"].abs() + data["B"].abs()

    # порог по умолчанию (можно подбирать)
    threshold = np.mean(data["abs_sum"]) + 0.03 * np.std(data["abs_sum"])

    # поиск пиков: сначала scipy (если есть), иначе простой fallback
    #if HAVE_SCIPY:
        #peaks, props = find_peaks(data["abs_sum"].values, distance=min_distance, height=threshold)
    #else:
    peaks = find_peaks_simple(data["abs_sum"].values, distance=min_distance, threshold=threshold)

    # строим огибающую: интерполяция по пикам
    if len(peaks) >= 2:
        envelope = np.interp(np.arange(len(data)), peaks, data["abs_sum"].values[peaks])
    else:
        # мало пиков — fallback: скользящий максимум (не по пикам, но стабильно)
        envelope = data["abs_sum"].rolling(window=rolling_window, center=True, min_periods=1).max().values

    data["envelope"] = envelope
    data["envelope"] =  data["envelope"] + 10  # небольшой запас сверху

    #Немного улучшим вывод

    data["A"] = 0.2 * data["A"]
    data["B"] = 0.2 * data["B"]

    # рисуем
    fig, ax = plt.subplots(figsize=(45,15))
    data[["B","A","Type","abs_sum"]].plot(ax=ax)
    ax.plot(data["envelope"].values, linewidth=2)  # огибающая поверх
    ax.set_title(filename)
    ax.set_ylim(-2200, 7600)

    local_end = end if end != 0 else len(data) - 1
    ax.set_xlim(start, local_end)

    out_file = os.path.splitext(filename)[0] + ".png"
    plt.savefig(out_file, dpi=200)
    plt.close(fig)

print(filenames)
