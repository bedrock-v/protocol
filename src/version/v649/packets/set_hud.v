module packets

import protocol.serializer
import protocol.version.v649.enums

pub struct SetHudPacket {
pub mut:
	elements   []enums.HudElement
	visibility enums.HudVisibility
}

pub fn (p &SetHudPacket) pid() u16 {
	return 308
}

pub fn (p &SetHudPacket) name() string {
	return 'SetHudPacket'
}

pub fn (p &SetHudPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetHudPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.elements.len))
	for element in p.elements {
		element.encode(mut w)
	}
	p.visibility.encode(mut w)
}

pub fn (mut p SetHudPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.elements = []enums.HudElement{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.elements << enums.HudElement.decode(mut r)!
	}
	p.visibility = enums.HudVisibility.decode(mut r)!
}
