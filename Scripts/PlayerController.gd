extends CharacterBody2D

var movingLeft:bool = false
var movingRight:bool = false
var movingUp:bool = false
var movingDown:bool = false
var climbingKey:bool = false
var jump:bool = false
var distanceToMove:int = 5
var distanceToClimb:int = 6
var playGravity:float = 2
var jumpAmount:float = 10

var falling:bool = true
var playerFacingRight:bool = false# direction player is facing to check climbing capability
var playerLastPos:Vector2
var posChanged:bool = true#check for climb because playerlastpov has been updated
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
	if event.is_action_pressed("Jump"):
		jump = true
	elif event.is_action_released("Jump"):
		jump = false

func _physics_process(delta):
	if movingLeft:
		playerFacingRight = false
	elif movingRight:
		playerFacingRight = true
	var jumping:bool = false
	var wallJump:int = 0
	if(jump):
		if(posChanged):
			#block has change by an int value
			var scamPos:Vector2 = self.position
			self.position = playerLastPos
			var testColl:KinematicCollision2D = move_and_collide(Vector2(0, .2), true, .2, true)
			if(testColl):
				if(testColl.get_normal().y == -1):
					print("HITHERE" + str(scamPos))
					jumping = true
					posChanged = false
					#check for block underneath player, if so we set it to standard jump
				else:
					self.position = scamPos
			else:
				self.position = scamPos
				
	if((climbingKey || jump) && !jumping):#player is pressing climbing button check to see if he can climb
		print("climbcheck")
		if(posChanged):
			#block has changed by int value
			var scamPos:Vector2 = self.position
			self.position = playerLastPos
			var testColl:KinematicCollision2D = move_and_collide(Vector2(.5 * (1 if playerFacingRight else -1), 0), true, .2, true)
			print((1 if playerFacingRight else -1))
			if(testColl):
				if(testColl.get_normal().x == (-1 if playerFacingRight else 1)):
					print("collision climb")
					if(jump):#if we jump or jump and climb we do a jump,this checks for wall jumps spcefically
						jumping = true
						wallJump = 1 if playerFacingRight else -1
						self.position = scamPos
						#check for block in direction that the player is facing if get hit set equal to true and give walljump 1 for right side and -1 for left side
					else:
						print("climbing true")
						climable = true
						#check for blcok in direction set climable to true if jump is not set tot true
				else:
					climable = false
					self.position = scamPos
			else:
				climable = false
				self.position = scamPos
			posChanged = false #so this doesnt fire every frame
		if(climable):
			climbing = true
		else:
			climbing = false
	else:
		climbing = false
	if jumping:
		playerVelocity.y = -jumpAmount
		climbing = false
		var xmove:float = playerVelocity.x #this checks if the person is pressing left or right input than store in x move
		if(wallJump == -1):
			xmove = 10
		elif(wallJump == 1):
			xmove = -10
		else:
			if movingRight && !movingLeft:
				xmove = min(distanceToMove * delta + playerVelocity.x, distanceToMove)
			elif movingLeft && !movingRight:
				xmove = max(-distanceToMove * delta + playerVelocity.x, -distanceToMove) #this checks if the person is pressing left or right input than store in x move
		playerVelocity.x = xmove
	elif climbing:
		playerVelocity.x = 0
		playerVelocity.y = (1 if movingDown else 0) * distanceToClimb + (-1 if movingUp else 0) * distanceToClimb
		print("Climbing")
	else:
		if falling:#check if the character is falling and then add stuff
			playerVelocity.y += playGravity * delta
		var xmove:float = playerVelocity.x
		if movingRight && !movingLeft:
			xmove = min(distanceToMove * delta + xmove, distanceToMove)
		elif movingLeft && !movingRight:
			xmove = max(-distanceToMove * delta + xmove, -distanceToMove)
		playerVelocity.x = xmove # apply xmove to player velocity
	var noYTrueCollision:bool = true
	var noXTrueCollision:bool = true
	if(playerVelocity.y != 0):
		var testYColl:KinematicCollision2D = move_and_collide(Vector2(0, playerVelocity.y) * delta, true, .2, true) # check for collision in player path
		if testYColl:
			var normal:Vector2 = testYColl.get_normal()
			var collisionPoint:Vector2 = testYColl.get_position()
			#print("Colliding: " + str(testColl.get_depth()) + str(self.position) + str(normal) + str(1 if playerVelocity.y > 0 else (-1 if playerVelocity.y < 0 else 0)) + "Veloc: " + str(playerVelocity.y))
			if (normal.y != 0 && (normal.y + (1 if playerVelocity.y > 0 else (-1 if playerVelocity.y < 0 else 0))) == 0) :#checks if block is going into another, if this doesnt trigger it is going out of
				noYTrueCollision = false
				#if normal.y == -1:
				var yPosBottom:int = round((self.get_child(1).shape.get_rect().size.y / 2) * -normal.y + self.get_child(1).position.y + self.position.y)
				var yPosDiff:int = collisionPoint.y - yPosBottom
				self.position.y = yPosDiff + round(self.position.y)
					#falling = false
				playerVelocity.y = 0
					#if y collides set position to pixel above y collision, and set falling to false and player velocity to 0
				#elif normal.y == 1:
				#	print("Hi2")
	if(playerVelocity.x != 0):
		var testXColl:KinematicCollision2D = move_and_collide(Vector2(playerVelocity.x, 0) * delta, true, .2, true)
		if testXColl:
			var normal:Vector2 = testXColl.get_normal()
			var collisionPoint:Vector2 = testXColl.get_position()
			if (normal.x != 0 && (normal.x + (1 if playerVelocity.x > 0 else (-1 if playerVelocity.x < 0 else 0)) == 0)):
				noXTrueCollision = false
				var xPosBottom:int = round((self.get_child(1).shape.get_rect().size.x / 2) * -normal.x + self.get_child(1).position.x + self.position.x)
				var xPosDiff:int = collisionPoint.x - xPosBottom
				
				self.position.x = xPosDiff + round(self.position.x)
				playerVelocity.x = 0
				#basically same as for y, set it equal to pxiel right outside range, and then check if climbing is true
	if noYTrueCollision:# have to check both because it wont do it for both lol...
		self.position.y += playerVelocity.y * delta
		if(jumping):
			print("Hi there")
	if noXTrueCollision:
		self.position.x += playerVelocity.x * delta
		
	if !playerLastPos || playerLastPos != Vector2(int(self.position.x), int(self.position.y)):
		#print("Update Pos")
		playerLastPos = Vector2(int(self.position.x), int(self.position.y))
		posChanged = true
	#print("Pos" + str(self.position))
