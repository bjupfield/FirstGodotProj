extends CharacterBody2D

var movingLeft: bool = false
var movingRight: bool = false
var distanceToMove: int = 5
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("Move_Left"):
		movingLeft = true
	if event.is_action_released("Move_Left"):
		movingLeft = false
	if event.is_action_pressed("Move_Right"):
		movingRight = true
	if event.is_action_released("Move_Right"):
		movingRight = false

func _physics_process(delta):
	var xmove:float = (1 if movingLeft else 0) * distanceToMove + (-1 if movingRight else 0) * distanceToMove
	var move:Vector2 = Vector2(xmove, 0)
	#self.position.x += (1 if movingLeft else 0) * distanceToMove + (-1 if movingRight else 0) * distanceToMove
	var collisionStuff:KinematicCollision2D = move_and_collide(move * distanceToMove * delta)
	if collisionStuff:
		print(collisionStuff.get_normal())
		print(collisionStuff.get_collider().get("name"))# this shows that we are actually retrieviing the class instance, not just the class
