extends CenterContainer

@onready var face = $Control/Face

func update_direction(dir):
	face.rotation = lerp_angle(face.rotation, dir, 0.1)
