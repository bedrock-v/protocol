module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct ToggleCrafterSlotRequestPacket {
pub mut:
	block_position types_291.Vector3i
	slot           i8
	disabled       bool
}

pub fn (p &ToggleCrafterSlotRequestPacket) pid() u16 {
	return 306
}

pub fn (p &ToggleCrafterSlotRequestPacket) name() string {
	return 'ToggleCrafterSlotRequestPacket'
}

pub fn (p &ToggleCrafterSlotRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ToggleCrafterSlotRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(p.block_position.x)
	w.le_i32(p.block_position.y)
	w.le_i32(p.block_position.z)
	w.i8(p.slot)
	w.bool(p.disabled)
}

pub fn (mut p ToggleCrafterSlotRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position.x = r.le_i32()!
	p.block_position.y = r.le_i32()!
	p.block_position.z = r.le_i32()!
	p.slot = r.i8()!
	p.disabled = r.bool()!
}
