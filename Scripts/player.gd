extends KinematicBody2D

#Movement vars
export (int) var speed = 1000
export (int) var jump_speed = -1200
export (int) var grav = 4000
export (int) var jump_counter = 0
var velocity = Vector2.ZERO

#General preloads and vars
onready var sprite = $Sprite
var facing = "right"
var defspr = preload("res://Sprites/metalfrog_shooting_-Sheet.png")


#Shooting vars
var Bullet = preload("res://Scenes/bullet.tscn")
var can_fire = true
var rate_of_fire = 0.6
var weapon = "pistol"
var ammo = 0

#Main input func
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		facing = "left"
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		facing = "right"
	if Input.is_action_pressed("shoot") and can_fire == true:
		can_fire = false
		shoot(weapon)
		ammo -= 1


func _physics_process(delta):
	get_input()
	
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
	$Animation.play("Shooting")
	weapon = wep
	can_fire = false
	var bullet = Bullet.instance()
	var bullet2 = Bullet.instance()
	var bullet3 = Bullet.instance()
	match weapon:
		"pistol":
			bullet.position = get_node("Sprite/Shoot").get_global_position()
			get_parent().add_child(bullet) #Add as child to avoid detecting with self
			bullet.shoot(facing)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
		"machinegun":
			bullet.position = get_node("Sprite/Shoot").get_global_position()
			get_parent().add_child(bullet) #Add as child to avoid detecting with self
			bullet.shoot(facing)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
			ammo = ammo - 1
			if ammo == 0:
				set_weapon("pistol", 0.6, defspr)
		"shotgun":
			bullet.position = get_node("Sprite/Shoot").get_global_position()
			bullet2.position = get_node("Sprite/Shoot2").get_global_position()
			bullet3.position = get_node("Sprite/Shoot3").get_global_position()
			get_parent().add_child(bullet)
			get_parent().add_child(bullet2)
			get_parent().add_child(bullet3) #Add as child to avoid detecting with self
			bullet.shoot(facing)
			bullet2.shoot(facing)
			bullet3.shoot(facing)
			yield(get_tree().create_timer(rate_of_fire), "timeout")
			can_fire = true
			ammo = ammo - 1
			if ammo == 0:
				set_weapon("pistol", 0.6, defspr)
	$Animation.play("Standing")
	
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
