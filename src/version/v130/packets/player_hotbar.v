module packets

import protocol.serializer

pub struct PlayerHotbarPacket {
pub mut:
	selected_slot u32
	window_id     u8
	slots         []u32
}

pub fn (p &PlayerHotbarPacket) pid() u16 {
	return 48
}

pub fn (p &PlayerHotbarPacket) name() string {
	return 'PlayerHotbarPacket'
}

pub fn (p &PlayerHotbarPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerHotbarPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.selected_slot)
	w.u8(p.window_id)
	w.write_varuint32(u32(p.slots.len))
	for slot in p.slots {
		w.write_varuint32(slot)
	}
}

pub fn (mut p PlayerHotbarPacket) decode_payload(mut r serializer.Reader) ! {
	p.selected_slot = r.read_varuint32()!
	p.window_id = r.u8()!
	count := r.read_count()!
	p.slots = []u32{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.slots << r.read_varuint32()!
	}
}
