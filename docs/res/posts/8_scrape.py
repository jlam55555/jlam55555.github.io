import matplotlib.pyplot as plt
import numpy as np
from datetime import date
from bs4 import BeautifulSoup
import requests
import sys

if len(sys.argv) < 2:
    print('Usage: python3 scrape.py [username]')
    
# max_races should be > total number of races
username = sys.argv[1]
max_races = 10000

# scrape from typeracerdata 
url = f'http://typeracerdata.com/profile?username={username}&last={max_races}'
page = requests.get(url)

soup = BeautifulSoup(page.content, 'html.parser')
data = np.array(list(map(lambda elem: float(elem.getText()), soup\
        .find_all('table', class_='profile')[2]\
        .select('td:nth-child(3)'))))

# reverse data
data = data[::-1]

# calculate average of N
averageofs = [10, 100, 1000]
def aveof(n):
    x = np.zeros(shape=(len(data)-n+1,))
    t = np.arange(n/2, n/2+len(data)-n+1)
    # set the zeroth element
    x[0] = np.sum(data[:n])
    # set the rest
    for i in range(1, len(data)-n+1):
        x[i] = x[i-1] + data[i+n-1] - data[i-1]
    x /= n
    return t, x

# calculate maximums
rolling_max = np.zeros_like(data)
curr_max = -1
for i, val in enumerate(data):
    if val > curr_max:
        curr_max = val
    rolling_max[i] = curr_max

# plot and save figure
plt.figure(figsize=[20, 10])
plt.plot(data)
for n in averageofs:
    plt.plot(*aveof(n))
plt.plot(rolling_max)
plt.grid('on')
plt.title(f'{username} Typeracer scores as of {date.today().strftime("%m/%d/%Y")}')
plt.xlabel('Race number')
plt.ylabel('Speed (wpm)')
plt.legend(['Raw'] + list(map(lambda x: f'Ao{x}', averageofs)) + ['Record'])
plt.tight_layout()
plt.xlim([0, len(data)])
plt.savefig(f'{username}{date.today().strftime("%d%m%Y")}.png')
