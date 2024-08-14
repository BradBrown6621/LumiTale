extends Control

@onready var start_level = preload("res://scenes/levels/mainStage.tscn") as PackedScene
	
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_packed(start_level)
