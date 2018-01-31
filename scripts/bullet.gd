extends KinematicBody

var bullet_speed = 100

func _ready():
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	translate(Vector3(-bullet_speed*delta, 0, 0))
	if get_node("dead_time").get_time_left() <= 0:
		queue_free()
