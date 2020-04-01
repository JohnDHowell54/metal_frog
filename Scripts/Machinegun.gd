extends Area2D

var machgunsprite = preload("res://Sprites/bigger_machinefrog-Sheet.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#connect("body_entered", self, "_on_Machinegun_body_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Machinegun_body_entered(body):
	if body.has_method("set_weapon"):
		body.set_weapon("machinegun", 0.2, machgunsprite)
		body.set_ammo(100)
	queue_free()
