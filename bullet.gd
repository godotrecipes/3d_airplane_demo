extends Area3D

var velocity = Vector3.ZERO
var speed = 20.0

func start(xform, _speed):
	transform = xform
	velocity = -transform.basis.z * (speed + _speed)

func _physics_process(delta):
	position += velocity * delta


func _on_body_entered(body):
	print("hit ", body.name)
	queue_free()


func _on_lifetime_timeout():
	queue_free()
