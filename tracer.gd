extends Area3D

var speed = 150
var velocity = Vector3.ZERO

func start(xform, _speed):
	transform = xform
	velocity = -transform.basis.z * (speed + _speed)

func _physics_process(delta):
	position += velocity * delta


func _on_lifetime_timeout():
	queue_free()


func _on_body_entered(body):
	queue_free()
