class_name DealerForceOverState
extends StateAsync

@export var monitor: MonitorController
@export var dealer: Dealer

func enter_async() -> void:
	monitor.show_game_end()
	dealer.change_face(Dealer.DealerFace.SAD)
	pass

func exit_async() -> void:
	pass
