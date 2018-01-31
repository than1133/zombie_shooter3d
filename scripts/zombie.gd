extends KinematicBody

var hp = 100
var dead_flag = false

var nd_anim_con

func _ready():
	nd_anim_con = get_node("AnimationTreePlayer")
	nd_anim_con.blend2_node_set_amount("idle_to_walk", 1)
	set_physics_process(true)
	
func _physics_process(delta):
	if hp > 0:
		translate(Vector3(0, 0, delta*5))

func _on_Area_body_entered( body ):
	if body.is_in_group("bullet"):
		if hp > 0:
			hp-=25
		else:
			get_parent().set_score()
			get_node("wait_die").start()
			if dead_flag == false:
				get_parent().score+=5
				nd_anim_con.blend3_node_set_amount("blend3", 1)
				nd_anim_con.oneshot_node_start("to_die")
				dead_flag = true
		body.queue_free()

func _on_wait_die_timeout():
	queue_free()
	pass # replace with function body
