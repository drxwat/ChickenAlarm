extends KinematicBody2D

const UP := Vector2(0, -1)
const CELL_DIGGING_TIME = 0.25

export var gravity := 20
export var speed := 200
export var jump_height := -200
export var hole_size := Vector2(7,7)

var motion := Vector2()
var is_diging = false
var is_in_underground = false
var _digging_cells setget set_digging_cells
var digging_time = CELL_DIGGING_TIME

onready var ground_tm: Node2D = get_tree().get_root().get_node("Root/Ground")
onready var dig_player := $SFX/Digging
onready var jump_player := $SFX/Jump


func set_digging_cells(value):
	_digging_cells = value
	digging_time = CELL_DIGGING_TIME

func _physics_process(delta):
	is_in_underground = true if global_position.y > 0 else false
	
	motion.y = 0 if is_in_underground else motion.y + gravity

	motion.x = 0
	if Input.is_action_pressed("ui_right"):
		motion.x = speed
	if Input.is_action_pressed("ui_left"):
		motion.x = -speed
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
		set_digging_cells(null)
	
	if is_diging and _digging_cells == null:
		var direction: Vector2
		var center: Vector2
		if Input.is_action_pressed("ui_down"):
			direction = Vector2(0, 1)
			center = global_position + Vector2(0, hole_size.y)
		elif Input.is_action_pressed("ui_up"):
			direction = Vector2(0, -1)
			center = global_position + Vector2(0, -hole_size.y)
		elif Input.is_action_pressed("ui_left"):
			direction = Vector2(-1, 0)
			center = global_position + Vector2(-hole_size.x, 0)
		elif Input.is_action_pressed("ui_right"):
			direction = Vector2(1, 0)
			center = global_position + Vector2(hole_size.x, 0)
		
		if direction:
			var cells = ground_tm.get_direction_cells(direction, center, hole_size.x * 2)
			set_digging_cells(cells)
	
	if is_diging and _digging_cells != null:
		digging_time -= delta
		if digging_time < 0:
			var removed = ground_tm.remove_first_active_cell(_digging_cells)
			if removed:
				if dig_player.playing:
					dig_player.stop()
				dig_player.play()
			set_digging_cells(null)

	motion = move_and_slide(motion, UP)

