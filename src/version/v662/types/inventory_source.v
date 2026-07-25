module types

import serializer

pub struct InventorySource {
pub mut:
	source_type InventorySourceType = InventorySourceInvalidInventory{}
}

pub fn (t InventorySource) encode(mut w serializer.Writer) {
	t.source_type.encode(mut w)
}

pub fn InventorySource.decode(mut r serializer.Reader) !InventorySource {
	return InventorySource{
		source_type: InventorySourceType.decode(mut r)!
	}
}
