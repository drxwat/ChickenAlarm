extends KinematicBody2D

enum DIRECTION { Right, Left }

const UP := Vector2(0, -1)
const CELL_DIGGING_TIME = 0.25

export var gravity := 20
export var speed := 200
export var jump_height := -200
export var hole_size := Vector2(7,7)

signal on_chicken_catch

var motion := Vector2()
var is_diging = false
var is_in_underground = false
var digging_cell = null
var digging_time = CELL_DIGGING_TIME
var direction = DIRECTION.Right

onready var ground_tm: Node2D = get_tree().get_root().get_node("Root/Ground")
onready var dig_player := $SFX/Digging
onready var jump_player := $SFX/Jump
onready var sprite := $Sprite


func changeDirection(new_direction: int):
	if (direction != new_direction):
		direction = new_direction
		sprite.set_flip_h(new_direction)


func set_digging_cell(cell):
	digging_cell = cell
	digging_time = CELL_DIGGING_TIME

func _physics_process(delta):
	is_in_underground = true if global_position.y > 0 else false
	
	motion.y = 0 if is_in_underground else motion.y + gravity

	motion.x = 0
	if Input.is_action_pressed("ui_right"):
		motion.x = speed
		changeDirection(DIRECTION.Right)
	if Input.is_action_pressed("ui_left"):
		motion.x = -speed
		changeDirection(DIRECTION.Left)
	if is_in_underground and Input.is_action_pressed("ui_down"):
		motion.y = speed
	if is_in_underground and Input.is_action_pressed("ui_up"):
		motion.y = -speed
	
	
	if not is_in_underground and is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			if jump_player.playing:
				jump_player.stop()
			jump_player.play()
			motion.y = jump_height
	
	if Input.is_key_pressed(KEY_SPACE):
		is_diging = true
	else:
		is_diging = false
		set_digging_cell(null)
	
	if is_diging and digging_cell == null:
		var dir: Vector2
		var border: Vector2
		if Input.is_action_pressed("ui_down"):
			dir = Vector2(0, 1)
			border = global_position + Vector2(0, hole_size.y)
		elif Input.is_action_pressed("ui_up"):
			dir = Vector2(0, -1)
			border = global_position + Vector2(0, -hole_size.y)
		elif Input.is_action_pressed("ui_left"):
			dir = Vector2(-1, 0)
			border = global_position + Vector2(-hole_size.x, 0)
		elif Input.is_action_pressed("ui_right"):
			dir = Vector2(1, 0)
			border = global_position + Vector2(hole_size.x, 0)
		
		if dir:
			var cell = ground_tm.get_direction_cell(dir, border)
			set_digging_cell(cell)

	if is_diging and digging_cell != null:
		digging_time -= delta
		if digging_time < 0:
			var removed = ground_tm.remove_cell(digging_cell)
			if removed:
				if dig_player.playing:
					dig_player.stop()
				dig_player.play()
			set_digging_cell(null)

	motion = move_and_slide(motion, UP)



func _on_EnemyDetector_body_shape_entered(body_id, body, body_shape, area_shape):
	emit_signal("on_chicken_catch", body)
#	body.queue_free()
#	print(body)

