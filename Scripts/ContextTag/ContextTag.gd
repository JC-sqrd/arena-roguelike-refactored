class_name ContextTag extends Resource

@export var name : StringName
@export var parent : ContextTag


func is_descendant_of(context_tag : ContextTag) -> bool:
	if context_tag == self:
		return true
	if parent == null:
		return false
	return parent.is_descendant_of(context_tag)
