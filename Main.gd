extends Node2D

var gui_time: Label
var gui_chick_num: Label
var catched_chickens := 0
var _tween: Tween
var win = false
var lose = false


onready var chickens_num := $Chickens.get_child_count()
onready var game_over_root: Control
onready var game_over_label := $CanvasLayer/GameOver/Label
onready var game_over_hover := $CanvasLayer/GameOver/hover
onready var game_over_pict := $CanvasLayer/GameOver/TextureRect

export var time_left := 180
export var win_texture: Texture

func _ready():
	gui_time = $CanvasLayer/GUI/NinePatchRect2/TimeLeft
	gui_time.text = format_time(time_left)
	
	gui_chick_num = $CanvasLayer/GUI/NinePatchRect/ChickensNum
	set_catched_chickens_n(catched_chickens, chickens_num)
	
	_tween = get_node("Tween")
	game_over_root = $CanvasLayer/GameOver
	
	for dog in $Dogs.get_children():
		dog.connect("on_bite", self, "on_dog_bite")


func _on_Timer_timeout():
	if (time_left <= 0):
		return
	time_left -= 1
	gui_time.text = format_time(time_left)
	check_game_over()


func format_time(seconds: int):
	var minutes = seconds / 60
	var last_sec = seconds - (minutes * 60)
	
	return "%s:%s" % [minutes, "0%s" % last_sec if last_sec < 10 else last_sec]


func _on_Player_on_chicken_catch(chicken_node):
	catched_chickens += 1
	chicken_node.queue_free()
	set_catched_chickens_n(catched_chickens, chickens_num)
	check_game_over()


func check_game_over():
	if (catched_chickens == chickens_num):
		win = true
		game_over_label.text = ""
		game_over()
	if (time_left <= 0):
		game_over_label.text = "Time is over"
		lose = true
		game_over()


func set_catched_chickens_n(current: int, all: int):
	gui_chick_num.text = "%s / %s" % [current, all]


func game_over():
	$CanvasLayer/GUI.hide()
	var color = Color("#000")
	game_over_label.modulate = Color('#fff')
	
	if win:
		color = Color("#fff")
		game_over_label.modulate = Color('#000')
		game_over_pict.texture = win_texture
	
	game_over_hover.color = color
	if (_tween.is_active()):
		# warning-ignore:return_value_discarded
		_tween.stop_all()
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(
		game_over_root, "modulate", 
		game_over_root.modulate, # from
		Color(game_over_root.modulate.r, game_over_root.modulate.g, game_over_root.modulate.b, 1), # to
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
	# warning-ignore:return_value_discarded
	_tween.start()
	$GameOver.play()
	get_tree().paused = true


func on_dog_bite():
	game_over_label.text = "You have been caught"
	game_over()


func _on_MainTheme_finished():
	$MainTheme.play(0)


func _on_GameOver_restart_the_game():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_Help_help_opened():
	if win or lose:
		return
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/GUI.visible = false


func _on_Help_help_closed():
	if win or lose:
		return
	$CanvasLayer/GameOver.visible = true
	$CanvasLayer/GUI.visible = true


func _on_Help_exit_game():
	get_tree().quit()
