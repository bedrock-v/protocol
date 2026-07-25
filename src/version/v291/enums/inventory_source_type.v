module enums

import serializer

pub enum InventorySourceType as i32 {
	invalid                  = -1
	container                = 0
	global                   = 1
	world_interaction        = 2
	creative                 = 3
	untracked_interaction_ui = 100
	non_implemented_todo     = 99999
}

pub fn (e InventorySourceType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InventorySourceType.decode(mut r serializer.Reader) !InventorySourceType {
	return unsafe { InventorySourceType(i32(r.read_varuint32()!)) }
}
