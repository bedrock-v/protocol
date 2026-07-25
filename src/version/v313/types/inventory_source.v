module types

import serializer
import version.v291.enums

pub struct InventorySource {
pub mut:
	source_type  enums.InventorySourceType
	container_id i32
	flag         enums.InventorySourceFlag = .@none
}

pub fn (t InventorySource) encode(mut w serializer.Writer) {
	t.source_type.encode(mut w)
	match t.source_type {
		.container, .untracked_interaction_ui, .non_implemented_todo {
			w.write_varint32(t.container_id)
		}
		.world_interaction {
			t.flag.encode(mut w)
		}
		else {}
	}
}

pub fn InventorySource.decode(mut r serializer.Reader) !InventorySource {
	mut t := InventorySource{}
	t.source_type = enums.InventorySourceType.decode(mut r)!
	match t.source_type {
		.container, .untracked_interaction_ui, .non_implemented_todo {
			t.container_id = r.read_varint32()!
		}
		.world_interaction {
			t.flag = enums.InventorySourceFlag.decode(mut r)!
		}
		else {}
	}
	return t
}
