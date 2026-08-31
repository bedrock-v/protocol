module types

import protocol.serializer

pub struct InventoryActionData {
pub mut:
	source    InventorySource
	slot      u32
	from_item ItemData
	to_item   ItemData
}

pub fn (t InventoryActionData) encode(mut w serializer.Writer) {
	t.source.encode(mut w)
	w.write_varuint32(t.slot)
	t.from_item.encode(mut w)
	t.to_item.encode(mut w)
}

pub fn InventoryActionData.decode(mut r serializer.Reader) !InventoryActionData {
	return InventoryActionData{
		source:    InventorySource.decode(mut r)!
		slot:      r.read_varuint32()!
		from_item: ItemData.decode(mut r)!
		to_item:   ItemData.decode(mut r)!
	}
}
