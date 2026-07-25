module types

import serializer

pub struct CraftingDataEntry {
pub mut:
	crafting_type CraftingDataEntryType = CraftingEntryMulti{}
}

pub fn (t CraftingDataEntry) encode(mut w serializer.Writer) {
	t.crafting_type.encode(mut w)
}

pub fn CraftingDataEntry.decode(mut r serializer.Reader) !CraftingDataEntry {
	return CraftingDataEntry{
		crafting_type: CraftingDataEntryType.decode(mut r)!
	}
}
