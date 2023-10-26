extends RichTextLabel

var assigning: bool = false
var upButtonAmount: int = 0
# Called when the node enters the scene tree for the first time.
func _input(event):
	if(assigning and str(event.get_class()) != "InputEventMouseMotion"):
		if(event is InputEventMouseButton):
			if(event.button_index == MOUSE_BUTTON_LEFT):
				if(!event.pressed):
					if(upButtonAmount > 0):
						self.text = str(upButtonAmount)
						assigning = false
					upButtonAmount += 1
			else:
				self.text = event.as_text()
				assigning = false
				upButtonAmount = 0
		else:
			self.text = event.as_text()
			assigning = false
	else:
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			var posY: int = self.position.y
			var posX: int = self.position.x
			var sizeY: int = self.size.y
			var sizeX: int = self.size.x
			var hitX: int = event.position.x
			var hitY: int = event.position.y
			if(hitX > posX && hitX < (posX + sizeX) && hitY > posY && hitY < (posY + sizeY)):
				self.text = "EnterInput"
				assigning = true
				upButtonAmount = 0
	pass
