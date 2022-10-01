extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var weekdaystring = ["일","월","화","수","목","금","토"]

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
