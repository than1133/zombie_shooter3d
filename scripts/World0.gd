extends Spatial

var game_start = false
var wave_ready = false
var live = 100
var score = 0
var time_spawn = 3
var enemy_spawns = []
var enemys = 0

# Node Member
var nd_count_next_wave
var nd_label_count_next_wave

func _ready():
	nd_count_next_wave = get_node("count_next_wave")
	nd_label_count_next_wave = get_node("GUI/in_game/WaitWaveCountDown")
	get_node("snd_intro").play()
	for x in get_node("enemy_spawns").get_children():
		enemy_spawns.append(x.translation)
		
	set_physics_process(true)
	
func _physics_process(delta):
	print(str(time_spawn))
	nd_label_count_next_wave.text = str(int(nd_count_next_wave.get_time_left()))
	if wave_ready:
		if get_node("zom_spawn_time").get_time_left() <= 0:
			randomize()
			var rand = rand_range(0, 4)
			var zombie = preload("res://characters/zombie.tscn").instance()
			zombie.translation = enemy_spawns[rand]
			zombie.rotation_degrees.y = 180
			add_child(zombie)
			if time_spawn > 1:
				time_spawn-=0.01
			get_node("zom_spawn_time").wait_time = time_spawn
			get_node("zom_spawn_time").start()

func _on_Start_pressed():
	get_node("Player").player_start()
	game_start = true
	get_node("snd_intro").stop()
	get_node("snd_in_game").play()
	get_node("GUI/title").hide()
	get_node("GUI/in_game").show()
	nd_count_next_wave.start()
	nd_label_count_next_wave.show()
	Input.set_mouse_mode(2)
	
func _on_Quit_pressed():
	get_tree().quit()


func _on_count_next_wave_timeout():
	wave_ready = true
	nd_label_count_next_wave.hide()


func _on_Area_body_entered( body ):
	if body.is_in_group("zombie"):
		live-=10
		if live <=0:
			get_node("GUI/in_game").hide()
			get_node("GUI/GameOver").show()
			get_node("GUI/GameOver/your_score").text = "YOUR SCORE : "+str(score)
			Input.set_mouse_mode(0)
			get_tree().set_pause(true)
		set_live()
		delete_zombie(body)
		
func delete_zombie(zombie):
	zombie.queue_free()

func set_live():
	get_node("GUI/in_game/VBoxContainer/Live").text = "LIVE : "+str(live)
	
func set_score():
	get_node("GUI/in_game/VBoxContainer/Score").text = "SCORE : "+str(score)

func _on_Button_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://scenes/World0.tscn")
	pass # replace with function body
