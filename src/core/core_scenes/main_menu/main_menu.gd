extends BaseMenuController

enum State {
	MAIN,
	SETTINGS,
	CREDITS,
	EXIT_DIALOG,
	SAVE_FILE_SELECTION,
	SAVE_SLOT_SELECTION,
	SAVE_SLOT_CREATION,
}

@onready var panel_main:        Control = %TitleScreen
@onready var panel_settings:    Control = $SettingsScreen
@onready var panel_credits:     Control = $CreditsScreen
@onready var panel_exit_dialog: CustomConfirmationDialog = $ExitDialog
@onready var panel_save_file_selection: Control = $SaveFileSelectionScreen
@onready var panel_save_slot_selection: Control = $SaveSlotSelectionScreen
@onready var panel_save_slot_creation: Control = $SaveSlotCreationScreen

@export var initial_state : State = State.MAIN


func _ready() -> void:
	# Making sure the current Save is unloaded while being in the main menu.
	# So that player cannot create new save files under a save slot by mistake
	SaveManager.unload()
	
	SaveManager.save_file_deleted.connect(update_save_info)
	SaveManager.save_slot_selected.connect(update_save_lists)
	update_save_info()
	
	_panels = {
		State.MAIN: panel_main,
		State.SETTINGS: panel_settings,
		State.CREDITS: panel_credits,
		State.EXIT_DIALOG: panel_exit_dialog,
		State.SAVE_FILE_SELECTION: panel_save_file_selection,
		State.SAVE_SLOT_SELECTION: panel_save_slot_selection,
		State.SAVE_SLOT_CREATION: panel_save_slot_creation,
	}
	_initial_state = initial_state
	
	#if G.config.has_save_slots:
		#panel_main.play_requested.connect(go_to.bind(State.SAVE_SLOT_SELECTION))
	#else:
	panel_main.play_requested.connect(_on_save_slot_selected)
	
	panel_main.settings_requested.connect(go_to.bind(State.SETTINGS))
	panel_main.credits_requested.connect(go_to.bind(State.CREDITS))
	panel_main.exit_dialog_requested.connect(go_to.bind(State.EXIT_DIALOG))

	panel_settings.back_requested.connect(go_back)
	
	panel_save_file_selection.back_requested.connect(go_back)
	
	panel_save_slot_selection.back_requested.connect(go_back)
	panel_save_slot_selection.save_slot_selected.connect(_on_save_slot_selected)
	
	panel_save_slot_creation.back_requested.connect(go_back)
	panel_save_slot_creation.slot_creation_confirmed.connect(_on_slot_creation_confirmed)
	
	panel_credits.back_requested.connect(go_back)
	
	panel_exit_dialog.confirm_request.connect(get_tree().quit)
	panel_exit_dialog.cancel_request.connect(go_back)
	panel_exit_dialog.set_format_dict({"game_name": ProjectSettings.get_setting("application/config/name")})
	
	super._ready()  # always last — triggers go_to(_initial_state)


func _input(event: InputEvent) -> void:
	if InputManager.just_pressed_event("ui_cancel", event):
		go_back()


func update_save_info() -> void:
	SaveManager.list_save_data()
	update_save_lists()


func update_save_lists() -> void:
	panel_save_file_selection.update()
	panel_save_slot_selection.update()


## Called when a save slot is selected (or immediately if has_save_slots is false).
## Routes the player to the appropriate next step based on the save system configuration:
##   - Show save file selection (if multiple saves exist and manual saving is enabled)
##   - Load the most recent save and start the game (if only one save or no manual saving)
##   - Show slot setup screen (if the slot is empty and needs configuration)
##   - Create a new save and start the game (if the slot is empty and needs no setup)
func _on_save_slot_selected() -> void:
	get_tree().change_scene_to_file("res://src/core/core_scenes/game/game.tscn")


func _on_slot_creation_confirmed(slot_name: String) -> void:
	SaveManager.save_data.save_slot_name = slot_name
	await SaveManager.create_new_save()
	G.request_core_scene.emit(&"GAME")
