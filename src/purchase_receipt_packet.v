module src

import src.serializer

pub struct PurchaseReceiptPacket {
pub mut:
	entries []string
}

pub fn (p &PurchaseReceiptPacket) pid() u16 {
	return purchase_receipt_packet
}

pub fn (p &PurchaseReceiptPacket) name() string {
	return 'PurchaseReceiptPacket'
}

pub fn (p &PurchaseReceiptPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PurchaseReceiptPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.entries = []string{cap: count}
	for _ in 0 .. count {
		p.entries << r.read_string()!
	}
}

pub fn (p &PurchaseReceiptPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_string(entry)
	}
}
