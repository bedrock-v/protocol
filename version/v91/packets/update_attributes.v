module packets

import protocol.serializer

pub struct AttributeEntry {
pub mut:
	min     f32
	max     f32
	value   f32
	default f32
	name    string
}

pub struct UpdateAttributesPacket {
pub mut:
	entity_id i32
	entries   []AttributeEntry
}

pub fn (p &UpdateAttributesPacket) pid() u16 {
	return 0x1f
}

pub fn (p &UpdateAttributesPacket) name() string {
	return 'UpdateAttributesPacket'
}

pub fn (p &UpdateAttributesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAttributesPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.entity_id)
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		w.le_f32(e.min)
		w.le_f32(e.max)
		w.le_f32(e.value)
		w.le_f32(e.default)
		w.write_string(e.name)
	}
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_id = r.read_varint32()!
	n := r.read_count()!
	for _ in 0 .. n {
		p.entries << AttributeEntry{
			min:     r.le_f32()!
			max:     r.le_f32()!
			value:   r.le_f32()!
			default: r.le_f32()!
			name:    r.read_string()!
		}
	}
}
