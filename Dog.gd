extends KinematicBody2D


const UP := Vector2(0, -1)

export var gravity := 20
export var speed := 50
export var walk_dist := 30000

var motion := Vector2()
var direction := false
var move_target_x := walk_dist

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
	move_target_x -= motion_x
	motion.x = -motion_x if direction else motion_x 
	
	if (move_target_x <= 0):
		pick_new_move_target()
	
	motion = move_and_slide(motion, UP)


func pick_new_move_target():
	move_target_x = walk_dist
	changeDirection(!direction)


func changeDirection(new_direction: bool):
	if (direction != new_direction):
		direction = new_direction
		animated_sprite.set_flip_h(new_direction)
