module src

import src.serializer
import src.types

pub struct PlayerToggleCrafterSlotRequestPacket {
pub mut:
	position types.BlockPosition
	slot     int
	disabled bool
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) pid() u16 {
	return player_toggle_crafter_slot_request_packet
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) name() string {
	return 'PlayerToggleCrafterSlotRequestPacket'
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerToggleCrafterSlotRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition{
		x: int(r.le_i32()!)
		y: int(r.le_i32()!)
		z: int(r.le_i32()!)
	}
	p.slot = int(r.u8()!)
	p.disabled = r.bool()!
}

pub fn (p &PlayerToggleCrafterSlotRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(i32(p.position.x))
	w.le_i32(i32(p.position.y))
	w.le_i32(i32(p.position.z))
	w.u8(u8(p.slot))
	w.bool(p.disabled)
}
