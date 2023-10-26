extends Button


func _input(event):
	self.text = event.as_text()
	pass
	
func _input_Mine(event):
	pass

func _on_button_down():
	get_tree().quit(0)
