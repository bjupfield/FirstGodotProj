extends ColorRect

var actionStrings
# Called when the node enters the scene tree for the first time.
func _ready():
	actionStrings = InputMap.get_actions()
	actionStrings = actionStrings.filter(func(action): return action.left(1).to_upper() == action.left(1))
	var actionAmount:int = actionStrings.size()
	#var childerer:Resource = ResourceLoader.load("res://GameObjects/TextEditorForKeyBinding.tscn")
	#var childer:Node = childerer.instantiate()
	#self.add_child(childer)
	var xPos:int = self.size.x / 2 # this is middle of body
	var yChange:float = 60
	for i in actionAmount:
		var childerer:Resource = ResourceLoader.load("res://GameObjects/TextEditorForKeyBinding.tscn")
		var childer:Node = childerer.instantiate()
		self.add_child(childer)
		var posshancge = self.get_child(self.get_child_count() - 1)
		posshancge.position.x = xPos
		posshancge.position.y = (i + 1) * yChange
		posshancge.text = actionStrings[i]
		posshancge.eventName = actionStrings[i]
		
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
