module packets

import protocol.serializer

pub struct InventoryTransactionPacket {
pub mut:
	transaction_type u32
}

pub fn (p &InventoryTransactionPacket) pid() u16 {
	return 30
}

pub fn (p &InventoryTransactionPacket) name() string {
	return 'InventoryTransactionPacket'
}

pub fn (p &InventoryTransactionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventoryTransactionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.transaction_type)
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.transaction_type = r.read_varuint32()!
}
