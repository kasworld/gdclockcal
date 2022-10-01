# clock calendar and weather by dodot engine

# godot 게임 엔진으로 만든 시계, 달력, 날씨 프로그램 

![screenshot](screenshot.png)

날씨 업데이트를 위해서는 weather.txt를 정기적으로 업데이트 해줄 서버와 서비스 해줄 http 서버가 필요합니다. 

[wasmclockcal](https://github.com/kasworld/wasmclockcal) 에 있는 getweather.py, dir2http 를 사용하시면 됩니다. 

clockcal.gd 에 있는 

    $HTTPRequest.request("http://192.168.0.10/weather.txt") 

를 수정하시면 됩니다. 
