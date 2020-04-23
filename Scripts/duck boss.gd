extends KinematicBody2D
var speed = 150
var velocity = Vector2.ZERO
var player = null
var playerName
var can_fire = true
var rate_of_fire = 0.5
var Bullet = preload("res://Scenes/bullet.tscn")
var facing = "left"
var hp = 10
var grav = 3000
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.scale.x = -1

func hit_by_bullet():
	if hp != 0:
		hp -= 1
	else:
		get_parent().get_node("Player/Sprite/Camera2D/UI/Score").score(5)
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# We're setting velocity.y to 0 because if not he flies around everywhere
func _process(delta):
	chase_player()
	if playerName == "Player":
		shoot_at_player()
	#velocity.y = 0
	velocity.y += grav * delta
	velocity = move_and_slide(velocity)

func chase_player():
	var target
	if playerName == "Player":
		target = player.position
		velocity = position.direction_to(player.position) * speed
		
func _on_player_detect_body_entered(body):
	if body.get_name() == "Player":
		player = body
		playerName = body.get_name()
		shoot_at_player()

func shoot_at_player():
	if can_fire == true:
		can_fire = false
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		if facing == "left":
			bullet.position = get_node("Sprite/Shoot").get_global_position()
		else:
			bullet.position = get_node("Sprite/Shoot2").get_global_position()
		get_parent().add_child(bullet) #Add as child to avoid detecting with self
		bullet.shoot(facing, false,false, false, false)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true


func _on_player_back_body_entered(body):
	if facing == "left":
		if body.get_name() == "Player":
			facing = "right"
			$Sprite.scale.x = 1
	else:
		if body.get_name() == "Player":
			facing = "left"
			$Sprite.scale.x = -1
