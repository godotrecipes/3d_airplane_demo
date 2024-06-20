extends CenterContainer

@onready var indicator = $Control/Indicator

func update_speed(speed, min_speed, max_speed):
	var s = remap(speed, min_speed, max_speed, 35, 240)
	if speed < min_speed:
		s = 30
	indicator.rotation = deg_to_rad(s)
