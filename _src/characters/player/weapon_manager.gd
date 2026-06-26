extends Node3D

@onready var weapons = $Weapons.get_children()
var weapons_unlocked: Array = []
var cur_slot: int = 0
var cur_weapon: Object = null


func _ready() -> void:
	disable_all_weapons()
	for i in range(weapons.size()):
		weapons_unlocked.append(false)
		#weapons_unlocked.append(i == 0 or i == 2)
		
	#Start with starting weapon
	if weapons.size() > 0:
		switch_to_weapons_slot(0)
		
## Iterates through all child weapon nodes and forces them into an inactive state.
## This prevents multiple weapon models or logic scripts from running simultaneously.	
func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_active"):
			weapon.set_active(false)
		else:
			weapon.hide()
	
## Cycles backward through the inventory array to equip the previous unlocked weapon.
## If the player is at the start of the inventory, it wraps around to the last slot.	
func switch_to_previews_weapon():
	for i in range(weapons.size()):
		var wrapped_int = wrapi(cur_slot -1 -i, 0, weapons.size())
		if switch_to_weapons_slot(wrapped_int):
			break
			
## Cycles forward through the inventory array to equip the next unlocked weapon.
## If the player is at the end of the inventory, it wraps around to the first slot.
func switch_to_next_weapon():
	for i in range(weapons.size()):
		var wrapped_int = wrapi(cur_slot +1 +i, 0, weapons.size())
		if switch_to_weapons_slot(wrapped_int):
			break
			
## Attempts to equip a weapon at the specified index. 
## Validates array bounds and checks if the targeted weapon is currently unlocked.
## Returns true if the weapon was successfully equipped, and false if the switch was invalid.
func switch_to_weapons_slot(slot_ind: int) -> bool:
	if slot_ind >= weapons.size() or slot_ind < 0:
		return false
	
	if weapons_unlocked.is_empty() or !weapons_unlocked[slot_ind]:
		return false
		
	disable_all_weapons()
	cur_slot = slot_ind
	cur_weapon = weapons[cur_slot]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active(true)
	else:
		cur_weapon.show()
		
	return true
