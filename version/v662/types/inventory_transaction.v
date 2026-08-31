module types

import protocol.serializer

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
	count := r.read_count()!
	mut items := []InventoryAction{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << InventoryAction.decode(mut r)!
	}
	return InventoryTransaction{
		action: items
	}
}
