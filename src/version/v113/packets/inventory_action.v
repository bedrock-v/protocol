module packets

import serializer
import version.v113.types

pub struct InventoryActionPacket {
pub mut:
	uvarint0 u32
	item     types.EraBItem
	varint1  i32
	varint2  i32
}

pub fn (p &InventoryActionPacket) pid() u16 {
	return 0x2f
}

pub fn (p &InventoryActionPacket) name() string {
	return 'InventoryActionPacket'
}

pub fn (p &InventoryActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventoryActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.uvarint0)
	p.item.encode(mut w)
	w.write_varint32(p.varint1)
	w.write_varint32(p.varint2)
}

pub fn (mut p InventoryActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.uvarint0 = r.read_varuint32()!
	p.item = types.EraBItem.decode(mut r)!
	p.varint1 = r.read_varint32()!
	p.varint2 = r.read_varint32()!
}
