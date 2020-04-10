extends RigidBody2D

export var speed = 1200

func _on_RigidBody2D_body_entered(body):
	print("I'm hitting:", body.get_name())
	if body.get_name() != "duckenemy" && body.get_name() != "RigidBody2D":
		if body.has_method("hit_by_bullet"):
			body.hit_by_bullet()
		queue_free()
	

func shoot(dir):
	if dir == "right":
		apply_impulse(Vector2(), Vector2(speed, 0))
	else:
		apply_impulse(Vector2(), Vector2(-speed, 0))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
