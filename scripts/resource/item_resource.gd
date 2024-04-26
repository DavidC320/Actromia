@tool
extends Resource
class_name ItemResource

@export var item_name:String
@export_enum("item", "unlock") var item_type = "item":
	set(value):
		item_type = value
		notify_property_list_changed()
@export_category("Statistics")
## items
@export_enum("key", "bomb") var item := 0
@export_range(1, 10) var amount := 1
## unlocks
@export_enum("candle") var unlock_item := 0
@export_category("sprites")
@export var sprite:Texture


func _validate_property(property):
	if property.name in ['item', 'amount'] and item_type != "item":
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ['unlock_item'] and item_type != 'unlock':
		property.usage = PROPERTY_USAGE_NO_EDITOR
