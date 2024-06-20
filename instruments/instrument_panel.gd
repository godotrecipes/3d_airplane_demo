extends Control

#@export var plane_path : NodePath
#@onready var plane = get_node(plane_path)
@export var plane : CharacterBody3D

@onready var attitude = $PanelContainer/MarginContainer/HBoxContainer/AttitudeIndicator
@onready var altimeter = $PanelContainer/MarginContainer/HBoxContainer/Altimeter
@onready var compass = $PanelContainer/MarginContainer/HBoxContainer/Compass
@onready var airspeed = $PanelContainer/MarginContainer/HBoxContainer/Airspeed

func _process(delta):
	var pitch = plane.rotation.x
	var roll = plane.mesh.rotation.z
	attitude.update_pitch(pitch)
	attitude.update_roll(roll)
	altimeter.update_altitude(plane.position.y)
	compass.update_direction(plane.rotation.y)
	airspeed.update_speed(plane.forward_speed, plane.min_flight_speed, plane.max_flight_speed)
