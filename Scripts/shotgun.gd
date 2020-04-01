extends Area2D

var shotgunsprite = preload("res://Sprites/shotgunfrog-Sheet.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_Shotgun_body_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Shotgun_body_entered(body):
	if body.has_method("set_weapon"):
		body.set_weapon("shotgun", 0.8, shotgunsprite)
	queue_free()
