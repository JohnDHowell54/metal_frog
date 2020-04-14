extends KinematicBody2D

#Movement vars
export (int) var speed = 2500
export (int) var jump_speed = -1200
export (int) var grav = 4000
export (int) var jump_counter = 0
var velocity = Vector2.ZERO
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

#General preloads and vars
onready var sprite = $Sprite
var facing = "right"

#Shooting vars
var Bullet = preload("res://Scenes/bullet.tscn")
var can_fire = true
var rate_of_fire = 0.6
var weapon = "pistol"
var ammo = 0
var shoot = "Sprite/Shoot"
var diag = false
var diag_shoot = false
enum states {IDLE, RUNNING, SHOOTING, RUNNING_SHOOTING, DIAG, UP, RUNNING_DIAG, SHOOTING_DIAG, RUNNING_SHOOTING_DIAG }
var state = states.IDLE
#Main input func
func get_input():
	var dir = 0
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		dir -= 1
		if diag:
			diag_shoot = true
		facing = "left"
		state = states.RUNNING
	if Input.is_action_pressed("move_right"):
		dir += 1
		if diag:
			diag_shoot = true
		facing = "right"
		state = states.RUNNING
	if Input.is_action_just_pressed("diag"):
		if diag:
			state = states.IDLE
			diag = false
		elif !diag:
			state = states.DIAG
			diag = true
		elif !diag && !diag_shoot:
			state = states.IDLE
		# Makes sure we use the right shoot position2d
		elif shoot == "Sprite/Shoot":
			shoot = "Sprite/Shoot_diag"
			diag = true
		else:
			shoot = "Sprite/Shoot"
			diag = false

	if Input.is_action_just_pressed("up"):
		if !diag:
			shoot = "Sprite/Shoot_up"
		if diag:
			shoot = "Sprite/Shoot_up"
	if Input.is_action_pressed("shoot") and can_fire == true:
		can_fire = false
		if !diag:
			state = states.SHOOTING
		if diag:
			state = states.SHOOTING_DIAG
		shoot(weapon)
		ammo -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	if dir == 0 && !diag:
		state = states.IDLE


func _physics_process(delta):
	get_input()
	play_animation()
	# Movement
	velocity.y += grav * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if jump_counter != 1:
			velocity.y = jump_speed
			jump_counter += 1	
	if is_on_floor():
		jump_counter = 0
	
	#Check our facing and flip accordingly
	if facing == "left":
		sprite.scale.x = -1
	if facing == "right":
		sprite.scale.x = 1
	
func shoot(wep):
	weapon = wep
	can_fire = false
	var bullet = Bullet.instance()
	var bullet2 = Bullet.instance()
	var bullet3 = Bullet.instance()
	match weapon:
		"pistol":
			bullet.position = get_node(shoot).get_global_position()
			get_parent().add_child(bullet) #Add as child to avoid detecting with self
			bullet.shoot(facing,diag, false)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
		"machinegun":
			bullet.position = get_node(shoot).get_global_position()
			get_parent().add_child(bullet) #Add as child to avoid detecting with self
			bullet.shoot(facing)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
			ammo = ammo - 1
			#if ammo == 0:
#				set_weapon("pistol", 0.6, defspr)
		"shotgun":
			bullet.position = get_node("Sprite/Shoot").get_global_position()
			bullet2.position = get_node("Sprite/Shoot2").get_global_position()
			bullet3.position = get_node("Sprite/Shoot_diag").get_global_position()
			get_parent().add_child(bullet)
			get_parent().add_child(bullet2)
			get_parent().add_child(bullet3) #Add as child to avoid detecting with self
			bullet.shoot(facing, false)
			bullet2.shoot(facing,false)
			bullet3.shoot(facing, true)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
			ammo = ammo - 1
#			if ammo == 0:
#				set_weapon("pistol", 0.6, defspr)
	if !diag:
		state = states.IDLE

func hit():
	get_tree().reload_current_scene()
	

#Generic set weapon func. Takes weapon, rate of fire, and sprite 
func set_weapon(wep, rof, spr):
	weapon = wep
	rate_of_fire = rof
	sprite.set_texture(spr)

func set_ammo(num):
	ammo = num
#Make sure our character in on the screen. Or get reset
func _on_VisibilityNotifier2D_screen_exited():
	get_tree().reload_current_scene()

func play_animation():
	match state:
		states.IDLE:
			$Animation.play("Idle")
		states.RUNNING:
			$Animation.play("Running")
		states.SHOOTING:
			$Animation.play("Shooting")
		states.DIAG:
			$Animation.play("Diag")
		states.RUNNING_DIAG:
			$Animation.play("Diag_Running")
		states.SHOOTING_DIAG:
			$Animation.play("Diag_Shooting")
		states.RUNNING_SHOOTING_DIAG:
			$Animation.play("Diag_Running_Shooting")
