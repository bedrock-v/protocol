module enums

import serializer

pub enum InventorySourceFlags as u32 {
	no_flag                  = 0
	world_interaction_random = 1
}

pub fn (e InventorySourceFlags) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InventorySourceFlags.decode(mut r serializer.Reader) !InventorySourceFlags {
	return unsafe { InventorySourceFlags(r.read_varuint32()!) }
}
