module packets

import protocol.serializer

pub struct PlayerToggleCrafterSlotRequestPacket {
pub mut:
	pos_x       i32
	pos_y       i32
	pos_z       i32
	slot_index  i8
	is_disabled bool
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) pid() u16 {
	return 306
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) name() string {
	return 'PlayerToggleCrafterSlotRequestPacket'
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(p.pos_x)
	w.le_i32(p.pos_y)
	w.le_i32(p.pos_z)
	w.i8(p.slot_index)
	w.bool(p.is_disabled)
}

pub fn (mut p PlayerToggleCrafterSlotRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.pos_x = r.le_i32()!
	p.pos_y = r.le_i32()!
	p.pos_z = r.le_i32()!
	p.slot_index = r.i8()!
	p.is_disabled = r.bool()!
}
