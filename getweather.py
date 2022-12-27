#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime
import time
import requests
from bs4 import BeautifulSoup


def getNaverWeather():
    err = None
    try:
        source = requests.get('https://www.naver.com/')
        soup = BeautifulSoup(source.content, "html.parser")

        group_weather = soup.find('div', {'class': 'group_weather'})
        # print(group_weather)
        current_box = group_weather.find('div', {'class': 'current_box'})
        currentTemperature = current_box.find(
            'strong', {'class': 'current'}).text
        currentSky = current_box.find('strong', {'class': 'state'}).text
        geoLocation = group_weather.find('span', {'class': 'location'}).text

        # <ul class="list_air">
        # <li class="air_item">미세<strong class="state state_good">좋음</strong></li>
        # <li class="air_item">초미세<strong class="state state_normal">보통</strong></li>
        # </ul>
        listair = group_weather.find('ul', {'class': 'list_air'})
        airlist = listair.find_all('li', {'class': 'air_item'})
        dust1, dust2 = airlist[0].text, airlist[1].text

        return currentTemperature, currentSky, geoLocation, dust1, dust2, err
    except Exception as e:
        print(e)
        return "fail to get weather", repr(e),  "",   "", "", e


def getNaverWeatherRetry():
    tryCount = 10
    sleepDelaySec = 1.0
    rtn = getNaverWeather()
    while rtn[-1] != None:
        time.sleep(sleepDelaySec)
        rtn = getNaverWeather()
        tryCount -= 1
        if tryCount <= 0:
            break

    return rtn[:-1]


rtn = getNaverWeatherRetry()
updateDateTime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

with open('weather.txt', 'wt', encoding="utf-8") as f:
    for d in rtn:
        f.write(d)
        f.write("\n")
    f.write(updateDateTime)
