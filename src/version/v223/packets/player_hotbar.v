module packets

import protocol.serializer

pub struct PlayerHotbarPacket {
pub mut:
	selected_hotbar_slot u32
	window_id            u8
	select_hotbar_slot   bool
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
	w.write_varuint32(p.selected_hotbar_slot)
	w.u8(p.window_id)
	w.bool(p.select_hotbar_slot)
}

pub fn (mut p PlayerHotbarPacket) decode_payload(mut r serializer.Reader) ! {
	p.selected_hotbar_slot = r.read_varuint32()!
	p.window_id = r.u8()!
	p.select_hotbar_slot = r.bool()!
}
