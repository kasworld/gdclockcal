extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	[255, 255, 255],  # monday
	[255, 255, 255],
	[255, 255, 255],
	[255, 255, 255],
	[255, 255, 255],
	[32, 32, 255],  # saturday
	[255, 0, 0],  # sunday
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for v in weekdaystring:
		var lb = Label.new()
		lb.text = v
		lb.size_flags_horizontal = SIZE_EXPAND_FILL
		self.add_child(lb)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var oldDate = {"day":0}
func _on_Timer_timeout():
	var datenow = Time.get_date_dict_from_system()
	if oldDate["day"] == datenow["day"]:
		return
	oldDate = datenow

