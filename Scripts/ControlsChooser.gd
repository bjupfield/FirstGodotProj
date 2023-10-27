extends ColorRect

var actionStrings
# Called when the node enters the scene tree for the first time.
func _ready():
	actionStrings = InputMap.get_actions() #this returns a collection of strings
	actionStrings = actionStrings.filter(func(action): return action.left(1).to_upper() == action.left(1))#this sorts them so that only ones with 
	var actionAmount:int = actionStrings.size()

	var xPos:int = self.size.x / 2 # this is middle of body
	var yChange:float = 60
	for i in actionAmount:
		var textEditor:Resource = ResourceLoader.load("res://GameObjects/TextEditorForKeyBinding.tscn") # to load a resource you have to do this
		var textEditorAsNode:Node = textEditor.instantiate() # to add resource you must instantiate it, for some reason it turns it to a node
		self.add_child(textEditorAsNode) # this adds the resource as a child to an object, in this case self
		var posshancge = self.get_child(self.get_child_count() - 1)#dumbass way to get last added child
		posshancge.position.x = xPos
		posshancge.position.y = (i + 1) * yChange
		InputMap.get
		posshancge.eventName = actionStrings[i]
		var inputType = InputMap.action_get_events(actionStrings[i])
		if inputType.size() == 0:
			posshancge.text = "Enter A Default Action"
		elif inputType.size() == 1:
			posshancge.text = inputType[0].as_text().left(max(inputType[0].as_text().find("("), 2))
			posshancge.assignedKey = inputType[0]
			posshancge.keyGood = true
		else:
			posshancge.text = "Too Many Default Actions"
		var plainText:Resource = ResourceLoader.load("res://GameObjects/ActionNameLabel.tscn")
		var plainTextAsNode:Node = plainText.instantiate()
		plainTextAsNode.text = actionStrings[i]
		self.add_child(plainTextAsNode)
		posshancge = self.get_child(self.get_child_count() - 1)
		posshancge.position.x = xPos - posshancge.size.x
		posshancge.position.y = (i + 1) * yChange
		
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
