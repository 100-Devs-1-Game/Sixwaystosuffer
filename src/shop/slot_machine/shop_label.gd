class_name ShopLabel
extends Node

@export var slot_machine: SlotMachine
@export var digital: Label3D
@export var error_digital: ErrorLabel3D
@export var spawner: BoxSpawner
@export var spinner: SlotSpinner
@export var lever: ClickableArea3D
@export var block_timer: Timer

var base_text: String = "[SLOT_WELCOME]"

var is_blocked: bool = false

func _ready() -> void:
	spawner.hovered.connect(_on_box_hovered)
	spawner.unhovered.connect(_on_box_unhovered)
	spawner.clicked.connect(_on_box_clicked)
	lever.mouse_entered.connect(_on_lever_entered)
	lever.mouse_exited.connect(_on_lever_exited)
	spinner.started.connect(_on_roll_started)
	spinner.done.connect(_on_roll_done)
	block_timer.timeout.connect(_on_block_timeout)
	digital.text = base_text

func block(duration: float = 0.5) -> void:
	is_blocked = true
	block_timer.start(duration)

func _on_block_timeout() -> void:
	is_blocked = false

func clear() -> void:
	base_text = "[SLOT_WELCOME]"

func show_not_enough() -> void:
	error_digital.alert()
	try_change_text("[SLOT_NOT_MONEY]")

func show_capacity_reached() -> void:
	base_text = "[SLOT_CAPACITY_REACHED]"
	error_digital.alert()
	try_change_text(base_text)

func _on_box_hovered(box: ShopBox) -> void:
	var product := box.product
	digital.text = product.description

func _on_box_unhovered(_box: ShopBox) -> void:
	digital.text = base_text

func _on_box_clicked(_box: ShopBox) -> void:
	try_change_text("[SLOT_SURE]")

func _on_lever_entered() -> void:
	var line := tr("[SLOT_ROLL_PRICE]") % slot_machine.session.reroll_price
	try_change_text(line)

func _on_lever_exited() -> void:
	digital.text = base_text

func _on_roll_started() -> void:
	try_change_text("[SLOT_WAIT]")

func _on_roll_done() -> void:
	base_text = "[SLOT_CHOOSE]"
	try_change_text(base_text)

func try_change_text(text: String) -> bool:
	if is_blocked:
		return false
	
	digital.text = text
	return true
