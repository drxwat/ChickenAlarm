extends KinematicBody2D


const UP := Vector2(0, -1)

export var gravity := 20
export var speed := 50
export var walk_dist := 30000
export var attack_dist = 150

signal on_bite

var motion := Vector2()
var direction := false
var move_target_x := walk_dist
var _is_attacking := false

var fox: Node2D

onready var start_x: float
onready var animated_sprite: AnimatedSprite


func _ready():
	animated_sprite = $AnimatedSprite
	animated_sprite.animation = "walk"
	animated_sprite.play()
	
	start_x = global_position.x


func _physics_process(delta):
	# Gravity
	motion.y += gravity
	var motion_x = speed
	
	if (fox):
		move_target_x = abs(fox.global_position.x - global_position.x)
		changeDirection(global_position.x > fox.global_position.x)
		motion_x = speed * 3
		
	if (move_target_x <= attack_dist):
		start_attack()
	else:
		stop_attack()
	
	move_target_x -= motion_x
	motion.x = -motion_x if direction else motion_x 
	
	if (not fox and move_target_x <= 0):
		pick_new_move_target()
	
	motion = move_and_slide(motion, UP)


func pick_new_move_target():
	move_target_x = walk_dist
	changeDirection(!direction)


func changeDirection(new_direction: bool):
	if (direction != new_direction):
		direction = new_direction
		animated_sprite.set_flip_h(new_direction)


func _on_AngerArea_body_entered(body):
	fox = body
	animated_sprite.speed_scale = 1.5
	$Bark.play(0)


func _on_AngerArea_body_exited(body):
	move_target_x = start_x - global_position.x
	changeDirection(start_x > global_position.x)
	fox = null
	animated_sprite.speed_scale = 1
	

func start_attack():
	_is_attacking = true
	animated_sprite.position.y = -18
	animated_sprite.animation = "attack"


func stop_attack():
	_is_attacking = false
	animated_sprite.position.y = 0
	animated_sprite.animation = "walk"


func _on_AnimatedSprite_animation_finished():
	if not _is_attacking:
		return
	if move_target_x < attack_dist / 2.2:
		emit_signal("on_bite")
