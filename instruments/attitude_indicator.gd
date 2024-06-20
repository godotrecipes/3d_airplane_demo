extends CenterContainer

@onready var mask = $Control/Mask
@onready var inner = $Control/Mask/Inner
@onready var marker = $Control/TopMarker

func update_roll(angle):
	mask.rotation = -angle# * 60
	marker.rotation = -angle
	
func update_pitch(angle):
	var shift = -angle * 110
	inner.texture.region.position.y = shift
