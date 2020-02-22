extends Node2D

var gui_time: Label
var gui_chick_num: Label
var catched_chickens := 0
onready var chickens_num := $Chickens.get_child_count()

export var time_left := 71

func _ready():
	gui_time = $Player/GUI/NinePatchRect2/TimeLeft
	gui_time.text = format_time(time_left)
	
	gui_chick_num = $Player/GUI/NinePatchRect/ChickensNum
	set_catched_chickens_n(catched_chickens, chickens_num)


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


func check_game_over():
	if (catched_chickens == chickens_num):
		print("Win")
	if (time_left <= 0):
		print("Lose")

func set_catched_chickens_n(current: int, all: int):
	gui_chick_num.text = "%s / %s" % [current, all]

