extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Had a weird bug where bullets would dissapear without hitting anything if queue_free() was not in the nested loop in bullet.gd
# So while this won't do anything, it will call the queue_free() and the bullet will act appropriately
func hit_by_bullet():
	pass
