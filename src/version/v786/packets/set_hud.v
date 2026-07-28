module packets

import protocol.serializer
import protocol.version.v786.enums

pub struct SetHudPacket {
pub mut:
	hud_elements_list []enums.HudElement
	hud_visibility    enums.HudVisibility
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
	w.write_varuint32(u32(p.hud_elements_list.len))
	for e in p.hud_elements_list {
		e.encode(mut w)
	}
	p.hud_visibility.encode(mut w)
}

pub fn (mut p SetHudPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.hud_elements_list = []enums.HudElement{cap: count}
		for _ in 0 .. count {
			p.hud_elements_list << enums.HudElement.decode(mut r)!
		}
	}
	p.hud_visibility = enums.HudVisibility.decode(mut r)!
}
