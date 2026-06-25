module src

import src.serializer
import nbt

pub struct UpdateEquipPacket {
pub mut:
	window_id         int
	window_type       int
	window_slot_count int
	actor_unique_id   i64
	nbt               nbt.RootTag
}

pub fn (p &UpdateEquipPacket) pid() u16 {
	return update_equip_packet
}

pub fn (p &UpdateEquipPacket) name() string {
	return 'UpdateEquipPacket'
}

pub fn (p &UpdateEquipPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateEquipPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = int(r.u8()!)
	p.window_type = int(r.u8()!)
	p.window_slot_count = int(r.read_varint32()!)
	p.actor_unique_id = r.read_actor_unique_id()!
	p.nbt = r.read_nbt_compound_root()!
}

pub fn (p &UpdateEquipPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.window_id))
	w.u8(u8(p.window_type))
	w.write_varint32(i32(p.window_slot_count))
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_nbt_compound_root(p.nbt)
}
