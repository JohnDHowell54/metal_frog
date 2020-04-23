extends RigidBody2D

export var speed = 1200

func _on_RigidBody2D_body_entered(body):
	print("I'm hitting:", body.get_name())
	if body.get_name() != "Player":
		if body.has_method("hit_by_bullet"):
			body.hit_by_bullet()
		queue_free()


func shoot(dir, diag, up, down_diag, down):
	if dir == "right":
		apply_impulse(Vector2(), Vector2(speed, 0))
	if dir == "right" && diag:
		apply_impulse(Vector2(), Vector2(speed,-speed))
	if dir == "left":
		apply_impulse(Vector2(), Vector2(-speed, 0))
	if dir == "left" && diag:
		apply_impulse(Vector2(), Vector2(-speed, -speed))
	if up:
		apply_impulse(Vector2(), Vector2(0, -speed))
	if dir == "right" && down_diag:
		apply_impulse(Vector2(), Vector2(speed,speed))
	if dir == "left" && down_diag:
		apply_impulse(Vector2(), Vector2(-speed,speed))
	if down:
		apply_impulse(Vector2(), Vector2(0,speed))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
