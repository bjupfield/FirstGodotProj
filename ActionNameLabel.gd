extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = (self.get_parent().size.x - self.size.x) / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
