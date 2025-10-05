extends CanvasLayer

@export var KeyPressedCol = Color.GREEN

func _ready() -> void:
	$MovementTutorial.hide()
	$MovementTutorial2.hide()
	$SpellTutorial.hide()
	$EssenceTutorial.hide()
	
	_movement_tutorial()

func _movement_tutorial():
	$MovementTutorial.show()

	var w = false
	var a = false
	var s = false
	var d = false
	while !w or !a or !s or !d:
		w = w or Input.is_action_just_pressed("Forward")
		a = a or Input.is_action_just_pressed("Left")
		s = s or Input.is_action_just_pressed("Back")
		d = d or Input.is_action_just_pressed("Right")

		if w: $MovementTutorial/Button.modulate = KeyPressedCol
		if a: $MovementTutorial/Button2.modulate = KeyPressedCol
		if s: $MovementTutorial/Button3.modulate = KeyPressedCol
		if d: $MovementTutorial/Button4.modulate = KeyPressedCol

		await get_tree().process_frame

	$MovementTutorial.hide()
	_dodge_tutorial()

	
func _dodge_tutorial():
	$MovementTutorial2.show()

	var w = false
	while !Input.is_action_just_released('Dodge'):
		w = w or Input.is_action_just_pressed('Dodge')

		if w: $MovementTutorial2/Button.modulate = KeyPressedCol
		if w: $MovementTutorial2/Button2.modulate = KeyPressedCol
		if w: $MovementTutorial2/Button3.modulate = KeyPressedCol
		if w: $MovementTutorial2/Button4.modulate = KeyPressedCol

		await get_tree().process_frame

	$MovementTutorial2.hide()
	_spell_tutorial()
	
func _spell_tutorial():
	$SpellTutorial.show()

	var w = false
	var a = false
	var s = false
	var d = false
	while !w or !a or !s or !d:
		d = s and (d or Input.is_action_just_pressed("Fire"))
		s = a and (s or Input.is_action_just_pressed("Fire"))
		a = w and (a or Input.is_action_just_pressed("Fire"))
		w = w or Input.is_action_just_pressed('Fire')

		if w: $SpellTutorial/Button.modulate = KeyPressedCol
		if a: $SpellTutorial/Button2.modulate = KeyPressedCol
		if s: $SpellTutorial/Button3.modulate = KeyPressedCol
		if d: $SpellTutorial/Button4.modulate = KeyPressedCol

		await get_tree().process_frame

	$SpellTutorial.hide()
	_essence_tutorial()

func _essence_tutorial():
	$EssenceTutorial.show()

func _on_essence_continue_pressed() -> void:
	$EssenceTutorial.hide()
