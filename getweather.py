#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import datetime
import requests
from bs4 import BeautifulSoup


def getNaverWeather():
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

        updateDateTime = datetime.datetime.now()
        return currentTemperature, currentSky, geoLocation, dust1, dust2, updateDateTime
    except:
        # return err info and retry after 1 min
        return "no internet connection retry later", "",  "",   "", "", datetime.datetime.now()


rtn = getNaverWeather()
# rtn = "internet", "connection",  "no",   "retry", "in 1 min", datetime.datetime.now() - \
#     datetime.timedelta(minutes=9)

with open('weather.txt', 'wt', encoding="utf-8") as f:
    for d in rtn[:-1]:
        f.write(d)
        f.write("\n")
    f.write(rtn[-1].isoformat())
