extends Control

signal restart_the_game


func _on_Button_pressed():
	emit_signal("restart_the_game")
