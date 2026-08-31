module packets

import protocol.serializer
import protocol.version.v91.types

pub struct InventoryActionPacket {
pub mut:
	unknown u32
	item    types.EraBItem
}

pub fn (p &InventoryActionPacket) pid() u16 {
	return 0x2e
}

pub fn (p &InventoryActionPacket) name() string {
	return 'InventoryActionPacket'
}

pub fn (p &InventoryActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventoryActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.unknown)
	p.item.encode(mut w)
}

pub fn (mut p InventoryActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown = r.read_varuint32()!
	p.item = types.EraBItem.decode(mut r)!
}
