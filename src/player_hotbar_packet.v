module src

import src.serializer

pub struct PlayerHotbarPacket {
pub mut:
	selected_hotbar_slot int
	window_id            int
	select_hotbar_slot   bool
}

pub fn (p &PlayerHotbarPacket) pid() u16 {
	return player_hotbar_packet
}

pub fn (p &PlayerHotbarPacket) name() string {
	return 'PlayerHotbarPacket'
}

pub fn (p &PlayerHotbarPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerHotbarPacket) decode_payload(mut r serializer.Reader) ! {
	p.selected_hotbar_slot = int(r.read_varuint32()!)
	p.window_id = int(r.u8()!)
	p.select_hotbar_slot = r.bool()!
}

pub fn (p &PlayerHotbarPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.selected_hotbar_slot))
	w.u8(u8(p.window_id))
	w.bool(p.select_hotbar_slot)
}
