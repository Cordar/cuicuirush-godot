extends CharacterBody3D


const SPEED = 3.0
var current_lane: int = 1
var left_lane_pos: float = -2.5
var right_lane_pos: float = 2.5
var center_lane_pos: float = 0
var vertical_force: float = 0.0

func _ready():
	add_to_group("player")

func _input(event):
	if event.is_action_pressed("jump"):
		print("Input event jump")
		vertical_force = 2.0
	if event.is_action_pressed("left"):
		print("Input event left")
		current_lane = max(0, current_lane - 1)
		print(current_lane)
	if event.is_action_pressed("right"):
		print("Input event right")
		current_lane = min(2, current_lane + 1)
	if event.is_action_pressed("slide"):
		pass

func get_lane_position():
	if current_lane == 0:
		return left_lane_pos
	elif current_lane == 1:
		return center_lane_pos
	elif current_lane == 2:
		return right_lane_pos


func _physics_process(delta):
	transform.origin.x = lerp(transform.origin.x, get_lane_position(), SPEED * delta)
	transform.origin.x = clamp(transform.origin.x, -1.5, 1.5)

	# jump and slowly lerp the player back towards the ground
	vertical_force = lerp(vertical_force, -3.0, 2.0 * delta)
	
	transform.origin.y += vertical_force
	transform.origin.y = clamp(transform.origin.y, 1.1, 5)

	# simulate gravity
	if global_transform.origin.y > 0:
		global_transform.origin.y -= delta * 10.0

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		on_collision(collision_info.get_collider())

func on_collision(body):
	print("Collision")
	if body.is_in_group("obstacle"):
		print("Obstacle collision")
		get_tree().quit()
