extends Node2D

var gui_time: Label
var gui_chick_num: Label

export var time_left := 71

func _ready():
	gui_time = $Player/GUI/NinePatchRect2/TimeLeft
	gui_time.text = format_time(time_left)
	
	gui_chick_num = $Player/GUI/NinePatchRect/ChickensNum
	gui_chick_num.text = "0"
	

func _on_Timer_timeout():
	time_left -= 1
	gui_time.text = format_time(time_left)

func format_time(seconds: int):
	var minutes = seconds / 60
	var last_sec = seconds - (minutes * 60)
	
	return "%s:%s" % [minutes, "0%s" % last_sec if last_sec < 10 else last_sec]


func _on_Player_on_chicken_catch(chicken_node):
	chicken_node.queue_free()
	gui_chick_num.text = str(int(gui_chick_num.text) + 1)
