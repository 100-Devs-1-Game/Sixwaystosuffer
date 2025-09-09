class_name SelectTargetState
extends State

@export var dealer_label: TableLabel
@export var self_label: TableLabel

@export var dealer: Dealer
@export var player: Player

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		return_to_select_target()

func enter() -> void:
	show_labels()

func exit() -> void:
	hide_labels()

func show_labels() -> void:
	dealer_label.smooth_show()
	self_label.smooth_show()
	
	dealer_label.clicked.connect(_on_dealer_clicked)
	self_label.clicked.connect(_on_self_clicked)

func hide_labels() -> void:
	dealer_label.smooth_hide()
	self_label.smooth_hide()
	
	dealer_label.clicked.disconnect(_on_dealer_clicked)
	self_label.clicked.disconnect(_on_self_clicked)

func _on_dealer_clicked() -> void:
	hide_labels()
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await player.to_target_aiming()

func _on_self_clicked() -> void:
	hide_labels()
	dealer.change_face(Dealer.DealerFace.HYPED_TEETH)
	await player.to_self_aiming()

func return_to_select_target() -> void:
	show_labels()
	dealer.change_face(Dealer.DealerFace.HYPED)
	await player.to_idle()
