module packets

import serializer

pub struct PurchaseReceiptPacket {
pub mut:
	purchase_receipts []string
}

pub fn (p &PurchaseReceiptPacket) pid() u16 { return 92 }

pub fn (p &PurchaseReceiptPacket) name() string { return 'PurchaseReceiptPacket' }

pub fn (p &PurchaseReceiptPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PurchaseReceiptPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.purchase_receipts.len))
	for e in p.purchase_receipts {
		w.write_string(e)
	}
}

pub fn (mut p PurchaseReceiptPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.purchase_receipts = []string{cap: count}
		for _ in 0 .. count {
			p.purchase_receipts << r.read_string()!
		}
	}
}
