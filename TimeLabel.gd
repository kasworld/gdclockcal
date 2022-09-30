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


func _on_Timer_timeout():
	var timenow = Time.get_time_dict_from_system()
	self.text = "%02d:%02d:%02d" % [timenow["hour"] , timenow["minute"] ,timenow["second"]  ]
	pass # Replace with function body.
