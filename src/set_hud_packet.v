module src

import src.serializer

pub struct SetHudPacket {
pub mut:
	hud_elements []int
	visibility   int
}

pub fn (p &SetHudPacket) pid() u16 {
	return set_hud_packet
}

pub fn (p &SetHudPacket) name() string {
	return 'SetHudPacket'
}

pub fn (p &SetHudPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetHudPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.hud_elements = []int{cap: count}
	for _ in 0 .. count {
		p.hud_elements << int(r.read_varint32()!)
	}
	p.visibility = int(r.read_varint32()!)
}

pub fn (p &SetHudPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.hud_elements.len))
	for element in p.hud_elements {
		w.write_varint32(i32(element))
	}
	w.write_varint32(i32(p.visibility))
}
