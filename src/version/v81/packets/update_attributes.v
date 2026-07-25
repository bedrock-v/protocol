module packets

import serializer

pub struct AttributeEntry {
pub mut:
	min   f32
	max   f32
	value f32
	name  string
}

pub struct UpdateAttributesPacket {
pub mut:
	entity_id i64
	entries   []AttributeEntry
}

pub fn (p &UpdateAttributesPacket) pid() u16 {
	return 0x1a
}

pub fn (p &UpdateAttributesPacket) name() string {
	return 'UpdateAttributesPacket'
}

pub fn (p &UpdateAttributesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAttributesPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.entity_id)
	w.be_i16(i16(p.entries.len))
	for e in p.entries {
		w.be_f32(e.min)
		w.be_f32(e.max)
		w.be_f32(e.value)
		w.write_string_be(e.name)
	}
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_id = r.be_i64()!
	count := int(r.be_u16()!)
	for _ in 0 .. count {
		p.entries << AttributeEntry{
			min:   r.be_f32()!
			max:   r.be_f32()!
			value: r.be_f32()!
			name:  r.read_string_be()!
		}
	}
}
