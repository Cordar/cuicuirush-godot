extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("collectible")


func body_entered(body):
	print("entered")
	if body.is_in_group("player"):
		print("collected")
		queue_free()
