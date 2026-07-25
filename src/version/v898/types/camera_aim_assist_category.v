module types

import serializer
import version.v766.types as types_766

pub struct CameraAimAssistCategory {
pub mut:
	name                      string
	entity_priorities         []types_766.CameraAimAssistPriority
	block_priorities          []types_766.CameraAimAssistPriority
	block_tag_priorities      []types_766.CameraAimAssistPriority
	entity_default_priorities ?i32
	block_default_priorities  ?i32
}

pub fn (t CameraAimAssistCategory) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_varuint32(u32(t.entity_priorities.len))
	for e in t.entity_priorities {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.block_priorities.len))
	for e in t.block_priorities {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.block_tag_priorities.len))
	for e in t.block_tag_priorities {
		e.encode(mut w)
	}
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
	entity_count := int(r.read_varuint32()!)
	t.entity_priorities = []types_766.CameraAimAssistPriority{cap: entity_count}
	for _ in 0 .. entity_count {
		t.entity_priorities << types_766.CameraAimAssistPriority.decode(mut r)!
	}
	block_count := int(r.read_varuint32()!)
	t.block_priorities = []types_766.CameraAimAssistPriority{cap: block_count}
	for _ in 0 .. block_count {
		t.block_priorities << types_766.CameraAimAssistPriority.decode(mut r)!
	}
	block_tag_count := int(r.read_varuint32()!)
	t.block_tag_priorities = []types_766.CameraAimAssistPriority{cap: block_tag_count}
	for _ in 0 .. block_tag_count {
		t.block_tag_priorities << types_766.CameraAimAssistPriority.decode(mut r)!
	}
	if r.bool()! {
		t.entity_default_priorities = r.le_i32()!
	}
	if r.bool()! {
		t.block_default_priorities = r.le_i32()!
	}
	return t
}
