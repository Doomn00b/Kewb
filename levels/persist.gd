extends Node

@export var persist_nodes : Array[Node]

func _ready() -> void:
	for node in persist_nodes:
		node.set_owner_recursive(self.owner)
