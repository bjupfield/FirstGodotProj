extends Button


func _on_button_down():
	self.text = get_parent().name
	var b:Resource = ResourceLoader.load("res://GameObjects/ControlsChooser.tscn")
	var c:Node = b.instantiate()
	c.position.x = get_viewport_rect().size.x / 2 -  (c.size.x / 2)
	c.position.y = get_viewport_rect().size.y / 2 -  (c.size.y / 2)
	#var b:Node = get_node("res://GameObjects/ControlsChooser.tscn")
	get_parent().add_child(c)
	#get_parent().get_tree().quit(0)
	pass
