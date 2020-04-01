extends KinematicBody2D
var speed = 100
var velocity = Vector2.ZERO
var player = null
func _ready():
	pass
	
func hit_by_bullet():
	get_parent().get_node("Player/Score").score(1)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO
	if player != null:# && is_instance_valid(player):
		velocity = (position.direction_to(player.position)).normalized() * speed
	velocity = move_and_slide(velocity)

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit()


func _on_player_detect_body_entered(body):
	if body.get_name() == "Player":
		player = body

func _on_player_detect_body_exited(body):
	player = null
