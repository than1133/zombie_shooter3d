extends Spatial

var rot_speed = 0.1

func _ready():
	set_physics_process(true)
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseMotion and get_node("../").game_start == true:
		var rot_y = rotation_degrees.y
		rot_y -= event.relative.x*rot_speed
		rot_y = clamp(rot_y, -60, 60)
		rotation_degrees.y = rot_y

func _physics_process(delta):
	var shoot = Input.is_action_pressed("shoot")
	if get_parent().wave_ready == true:
		if shoot:
			get_node("AnimationTreePlayer").blend2_node_set_amount("wait_to_shoot", 1)
			if get_node("shoot_delay").get_time_left() <= 0:
				var bullet = preload("res://objects/bullet.tscn").instance()
				bullet.set_transform(get_node("fire").get_global_transform())
				get_node("../").add_child(bullet)
				get_node("shoot_delay").start()
			get_node("fire").show()
			if !get_node("snd_shoot").is_playing():
				get_node("snd_shoot").play()
			if !get_node("cam_anim").is_playing():
				get_node("cam_anim").play("can_shake")
		else:
			get_node("cam_anim").stop()
			get_node("AnimationTreePlayer").blend2_node_set_amount("wait_to_shoot", 0)
			get_node("snd_shoot").stop() 
			get_node("fire").hide()
	
func player_start():
	get_node("cam_anim").play("play_cam")
	get_node("AnimationTreePlayer").blend2_node_set_amount("idle_to_wait", 1)
