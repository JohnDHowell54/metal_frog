extends Label

var label = "Score: %s"
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func score(num):
	score += num
	var labeltext = label % score
	set_text(str(labeltext))
