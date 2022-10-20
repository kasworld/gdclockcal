extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var weatherURL = "http://192.168.0.10/weather.txt"
export var updateWeatherSecond = 60*1

func updateWeather():
	$HTTPRequestWeather.request(weatherURL)

export var backgroundImageURL = "http://192.168.0.10/background.png"
export var updateBackgroundImageSecond = 60*1

func updateBackgroundImage():
	$HTTPRequestBackgroundImage.request(backgroundImageURL)


export var weekdaystring = ["일","월","화","수","목","금","토"]
export var backgroundColor = Color(0xffffffff)
export var timeColor = Color(0x000000ff)
export var dateColor = Color(0x000000ff)
export var weatherColor = Color(0x000000ff)
export var todayColor = Color(0x00ff00ff)
export var weekdayColorList = [
	Color(0xff0000ff),  # sunday
	Color(0x000000ff),  # monday
	Color(0x000000ff),
	Color(0x000000ff),
	Color(0x000000ff),
	Color(0x000000ff),
	Color(0x0000ffff),  # saturday
]

# Called when the node enters the scene tree for the first time.
var calenderLabels = []
var bgImage = Image.new()
var bgTexture = ImageTexture.new()
func _ready():

	bgImage.create(1920,1080,true,Image.FORMAT_RGBA8)
	bgImage.fill(backgroundColor)
	bgTexture.create_from_image(bgImage)
	$BackgroundSprite.set_texture(bgTexture)

	if updateWeatherSecond > 0:
		$HTTPRequestWeather.connect("request_completed", self, "_on_weather_request_completed")
	if updateBackgroundImageSecond > 0:
		$HTTPRequestBackgroundImage.connect("request_completed", self, "_on_backgroundimage_request_completed")


	$TimeLabel.add_color_override("font_color",  timeColor )
	$TimeLabel.add_color_override("font_color_shadow",  timeColor.contrasted() )
	$TimeLabel.set("custom_constants/shadow_offset_x",5)
	$TimeLabel.set("custom_constants/shadow_offset_y",5)
	$DateLabel.add_color_override("font_color",  dateColor )
	$DateLabel.add_color_override("font_color_shadow",  dateColor.contrasted() )
	$DateLabel.set("custom_constants/shadow_offset_x",4)
	$DateLabel.set("custom_constants/shadow_offset_y",4)
	$WeatherLabel.add_color_override("font_color",  weatherColor )
	$WeatherLabel.add_color_override("font_color_shadow",  weatherColor.contrasted() )
	$WeatherLabel.set("custom_constants/shadow_offset_x",3)
	$WeatherLabel.set("custom_constants/shadow_offset_y",3)

	var ln = []
	for i in range(len(weekdaystring)):
		var lb = Label.new()
		lb.text = weekdaystring[i]
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lb.align = Label.ALIGN_CENTER
		lb.add_color_override("font_color",  weekdayColorList[i] )
		lb.add_color_override("font_color_shadow",  weekdayColorList[i].contrasted() )
		lb.set("custom_constants/shadow_offset_x",2)
		lb.set("custom_constants/shadow_offset_y",2)
			
		$CalendarGrid.add_child(lb)
		ln.append(lb)
	calenderLabels.append(ln)
	for _i in range(6):
		ln = []
		for j in range(7):
			var lb = Label.new()
			lb.text = "%d" % j
			lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.align = Label.ALIGN_CENTER
			lb.set("custom_constants/shadow_offset_x",2)
			lb.set("custom_constants/shadow_offset_y",2)
			#lb.add_color_override("font_color",  weekdayColorList[j] ))
			$CalendarGrid.add_child(lb)
			ln.append(lb)
		calenderLabels.append(ln)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

var oldWeatherUpdate = 0.0 # unix time 
var oldBackgroundImageUpdate = 0.0 # unix time 
var oldDateUpdate = {"day":0} # unix time 

# called every 1 second
func _on_Timer_timeout():
	var timeNowDict = Time.get_datetime_dict_from_system()
	var timeNowUnix = Time.get_unix_time_from_system()

	# update every 1 second
	$TimeLabel.text = "%02d:%02d:%02d" % [timeNowDict["hour"] , timeNowDict["minute"] ,timeNowDict["second"]  ]

	# every updateWeatherSecond, update weather
	if oldBackgroundImageUpdate + updateBackgroundImageSecond < timeNowUnix:
		oldBackgroundImageUpdate = timeNowUnix
		updateBackgroundImage()

	if oldWeatherUpdate + updateWeatherSecond < timeNowUnix:
		oldWeatherUpdate = timeNowUnix
		updateWeather()
	
	# date changed, update datelabel, calendar
	if oldDateUpdate["day"] != timeNowDict["day"]:
		oldDateUpdate = timeNowDict
		$DateLabel.text = "%04d-%02d-%02d %s" % [
			timeNowDict["year"] , timeNowDict["month"] ,timeNowDict["day"],
			weekdaystring[ timeNowDict["weekday"]]  
			]
		updateCalendar()
	
func updateCalendar():	
	var tz = Time.get_time_zone_from_system()
	var today = int(Time.get_unix_time_from_system()) +tz["bias"]*60
	var todayDict = Time.get_date_dict_from_unix_time(today)
	var dayIndex = today - (7 + todayDict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))
	
	for week in range(6):
		for wd in range(7):
			var dayIndexDict = Time.get_date_dict_from_unix_time(dayIndex)
			var curLabel = calenderLabels[week+1][wd]
			curLabel.text = "%d" % dayIndexDict["day"]
			var co = weekdayColorList[wd]
			if dayIndexDict["month"] != todayDict["month"]:
				co = co.contrasted()
			elif dayIndexDict["day"] == todayDict["day"]:
				co = todayColor 
			curLabel.add_color_override("font_color",  co )
			curLabel.add_color_override("font_color_shadow",  co.contrasted() )
			dayIndex += 24*60*60

# var bgNum:int
# func updateBackgrounImage():
# 	bgNum +=1
# 	var co1 = (sin( bgNum / 256.0 ) +1)/2
# 	# var co1 = (sin( bgNum / PI /4 /6 ) +1)/2
# 	bgImage.fill(Color( co1,co1,co1))
# 	# if bgNum % 2 == 0 :
# 	# 	bgImage.fill(Color(0x000000ff))
# 	# else :
# 	# 	bgImage.fill(Color(0xffffffff))
# 	bgTexture.create_from_image(bgImage)
# 	# $BackgroundSprite.set_texture(bgTexture)



func keyValueFromHeader(key: String ,headers: PoolStringArray):
	var keyLen = len(key)
	for i in headers:
		if i.left(keyLen) == key:
			return i.right(keyLen)
	return ""

# Last-Modified: Wed, 19 Oct 2022 03:10:02 GMT
const toFindDate = "Last-Modified: "

var lastWeatherModified 
func _on_weather_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var thisModified = keyValueFromHeader(toFindDate,headers)
		if lastWeatherModified != thisModified:
			lastWeatherModified = thisModified
			var text = body.get_string_from_utf8()
			$WeatherLabel.text = text

var lastBackgroundImageModified 
func _on_backgroundimage_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var thisModified = keyValueFromHeader(toFindDate,headers)
		if lastBackgroundImageModified != thisModified:
			lastBackgroundImageModified = thisModified
			var image_error = bgImage.load_png_from_buffer(body)
			if image_error != OK:
				print("An error occurred while trying to display the image.")
			else:
				bgTexture.create_from_image(bgImage)
