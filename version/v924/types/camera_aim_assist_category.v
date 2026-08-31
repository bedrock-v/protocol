module types

import protocol.serializer
import protocol.version.v766.types as types_766

pub struct CameraAimAssistCategory {
pub mut:
	name                            string
	entity_priorities               []types_766.CameraAimAssistPriority
	block_priorities                []types_766.CameraAimAssistPriority
	block_tag_priorities            []types_766.CameraAimAssistPriority
	entity_type_families_priorities []types_766.CameraAimAssistPriority
	entity_default_priorities       ?i32
	block_default_priorities        ?i32
}

fn write_priority_list(mut w serializer.Writer, list []types_766.CameraAimAssistPriority) {
	w.write_varuint32(u32(list.len))
	for e in list {
		e.encode(mut w)
	}
}

fn read_priority_list(mut r serializer.Reader) ![]types_766.CameraAimAssistPriority {
	count := r.read_count()!
	mut out := []types_766.CameraAimAssistPriority{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		out << types_766.CameraAimAssistPriority.decode(mut r)!
	}
	return out
}

pub fn (t CameraAimAssistCategory) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	write_priority_list(mut w, t.entity_priorities)
	write_priority_list(mut w, t.block_priorities)
	write_priority_list(mut w, t.block_tag_priorities)
	write_priority_list(mut w, t.entity_type_families_priorities)
	if v := t.entity_default_priorities {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
	if v := t.block_default_priorities {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn CameraAimAssistCategory.decode(mut r serializer.Reader) !CameraAimAssistCategory {
	mut t := CameraAimAssistCategory{}
	t.name = r.read_string()!
	t.entity_priorities = read_priority_list(mut r)!
	t.block_priorities = read_priority_list(mut r)!
	t.block_tag_priorities = read_priority_list(mut r)!
	t.entity_type_families_priorities = read_priority_list(mut r)!
	if r.bool()! {
		t.entity_default_priorities = r.le_i32()!
	}
	if r.bool()! {
		t.block_default_priorities = r.le_i32()!
	}
	return t
}
