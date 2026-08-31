module packets

import protocol.serializer

pub struct PurchaseReceiptPacket {
pub mut:
	receipts []string
}

pub fn (p &PurchaseReceiptPacket) pid() u16 {
	return 92
}

pub fn (p &PurchaseReceiptPacket) name() string {
	return 'PurchaseReceiptPacket'
}

pub fn (p &PurchaseReceiptPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PurchaseReceiptPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.receipts.len))
	for receipt in p.receipts {
		w.write_string(receipt)
	}
}

pub fn (mut p PurchaseReceiptPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.receipts = []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.receipts << r.read_string()!
	}
}
