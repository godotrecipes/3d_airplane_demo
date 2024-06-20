extends CenterContainer

@onready var hand_large = $Control/HandLarge
@onready var hand_small = $Control/HandSmall

func update_altitude(value):
	var h = fmod(value, 1000) / 1000
	var t = value / 1000.0 / 10.0
	hand_large.rotation = 360 * h
	hand_small.rotation = 360 * t
