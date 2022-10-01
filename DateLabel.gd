extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var weekdaystring = ["일","월","화","수","목","금","토"]

var oldDate = {"day":0}
func _on_Timer_timeout():
	var datenow = Time.get_date_dict_from_system()
	if oldDate["day"] == datenow["day"]:
		return
	oldDate = datenow
	self.text = "%04d-%02d-%02d %s" % [
		datenow["year"] , datenow["month"] ,datenow["day"],
		weekdaystring[ datenow["weekday"]]  
		]
