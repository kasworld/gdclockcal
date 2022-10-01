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
	for i in range(6):
		ln = []
		for j in range(7):
			var lb = Label.new()
			lb.text = "%d" % j
			lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.align = Label.ALIGN_CENTER
			lb.add_color_override("font_color", Co8ToColor( weekdayColorList[j] ))
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
	[127, 127, 127],  # monday
	[127, 127, 127],
	[127, 127, 127],
	[127, 127, 127],
	[127, 127, 127],
	[32, 32, 127],  # saturday
	[127, 0, 0],  # sunday
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

var oldDate = {"day":0}
var oldTime = {"second":0}
func _on_Timer_timeout():
	var timenow = Time.get_time_dict_from_system()
	if oldTime["second"] == timenow["second"]:
		return 
	oldTime = timenow
	$TimeLabel.text = "%02d:%02d:%02d" % [timenow["hour"] , timenow["minute"] ,timenow["second"]  ]

	var datenow = Time.get_date_dict_from_system()
	if oldDate["day"] == datenow["day"]:
		return
	oldDate = datenow
	$DateLabel.text = "%04d-%02d-%02d %s" % [
		datenow["year"] , datenow["month"] ,datenow["day"],
		weekdaystring[ datenow["weekday"]]  
		]


