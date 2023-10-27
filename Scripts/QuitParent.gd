extends ColorRect


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var posY: int = self.get_screen_position().y
			var posX: int = self.get_screen_position().x
			var sizeY: int = self.size.y
			var sizeX: int = self.size.x
			var hitX: int = event.position.x
			var hitY: int = event.position.y 
			if(hitX > posX && hitX < (posX + sizeX) && hitY > posY && hitY < (posY + sizeY)):
				self.get_parent().queue_free()
