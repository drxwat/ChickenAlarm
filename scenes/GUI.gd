extends Control

signal open_help

func _on_Button_pressed():
	emit_signal("open_help")
