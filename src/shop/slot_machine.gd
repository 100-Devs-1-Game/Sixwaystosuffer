class_name SlotMachine
extends Node3D

@export var ammo: PlayerPatrons
@export var session: GameSession
@export var products: Array[ShopProduct]

@onready var clickable_lever: ClickableArea3D = %ClickableLever
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var slot_machine_animation_player: AnimationPlayer = %"Slot Machine AnimationPlayer"

@onready var slot_spinner: SlotSpinner = %"Slot Spinner"
@onready var box_spawner: BoxSpawner = %BoxSpawner
@onready var clickable_area_3d: ClickableArea3D = $ClickableArea3D

@onready var spot_light_3d: SpotLight3D = $SpotLight3D


var is_working: bool

func _ready() -> void:
	clickable_lever.mouse_entered.connect(_on_lever_entered)
	clickable_lever.mouse_exited.connect(_on_lever_entered)
	
	clickable_lever.clicked.connect(_on_lever_clicked)
	slot_spinner.done.connect(_on_slots_done)

func enable() -> void:
	clickable_lever.enable()

func disable() -> void:
	clickable_lever.disable()
	box_spawner.close()

func smooth_light_on() -> void:
	create_tween().tween_property(spot_light_3d, "light_energy", 1.0, 0.3)

func smooth_light_off() -> void:
	create_tween().tween_property(spot_light_3d, "light_energy", 0.0, 0.3)

func _on_lever_entered() -> void:
	if is_working:
		return
	
	animation_player.play("hover")

func _on_lever_clicked() -> void:
	is_working = true
	clickable_lever.disable()
	animation_player.play("use")
	box_spawner.close()

func start_spin() -> void:
	slot_spinner.spin()
	slot_machine_animation_player.play("work")
	slot_machine_animation_player.speed_scale = 1.0
	
	var tween := create_tween()
	tween.tween_property(slot_machine_animation_player, "speed_scale", 0, slot_spinner.max_duration)

func _on_slots_done() -> void:
	open_items()
	slot_machine_animation_player.play("idle")
	box_spawner.clear_items()
	box_spawner.spawn_items(products)

func open_items() -> void:
	#animation_player.play("open")
	box_spawner.open()
	is_working = false
	clickable_lever.enable()

func open_boxes() -> void:
	#box_spawner.open()
	#is_working = false
	#clickable_lever.enable()
	pass

func spawn_items() -> void:
	box_spawner.spawn_items(products)

func purchase(product: ShopProduct) -> void:
	if product is BulletProduct:
		purchase_bullet(product)

func purchase_bullet(product: BulletProduct) -> void:
	print("available space: %s" % ammo.get_available_space())
	session.make_purchase(product.cost)
	
	for i in product.quantity:
		# TODO: make animation?
		var instance = product.scene.instantiate()
		ammo.add(instance)
	
	print("purchased success")
