extends KinematicBody2D
var speed = 100
var velocity = Vector2.ZERO
var player = null
var Bullet = preload("res://Scenes/enemy_bullet.tscn")
var facing = "left"
var rate_of_fire = 0.4
var can_fire = true
func _ready():
	$Sprite.scale.x = -1
	
func hit_by_bullet():
	get_parent().get_node("Player/Score").score(1)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO
	if player != null:# && is_instance_valid(player):
		shoot_at_player()
	player = null

func _process(delta):
	while player != null:
		shoot_at_player()

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit()


func _on_player_detect_body_entered(body):
	if body.get_name() == "Player":
		player = body
		shoot_at_player()

func _on_player_detect_body_exited(body):
	player = null
	
func shoot_at_player():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.position = get_node("Sprite/Shoot").get_global_position()
	get_parent().add_child(bullet) #Add as child to avoid detecting with self
	bullet.shoot(facing)
	yield(get_tree().create_timer(rate_of_fire), "timeout")
	can_fire = true
