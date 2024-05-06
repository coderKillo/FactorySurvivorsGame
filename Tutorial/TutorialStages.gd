class_name TutorialStages
extends Node2D

const NEXT_STAGE_DELAY := 1.0
const DIALOGE_DURATION := 5.0

enum Stages {
	GREETINGS,
	GREETINGS_2,
	MOVE,
	SHOT,
	KILL,
	GET_ORE,
	BUILD_SMELTER,
	LOAD_ORE,
	GET_MELT,
	LOAD_MELT,
	FINISH
}

enum TutorialEvents {
	GREETING_DONE,
	GREETING_DONE_2,
	PLAYER_MOVED,
	PLAYER_SHOT,
	ENEMY_KILLED,
	ORE_COLLECTED,
	SMELTER_BUILDED,
	SMELTER_LOADED,
	MELT_COLLECTED,
	POWER_PLANT_LOADED,
	NONE
}

signal stage_started(stage: Stages)
signal tutorial_event(event: TutorialEvents)

var _tutorial_gui: TutorialGUI
var _player: Player

var _event_to_wait_for := TutorialEvents.NONE
var _current_stage := 0
var _wait_for_stage := false


func _ready():
	tutorial_event.connect(_on_tutorial_event)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("right_click"):
		match _event_to_wait_for:
			TutorialEvents.GREETING_DONE:
				_next_stage(0.0)
			TutorialEvents.GREETING_DONE_2:
				_next_stage(0.0)


func _input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		tutorial_event.emit(TutorialEvents.PLAYER_SHOT)


func _process(_delta):
	if _player.velocity.length() > 0.0:
		tutorial_event.emit(TutorialEvents.PLAYER_MOVED)

	if _player.resources.ore_amount > 0:
		tutorial_event.emit(TutorialEvents.ORE_COLLECTED)

	if _player.resources.molt_amount > 0:
		tutorial_event.emit(TutorialEvents.MELT_COLLECTED)


func setup(tutorial_gui: TutorialGUI, player: Player) -> void:
	_tutorial_gui = tutorial_gui
	_player = player

	_start_stage()


func _on_tutorial_event(event: TutorialEvents) -> void:
	if _event_to_wait_for == event:
		_next_stage(NEXT_STAGE_DELAY)


func _next_stage(delay: float) -> void:
	if _wait_for_stage:
		return

	_wait_for_stage = true
	await get_tree().create_timer(delay).timeout
	_wait_for_stage = false

	_current_stage += 1
	_start_stage()


func _start_stage() -> void:
	stage_started.emit(_current_stage as Stages)

	_event_to_wait_for = _current_stage as TutorialEvents
	_tutorial_gui.show_text(_get_current_stage_text(), DIALOGE_DURATION)


func _get_current_stage_text() -> String:
	match _current_stage as Stages:
		Stages.GREETINGS:
			return "Alright, Spaceman! Listen up! I ain't here to hold your hand through the cosmos! As part of the best intergalactic mining troop you already know the drill.\n[i](Press [right click] to continue)[/i]"
		Stages.GREETINGS_2:
			return "Before we send you to some godforsaken planet you have complete this basic check. So let's get this over with!\n[i](Press [right click] to continue)[/i]"
		Stages.MOVE:
			return "Spaceman, on your feet! Move like your life depends on it, because out here, it does! Hustle, hustle, hustle!\n[i](Press [W],[A],[S],[D] to move)[/i]"
		Stages.SHOT:
			return "Use your blaster, spaceman! Aim true, shoot straight. Remember, precision over panic!\n[i](Press [left click] to shot)[/i]"
		Stages.KILL:
			return "Target ahead! Neutralize 'em, spaceman! Show no mercy, for it won't show you any!\n"
		Stages.GET_ORE:
			return "Enemy down! Now get to work, spaceman! Extract that ore like your life depends on it!\n[i](Pickaxe will be used automatically when standing close to an enemy)[/i]"
		Stages.BUILD_SMELTER:
			return "Spaceman, time to get crafty! Build those furnaces, and make 'em sturdy! Efficiency is key!\n[i](Press [1] to select the funace and place it with [left click])[/i]"
		Stages.LOAD_ORE:
			return "Ore's ready, spaceman! Don't dilly-dally! Get it into those furnaces, pronto!\n[i](Standing close to the funace will fill it with ore you collected)[/i]"
		Stages.GET_MELT:
			return "Furnaces are hot, spaceman! Extract that molten ore, but watch your hands!\n[i](Standing close to the funace will also fill the molten ore in your tank)[/i]"
		Stages.LOAD_MELT:
			return "Move it, spaceman! Power's waiting! Pour that molten ore into the plant, and keep it steady!\n[i](Standing close to the power plant will fill it with molten ore to produce energy)[/i]"
		Stages.FINISH:
			return "Congratulation, spaceman! Get out there and get it done, because in space, it's them or us. Move out, spaceman!\n[i](Press [Esc] and click 'Quit' to exit the tutorial[/i]"

	return ""
