extends Control

signal help_opened
signal help_closed
signal exit_game

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_help()

func toggle_help():
		get_tree().paused = !get_tree().paused
		modulate = Color(modulate.r, modulate.g, modulate.b, 1 if get_tree().paused else 0)
		if (get_tree().paused):
			emit_signal("help_opened")
		else:
			emit_signal("help_closed")


func _on_GUI_open_help():
	toggle_help()


func _on_Button_pressed():
	emit_signal("exit_game")
