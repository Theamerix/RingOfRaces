extends VBoxContainer

# Many thanks to Arkeve! https://github.com/arkeve

const SlotClass = preload("res://MiscCodes/Slot.gd")
@onready var inventory_slots = $GridContainer
var holding_item = null

func _ready():
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input",Callable(self,"slot_gui_input").bind(inv_slot))

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item: # Place holding item to slot
					slot.putIntoSlot(holding_item)
					holding_item = null
				else: # Swap holding item with item in slot
					var temp_item = slot.item
					slot.pickFromSlot()
					temp_item.global_position = event.global_position
					slot.putIntoSlot(holding_item)
					holding_item = temp_item
			elif slot.item:
				holding_item = slot.item
				slot.pickFromSlot()
				holding_item.global_position = get_global_mouse_position()
				
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func _on_TouchScreenButton_pressed():
	Global.GoToScene("river_intersection_home_2")
