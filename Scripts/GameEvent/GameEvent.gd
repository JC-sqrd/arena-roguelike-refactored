@abstract
class_name GameEvent extends RefCounted

var event_id : StringName

@abstract
func invoke_event(context : Dictionary[StringName, Variant] = {})
