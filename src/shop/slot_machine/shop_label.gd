class_name ShopLabel
extends Node

@export var slot_machine: SlotMachine
@export var digital: Label3D
@export var spawner: BoxSpawner
@export var spinner: SlotSpinner
@export var lever: ClickableArea3D

var base_text: String = "[SLOT_WELCOME]"

func _ready() -> void:
	spawner.hovered.connect(_on_box_hovered)
	spawner.unhovered.connect(_on_box_unhovered)
	spawner.clicked.connect(_on_box_clicked)
	lever.mouse_entered.connect(_on_lever_entered)
	lever.mouse_exited.connect(_on_lever_exited)
	spinner.started.connect(_on_roll_started)
	spinner.done.connect(_on_roll_done)
	digital.text = base_text

func clear() -> void:
	base_text = "[SLOT_WELCOME]"

func _on_box_hovered(box: ShopBox) -> void:
	var product := box.product
	digital.text = product.description

func _on_box_unhovered(_box: ShopBox) -> void:
	digital.text = base_text

func _on_box_clicked(_box: ShopBox) -> void:
	digital.text = "[SLOT_SURE]"

func _on_lever_entered() -> void:
	digital.text = tr("[SLOT_ROLL_PRICE]") % slot_machine.session.reroll_price

func _on_lever_exited() -> void:
	digital.text = base_text

func _on_roll_started() -> void:
	digital.text = "[SLOT_WAIT]"

func _on_roll_done() -> void:
	base_text = "[SLOT_CHOOSE]"
	digital.text = base_text
