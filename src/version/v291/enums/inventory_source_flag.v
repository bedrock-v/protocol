module enums

import protocol.serializer

pub enum InventorySourceFlag as u32 {
	drop_item   = 0
	pickup_item = 1
	@none       = 2
}

pub fn (e InventorySourceFlag) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InventorySourceFlag.decode(mut r serializer.Reader) !InventorySourceFlag {
	return unsafe { InventorySourceFlag(r.read_varuint32()!) }
}
