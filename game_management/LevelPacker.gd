#You pass a reference to the node you want to be packed, with its children included.
class_name LevelPacker
#extends Node
static func create_package(_node: Node) -> PackedScene: 
	set_pack_owner(_node, _node) #sets the owner of the level-node that has all the things to be packed.
	var package := PackedScene.new()
#warning-ignore: return_value_discarded
	package.pack(_node)
	return package

static func set_pack_owner(_node:Node, _owner:Node)-> void: #Receives references from create_package for both arguments.
	for child in _node.get_children():
		child.owner = _owner
		set_pack_owner(child, _owner)
