module types

import protocol.serializer
import protocol.version.v662.enums

pub struct InventorySourceInvalidInventory {}

pub struct InventorySourceContainerInventory {
pub mut:
	container_id enums.ContainerID
}

pub struct InventorySourceGlobalInventory {}

pub struct InventorySourceWorldInteraction {
pub mut:
	flags u32
}

pub struct InventorySourceCreativeInventory {}

pub struct InventorySourceNonImplementedFeatureTodo {}

pub type InventorySourceType = InventorySourceContainerInventory
	| InventorySourceCreativeInventory
	| InventorySourceGlobalInventory
	| InventorySourceInvalidInventory
	| InventorySourceNonImplementedFeatureTodo
	| InventorySourceWorldInteraction

pub fn (t InventorySourceType) encode(mut w serializer.Writer) {
	match t {
		InventorySourceInvalidInventory {
			w.write_varuint32(u32(0xffffffff))
		}
		InventorySourceContainerInventory {
			w.write_varuint32(0)
			t.container_id.encode(mut w)
		}
		InventorySourceGlobalInventory {
			w.write_varuint32(1)
		}
		InventorySourceWorldInteraction {
			w.write_varuint32(2)
			w.write_varuint32(t.flags)
		}
		InventorySourceCreativeInventory {
			w.write_varuint32(3)
		}
		InventorySourceNonImplementedFeatureTodo {
			w.write_varuint32(99999)
		}
	}
}

pub fn InventorySourceType.decode(mut r serializer.Reader) !InventorySourceType {
	d := r.read_varuint32()!
	match d {
		u32(0xffffffff) {
			return InventorySourceInvalidInventory{}
		}
		0 {
			return InventorySourceContainerInventory{
				container_id: enums.ContainerID.decode(mut r)!
			}
		}
		1 {
			return InventorySourceGlobalInventory{}
		}
		2 {
			return InventorySourceWorldInteraction{
				flags: r.read_varuint32()!
			}
		}
		3 {
			return InventorySourceCreativeInventory{}
		}
		99999 {
			return InventorySourceNonImplementedFeatureTodo{}
		}
		else {
			return error('invalid InventorySourceType ${d}')
		}
	}
}
