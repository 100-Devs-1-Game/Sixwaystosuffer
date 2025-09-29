class_name ReloadMobileUI
extends PanelContainer

const BULLET_BUTTON_SCENE := preload("res://player/hud/mobile/bullet_button.tscn")

@export var player: Player
@export var state_machine: StateMachine
@export var revolver: Revolver
@export var bullet_pickup: BulletPickup

@onready var unload_button: Button = %"Unload Button"
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var bullets_container: VBoxContainer = %"Bullets Container"

func _ready() -> void:
	scroll_container.get_v_scroll_bar().custom_minimum_size.x = 20
	

func initialize() -> void:
	unload_button.pressed.connect(_on_unload_pressed)
	player.bullets.updated.connect(_on_ammo_updated)
	state_machine.processing_started.connect(_on_processing_started)
	state_machine.state_entered.connect(_on_state_entered)


func _physics_process(_delta: float) -> void:
	unload_button.visible = not revolver.chamber.is_hovered_position_empty()

func _on_processing_started(_target: GDScript) -> void:
	hide()

func _on_state_entered(target: GDScript) -> void:
	if target == PlayerReloadRevolverState:
		show()

func _on_unload_pressed() -> void:
	bullet_pickup.unload_bullet(revolver.get_hovered_bullet())

func _on_ammo_updated() -> void:
	for instance in bullets_container.get_children():
		instance.queue_free()
	
	fetch_bullets()

func fetch_bullets() -> void:
	for bullet in player.bullets.bullets:
		if bullet == null:
			continue
		
		var instance: BulletButton = BULLET_BUTTON_SCENE.instantiate()
		bullets_container.add_child(instance)
		instance.bullet = bullet
		instance.text = "Bullet %s" % bullet.get_description()
		instance.pressed.connect(_on_bullet_button_pressed.bind(instance))

func _on_bullet_button_pressed(button: BulletButton) -> void:
	bullet_pickup.load_bullet(button.bullet)
