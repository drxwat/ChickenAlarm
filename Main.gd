extends Node2D

var gui_time: Label
var gui_chick_num: Label
var catched_chickens := 0
var _tween: Tween
var win = false
var lose = false

onready var chickens_num := $Chickens.get_child_count()
onready var game_over_hover: Control

export var time_left := 5

func _ready():
	gui_time = $Player/GUI/NinePatchRect2/TimeLeft
	gui_time.text = format_time(time_left)
	
	gui_chick_num = $Player/GUI/NinePatchRect/ChickensNum
	set_catched_chickens_n(catched_chickens, chickens_num)
	
	_tween = get_node("Tween")
	game_over_hover = $Player/GameOver


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
		game_over()
	if (time_left <= 0):
		lose = true
		game_over()


func set_catched_chickens_n(current: int, all: int):
	gui_chick_num.text = "%s / %s" % [current, all]


func game_over():
	if (_tween.is_active()):
		# warning-ignore:return_value_discarded
		_tween.stop_all()
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(
		game_over_hover, "modulate", 
		game_over_hover.modulate, # from
		Color(game_over_hover.modulate.r, game_over_hover.modulate.g, game_over_hover.modulate.b, 1), # to
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
	# warning-ignore:return_value_discarded
	_tween.start()
	$MainTheme.stop()
	$GameOver.play()

