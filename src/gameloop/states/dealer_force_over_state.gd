class_name DealerForceOverState
extends StateAsync

@export var session: GameSession
@export var monitor: MonitorController
@export var dealer: Dealer
@export var player: Player

func enter_async() -> void:
	session.game_end_reason = GameSession.Reason.KILLED
	player.block()
	monitor.show_game_end()
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await pause(2.0)
	dealer.fire()
	await pause(1.3)
	state_machine.switch_to(GameOverState)

func exit_async() -> void:
	pass
