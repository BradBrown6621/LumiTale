extends Control

func resume():
	get_tree().paused = false
	$".".hide()

func pause():
	get_tree().paused = true
	$".".show()

func Esc():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		print("pause")
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		print("resume")
		resume()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	Esc()
	
