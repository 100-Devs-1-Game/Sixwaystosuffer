class_name IntroState
extends StateAsync

@export var initial_revolver_position: Node3D
@export var initial_revolver_area3d: ClickableArea3D

@export var dealer: Dealer
@export var player: Player

@export var main_theme_audio: SmoothAudioStreamPlayer
@export var player_patrons: PlayerPatrons

@export var monitor_3d: QueuedMonitor3D

func enter_async() -> void:	
	initial_revolver_area3d.clicked.connect(_on_revolver_clicked)
	initial_revolver_area3d.mouse_entered.connect(_on_revolver_entered)
	initial_revolver_area3d.mouse_exited.connect(_on_revolver_exited)
	_spawn_start_bullets(4)
	take_on_monitor()

func exit_async() -> void:
	initial_revolver_area3d.clicked.disconnect(_on_revolver_clicked)
	initial_revolver_area3d.mouse_entered.disconnect(_on_revolver_entered)
	initial_revolver_area3d.mouse_exited.disconnect(_on_revolver_exited)

func _on_revolver_entered() -> void:
	monitor_3d.push_back("good", ["good"])

func _on_revolver_exited() -> void:
	monitor_3d.pop_back("good")

func _spawn_start_bullets(count: int) -> void:
	var base_patron := load("res://revolver/bullets/patron.tscn")
	for i in count:
		var instance := base_patron.instantiate() as Patron
		player_patrons.add(instance)

func _on_revolver_clicked() -> void:
	main_theme_audio.smooth_play()
	show_intro_on_monitor()
	
	await player.take_revolver_from(initial_revolver_position)
	initial_revolver_position.queue_free()
	
	await player.to_idle()
	state_machine.switch_to(GameplayState)
	
	await pause(1.0)
	dealer.entry()

func take_on_monitor() -> void:
	monitor_3d.push_back("take", ["take"])

func show_intro_on_monitor() -> void:
	monitor_3d.pop_back("take")
	var phrase: Array[String] = ["reach", "999$", "rescued"]
	monitor_3d.push_back("intro", phrase)
