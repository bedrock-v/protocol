module types

import serializer

pub struct InventoryTransaction {
pub mut:
	action []InventoryAction
}

pub fn (t InventoryTransaction) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.action.len))
	for e in t.action {
		e.encode(mut w)
	}
}

pub fn InventoryTransaction.decode(mut r serializer.Reader) !InventoryTransaction {
	count := int(r.read_varuint32()!)
	mut items := []InventoryAction{cap: count}
	for _ in 0 .. count {
		items << InventoryAction.decode(mut r)!
	}
	return InventoryTransaction{
		action: items
	}
}
