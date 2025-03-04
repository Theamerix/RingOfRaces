extends CharacterBody2D

var speed = 500.0

# Basic player logic
func _physics_process(delta):
	var direction = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	var velocity = (direction * speed + Vector2.DOWN * 98)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
