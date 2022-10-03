extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var weatherURL = "http://192.168.0.10/weather.txt"
export var testColor = Color(0x7f7f7fff)
export var weekdaystring = ["일","월","화","수","목","금","토"]
export var timeColor = Color(0xffffffff)
export var dateColor = Color(0xffffffff)
export var weatherColor = Color(0xffffffff)
export var otherMonthColorList = [
	Color(0x7f0000ff),  # sunday
	Color(0x7f7f7fff),  # monday
	Color(0x7f7f7fff),
	Color(0x7f7f7fff),
	Color(0x7f7f7fff),
	Color(0x7f7f7fff),
	Color(0x1f1f7fff),  # saturday
]
export var todayColor = Color(0xffff00ff)
export var weekdayColorList = [
	Color(0xff0000ff),  # sunday
	Color(0xffffffff),  # monday
	Color(0xffffffff),
	Color(0xffffffff),
	Color(0xffffffff),
	Color(0xffffffff),
	Color(0x1f1fffff),  # saturday
]


# Called when the node enters the scene tree for the first time.
var calenderLabels = []
func _ready():

	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

	$TimeLabel.add_color_override("font_color",  timeColor )
	$DateLabel.add_color_override("font_color",  dateColor )
	$WeatherLabel.add_color_override("font_color",  weatherColor )

	var ln = []
	for i in range(len(weekdaystring)):
		var lb = Label.new()
		lb.text = weekdaystring[i]
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lb.align = Label.ALIGN_CENTER
		lb.add_color_override("font_color",  weekdayColorList[i] )
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
			#lb.add_color_override("font_color",  weekdayColorList[j] ))
			$CalendarGrid.add_child(lb)
			ln.append(lb)
		calenderLabels.append(ln)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	if Input.is_action_pressed("ui_cancel"):
# 	pass

var oldTime = {"second":-1}
var oldWeather = {"minute":-10}
var oldDate = {"day":0}
func _on_Timer_timeout():
	var timenow = Time.get_datetime_dict_from_system()

	# second changed, update clock
	if oldTime["second"] == timenow["second"]:
		return 
	oldTime = timenow
	$TimeLabel.text = "%02d:%02d:%02d" % [timenow["hour"] , timenow["minute"] ,timenow["second"]  ]

	# 10 minute changed, update weather
	if oldWeather["minute"] == timenow["minute"]:
		return 
	oldWeather = timenow
	updateWeather()

	# date changed, update datelabel, calendar
	if oldDate["day"] == timenow["day"]:
		return
	oldDate = timenow
	$DateLabel.text = "%04d-%02d-%02d %s" % [
		timenow["year"] , timenow["month"] ,timenow["day"],
		weekdaystring[ timenow["weekday"]]  
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
				co = otherMonthColorList[wd] 
			elif dayIndexDict["day"] == todayDict["day"]:
				co = todayColor 
			curLabel.add_color_override("font_color",  co )
			dayIndex += 24*60*60



func updateWeather():
	 $HTTPRequest.request(weatherURL)

func _on_request_completed(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	$WeatherLabel.text = text
