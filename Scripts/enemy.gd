extends KinematicBody2D
var speed = 100
var velocity = Vector2.ZERO
var player = null
onready var spr = $Sprite
onready var dead = preload("res://Sprites/bigfly_death.png")
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0
enum states {PATROL, CHASE}
var state = states.PATROL

func _ready():
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	
func hit_by_bullet():
	get_parent().get_node("Player/Sprite/Camera2D/UI/Score").score(1)
	spr.set_texture(dead)
	yield(get_tree().create_timer(.5), "timeout")
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	choose_action()
	velocity = move_and_slide(velocity)
	

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit()


func _on_player_detect_body_entered(body):
	if body.get_name() == "Player":
		player = body
	state = states.CHASE

func _on_player_detect_body_exited(body):
	player = null
	state = states.PATROL

func chase_player(velocity):
	if player != null:# && is_instance_valid(player):
		velocity = (position.direction_to(player.position)).normalized() * speed
	velocity = move_and_slide(velocity)

func patrol(velocity):
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - position).normalized() * speed
	return velocity

func choose_action():
	velocity = Vector2.ZERO
	var target
	match state:
		states.PATROL:
			if !patrol_path:
				return
			target = patrol_points[patrol_index]

			if position.distance_to(target) > 1:
				patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
				target = patrol_points[patrol_index]
			velocity = (target-position).normalized() * speed
		
		states.CHASE:
			if  player != null && player.get_name() == "Player":
				target = player.position
				velocity = (target - position).normalized() * speed
