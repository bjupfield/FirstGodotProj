extends RichTextLabel

var eventName: String = ""
var assigning: bool = false
var upButtonAmount: int = 0
# Called when the node enters the scene tree for the first time.
func _input(event):
	if(assigning and str(event.get_class()) != "InputEventMouseMotion" and (event.as_text() != "Left Mouse Button" or (event is InputEventMouseButton and event.pressed and upButtonAmount > 0))):
		assigning = false
		upButtonAmount = 0
		self.text = "|" + event.as_text() + "|"
		InputMap.action_add_event(eventName, event)
	else:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and !assigning:
				var posY: int = self.get_screen_position().y
				var posX: int = self.get_screen_position().x
				var sizeY: int = self.size.y
				var sizeX: int = self.size.x
				var hitX: int = event.position.x
				var hitY: int = event.position.y 
				if(hitX > posX && hitX < (posX + sizeX) && hitY > posY && hitY < (posY + sizeY)): #checks if mouse hit is inside the assigned thing
					self.text = "EnterInput"
					assigning = true
					upButtonAmount = 0
			elif event.button_index == MOUSE_BUTTON_LEFT and assigning and !event.pressed:
				upButtonAmount += 1;
	pass
