extends CharacterBody2D

var movingLeft:bool = false
var movingRight:bool = false
var movingUp:bool = false
var movingDown:bool = false
var climbingKey:bool = false
var distanceToMove:int = 5
var distanceToClimb:int = 6
var playGravity:float = 2

var falling:bool = true
var playerFacingRight:bool = false# direction player is facing to check climbing capability
var playerLastPos:Vector2
var checkClimb:bool = true#check for climb because playerlastpov has been updated
var climable:bool = false
var climbing:bool = false # this is different from the key because we want to know if a player is currently attached to a wall even without running into it
var playerVelocity:Vector2 = Vector2(0,5)
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("Move_Left"):
		movingLeft = true
	elif event.is_action_released("Move_Left"):
		movingLeft = false
	if event.is_action_pressed("Move_Right"):
		movingRight = true
	elif event.is_action_released("Move_Right"):
		movingRight = false
	if event.is_action_pressed("Climb"):
		climbingKey = true
	elif event.is_action_released("Climb"):
		climbingKey = false
	if event.is_action_pressed("Move_Up"):
		movingUp = true
	elif event.is_action_released("Move_Up"):
		movingUp = false
	if event.is_action_pressed("Move_Down"):
		movingDown = true
	elif event.is_action_released("Move_Down"):
		movingDown = false

func _physics_process(delta):
	if movingLeft:
		playerFacingRight = false
	elif movingRight:
		playerFacingRight = true
	if(climbingKey):#player is pressing climbing button check to see if he can climb
		if(checkClimb):
			#print("we here?")
			var scamPos:Vector2 = self.position
			self.position = playerLastPos
			var testColl:KinematicCollision2D = move_and_collide(Vector2(.2 * (1 if playerFacingRight else -1), 0), true, .2, true)
			if(testColl):
				print(testColl.get_collider().name)
				print(testColl.get_normal())
				if(testColl.get_normal().x == (-1 if playerFacingRight else 1)):
					print("HMMM")
					climable = true
				else:
					climable = false
					self.position = scamPos
			else:
				climable = false
				self.position = scamPos
			checkClimb = false #so this doesnt fire every frame
		if(climable):
			climbing = true
		else:
			climbing = false
	else:
		climbing = false
	if climbing:
		playerVelocity.x = 0
		playerVelocity.y = (1 if movingDown else 0) * distanceToClimb + (-1 if movingUp else 0) * distanceToClimb
		print(playerVelocity.y)
	else:
		if falling:#check if the character is falling and then add stuff
			playerVelocity.y += playGravity * delta
		var xmove:float = (1 if movingRight else 0) * distanceToMove + (-1 if movingLeft else 0) * distanceToMove #this checks if the person is pressing left or right input than store in x move
		playerVelocity.x = xmove # apply xmove to player velocity
	var noTrueCollision:bool = true
	var testColl:KinematicCollision2D = move_and_collide(playerVelocity * delta, true, .2, true) # check for collision in player path
	if testColl:
		var normal:Vector2 = testColl.get_normal()
		var collisionPoint:Vector2 = testColl.get_position()
		#print("Colliding: " + str(testColl.get_depth()) + str(self.position) + str(normal) + str(1 if playerVelocity.y > 0 else (-1 if playerVelocity.y < 0 else 0)))
		if (normal.y != 0 && (normal.y + (1 if playerVelocity.y > 0 else (-1 if playerVelocity.y < 0 else 0))) == 0) || (normal.x != 0 && (normal.x + (1 if playerVelocity.x > 0 else (-1 if playerVelocity.x < 0 else 0))) == 0):#checks if block is going into another, if this doesnt trigger it is going out of
			noTrueCollision = false
			if normal.y == -1:
				var yPosBottom:int = round((self.get_child(1).shape.get_rect().size.y / 2) + self.get_child(1).position.y + self.position.y)
				var yPosDiff:int = collisionPoint.y - yPosBottom
				self.position.y = yPosDiff + round(self.position.y)
				self.position.x += playerVelocity.x * delta
				#falling = false
				playerVelocity.y = 0
				#if y collides set position to pixel above y collision, and set falling to false and player velocity to 0
			elif normal.x == -1 || normal.x == 1:
				var xPosBottom:int = (self.get_child(1).shape.get_rect().size.x / 2) + self.get_child(1).position.x + self.position.x
				var xPosDiff:int = collisionPoint.x - xPosBottom
				self.position.x = xPosDiff + int(self.position.x)
				self.position.y += velocity.y * delta
				#basically same as for y, set it equal to pxiel right outside range, and then check if climbing is true
			elif normal.y == 1:
				print("Hi2")
	if noTrueCollision:
		self.position += playerVelocity * delta
	if !playerLastPos || playerLastPos != Vector2(int(self.position.x), int(self.position.y)):
		#print("Update Pos")
		playerLastPos = Vector2(int(self.position.x), int(self.position.y))
		checkClimb = true
