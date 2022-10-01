extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var calenderNodes = []
func _ready():
	var ln = []
	for i in range(len(weekdaystring)):
		var lb = Label.new()
		lb.text = weekdaystring[i]
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lb.align = Label.ALIGN_CENTER
		lb.add_color_override("font_color", Co8ToColor( weekdayColorList[i] ))
		$CalendarGrid.add_child(lb)
		ln.append(lb)
	calenderNodes.append(ln)
	for _i in range(6):
		ln = []
		for j in range(7):
			var lb = Label.new()
			lb.text = "%d" % j
			lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.align = Label.ALIGN_CENTER
			#lb.add_color_override("font_color", Co8ToColor( weekdayColorList[j] ))
			$CalendarGrid.add_child(lb)
			ln.append(lb)
		calenderNodes.append(ln)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var weekdaystring = ["일","월","화","수","목","금","토"]
var clockColor = [255, 255, 255]
var calendarColor = [255, 255, 255]
var weatherColor = [255, 255, 255]
var monthweekColor = [255, 255, 255]
var otherMonthColorList = [
	[127, 0, 0],  # sunday
	[127, 127, 127],  # monday
	[127, 127, 127],
	[127, 127, 127],
	[127, 127, 127],
	[127, 127, 127],
	[32, 32, 127],  # saturday
]
var todayColor = [255, 255, 0]
var weekdayColorList = [
	[255, 0, 0],  # sunday
	[255, 255, 255],  # monday
	[255, 255, 255],
	[255, 255, 255],
	[255, 255, 255],
	[255, 255, 255],
	[32, 32, 255],  # saturday
]

func Co8ToColor(co ):
	return Color( co[0]/255.0, co[1]/255.0, co[2]/255.0)

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
	if oldWeather["minute"]/10 == timenow["minute"]/10:
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
	var today = int(Time.get_unix_time_from_system())
	var todayDict = Time.get_date_dict_from_unix_time(today)
	var dayIndex = today - (7 + todayDict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))
	
	for week in range(6):
		for wd in range(7):
			var dayIndexDict = Time.get_date_dict_from_unix_time(dayIndex)
			var curLabel = calenderNodes[week+1][wd]
			curLabel.text = "%d" % dayIndexDict["day"]
			var co = weekdayColorList[wd]
			if dayIndexDict["month"] != todayDict["month"]:
				co = otherMonthColorList[wd] 
			elif dayIndexDict["day"] == todayDict["day"]:
				co = todayColor 
			curLabel.add_color_override("font_color", Co8ToColor( co ))
			dayIndex += 24*60*60

	
func updateWeather():
	pass
