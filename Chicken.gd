extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity := 20
export var walk_zone := 10000
export var walk_dist := 2000
export var speed := 50
export var jump_rate := 40
export var jump_height := -100

var motion := Vector2()
var move_target_x: float

var direction := false
var next_jump := jump_rate

onready var start_x = global_position.x
onready var sprite = $Sprite

func _physics_process(delta):
	
	# Gravity
	motion.y += gravity
	
	# Random movement
	var motion_x = speed
	move_target_x -= motion_x
	motion.x = -motion_x if direction else motion_x 
	
	if (move_target_x <= 0):
		pick_new_move_target()
	
	# Jumping
	next_jump -= 1
	if (next_jump <= 0):
		next_jump = jump_rate
		motion.y = jump_height
	
	motion = move_and_slide(motion, UP)


func pick_new_move_target():
	move_target_x =  rand_range(walk_dist, walk_zone)
	changeDirection(rand_range(-1, 1) > 0)


func changeDirection(new_direction: bool):
	if (direction != new_direction):
		direction = new_direction
		sprite.set_flip_h(new_direction)


