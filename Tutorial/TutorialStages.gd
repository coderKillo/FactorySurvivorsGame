class_name TutorialStages
extends Node2D

const NEXT_STAGE_DELAY := 1.0
const DIALOGE_DURATION := 5.0

enum Stages {
	GREETINGS_1,
	GREETINGS_2,
	MOVE,
	SHOT,
	PLACE_BOMB,
	PULL_CART,
	PUSH_CART,
	KILL_ENEMY,
	MINING,
	COLLECT_ORE,
	BUILD_MODE,
	PLACE_SMELTER,
	PLACE_POWER_PLANT,
	PLACE_PIPE,
	FILL_SMELTER,
	OUTRO_1,
	OUTRO_2,
}

enum TutorialEvents {
	GREETINGS_1_DONE,
	GREETINGS_2_DONE,
	MOVEMENT_KEY_PRESSED,
	FIRE_PRESSED,
	BOMB_EXPLODED,
	CART_PULLED,
	CART_PUSHED,
	ENEMY_DIED,
	ORE_EXTRACTED,
	ORE_COLLECTED,
	BUILD_MODE_ACTIVATE,
	SMELTER_PLACED,
	POWER_PLANT_PLACED,
	SMELTER_CONNECTED,
	SMELTER_LOADED,
	OUTRO_1_DONE,
	NONE,
}

signal stage_started(stage: Stages)
signal tutorial_event(event: TutorialEvents)

var _tutorial_gui: TutorialGUI
var _entity_tracker: EntityTracker
var _player: Player
var _cart: Minecart
var _drag_objects: DragObjects
var _event_to_wait_for := TutorialEvents.NONE
var _current_stage := 0
var _wait_for_stage := false


func _ready():
	tutorial_event.connect(_on_tutorial_event)
	Events.bomb_explode.connect(_on_bomb_explode)
	Events.build_mode_changed.connect(_on_build_mode_changed)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("continue"):
		if _tutorial_gui.text_full_visable():
			match _event_to_wait_for:
				TutorialEvents.GREETINGS_1_DONE:
					_next_stage(0.0)
				TutorialEvents.GREETINGS_2_DONE:
					_next_stage(0.0)
				TutorialEvents.OUTRO_1_DONE:
					_next_stage(0.0)


func _input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		tutorial_event.emit(TutorialEvents.FIRE_PRESSED)


func _process(_delta):
	if _player.velocity.length() > 0.0:
		tutorial_event.emit(TutorialEvents.MOVEMENT_KEY_PRESSED)

	if _cart.resources.ore_amount > 0:
		tutorial_event.emit(TutorialEvents.ORE_COLLECTED)

	if _drag_objects.is_graped:
		tutorial_event.emit(TutorialEvents.CART_PULLED)

	# this is also true before the cart is pulled, but because the pulled state comes before the push state its fine
	if not _drag_objects.is_graped:
		tutorial_event.emit(TutorialEvents.CART_PUSHED)

	if "Smelter" in _entity_tracker.blocked_cells.values():
		tutorial_event.emit(TutorialEvents.SMELTER_PLACED)

	if "PowerPlant" in _entity_tracker.blocked_cells.values():
		tutorial_event.emit(TutorialEvents.POWER_PLANT_PLACED)


func setup(
	tutorial_gui: TutorialGUI,
	entity_tracker: EntityTracker,
	pipe_system: PipeSystem,
	player: Player,
	cart: Minecart
) -> void:
	_tutorial_gui = tutorial_gui
	_entity_tracker = entity_tracker
	_player = player
	_cart = cart
	_drag_objects = player.get_node("DragObjects")

	pipe_system._paths.paths_changed.connect(_on_pipe_path_changed)
	_start_stage()


func _on_tutorial_event(event: TutorialEvents) -> void:
	if _event_to_wait_for == event:
		_next_stage(NEXT_STAGE_DELAY)


func _on_bomb_explode(_pos: Vector2) -> void:
	tutorial_event.emit(TutorialEvents.BOMB_EXPLODED)


func _on_build_mode_changed(mode: BuildModeManager.GameMode) -> void:
	if mode == BuildModeManager.GameMode.BUILD_MODE:
		tutorial_event.emit(TutorialEvents.BUILD_MODE_ACTIVATE)


func _on_pipe_path_changed() -> void:
	tutorial_event.emit(TutorialEvents.SMELTER_CONNECTED)


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
		Stages.GREETINGS_1:
			return "Alright, Spaceman! Listen up! I ain't here to hold your hand through the cosmos! As part of the best intergalactic mining troop you already know the drill.\n[i](Press [space] to continue)[/i]"
		Stages.GREETINGS_2:
			return "Before we send you to some godforsaken planet you have complete this basic check. So let's get this over with!\n[i](Press [space] to continue)[/i]"
		Stages.MOVE:
			return "Spaceman, on your feet! Move like your life depends on it, because out here, it does! Hustle, hustle, hustle!\n[i](Press [W],[A],[S],[D] to move)[/i]"
		Stages.SHOT:
			return "Your blaster's your best friend, spaceman! Treat it like your girlfriend. Keep it close and use it well!!\n[i](Press [left click] to shot)[/i]"
		Stages.PLACE_BOMB:
			return "Got a big enemy group? Bombs away! But don't be stupid, blow them up, not yourself!\n[i](Press [F] to place a bomb[/i])"
		Stages.KILL_ENEMY:
			return "Enemies are just ore with legs! Kill 'em all! That's why we're here! Show no mercy, for it won't show you any!"
		Stages.MINING:
			return "Get those pickaxes swinging! Dig deep and hard, we need every ounce of ore you can find!\n[i](Pickaxe will be used automatically when standing close to an enemy)[/i]"
		Stages.PULL_CART:
			return "Pull that cart like it's your favorite pet! Remote control, it's not rocket science, spaceman! Use it \n[i](Press [right click] to pull the cart towards you)[/i]"
		Stages.PUSH_CART:
			return "Send those carts where they need to go! Remote control, aim true, and keep 'em rolling!\n[i](Press and hold [right click] to push the cart towards your cursor)[/i]"
		Stages.COLLECT_ORE:
			return "Ore on the ground! Scoop it up fast, spaceman! Don't leave a single nugget behind!\n[i](Move the carts over the ore to collect it)[/i]"
		Stages.BUILD_MODE:
			return "Switch to build mode, spaceman! Plan and place those buildings like you're building a space palace!\n[i](Press [Tab] to enter build mode)[/i]"
		Stages.PLACE_SMELTER:
			return "Smelters up, spaceman! Place them solid and secure. Fill 'em with ore and turn up the heat! Make those smelters roar!\n[i](Press [1] to select the smelter in the quickbar and place it with [left click])][/i]"
		Stages.PLACE_POWER_PLANT:
			return "Power plants are next! They turn heat into energy! Set 'em up right and keep 'em running hot!\n[i](Press [2] to select the power plant in the quickbar and place it with [left click])[/n]"
		Stages.PLACE_PIPE:
			return "Pipes, spaceman! Connect smelters to power plants, and let that heat flow like lava!\n[i](Press and hold [left click] on the smelter, drag the cursor to the power plant, and release)[/i]"
		Stages.FILL_SMELTER:
			return "Get those carts to the smelters, unload the ore, and keep those furnaces blazing hot!\n[i](Press [Tab] to exit build mode and move the cart close to the smelter will fill it with ore)[/i]"
		Stages.OUTRO_1:
			return "Alright, spaceman! This energy powers our turrets and traps. Keep the flow steady, and we'll crush the enemy like bugs!\n[i](Press [space] to continue)[/i]"
		Stages.OUTRO_2:
			return "Congratulation, spaceman! Get out there and get it done, because in space, it's them or us. Move out, spaceman!\n[i](Press [Esc] and click 'Quit' to exit the tutorial)[/i]"

	return ""
