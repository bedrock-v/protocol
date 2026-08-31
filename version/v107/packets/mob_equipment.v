module packets

import protocol.serializer
import protocol.version.v107.types

pub struct MobEquipmentPacket {
pub mut:
	eid            u64
	item           types.EraBItem
	inventory_slot u8
	hotbar_slot    u8
	unknown_byte   u8
}

pub fn (p &MobEquipmentPacket) pid() u16 {
	return 0x20
}

pub fn (p &MobEquipmentPacket) name() string {
	return 'MobEquipmentPacket'
}

pub fn (p &MobEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.eid)
	p.item.encode(mut w)
	w.u8(p.inventory_slot)
	w.u8(p.hotbar_slot)
	w.u8(p.unknown_byte)
}

pub fn (mut p MobEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varuint64()!
	p.item = types.EraBItem.decode(mut r)!
	p.inventory_slot = r.u8()!
	p.hotbar_slot = r.u8()!
	p.unknown_byte = r.u8()!
}
