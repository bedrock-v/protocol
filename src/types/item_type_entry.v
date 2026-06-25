module types

import nbt

pub struct ItemTypeEntry {
pub mut:
	string_id       string
	numeric_id      int
	component_based bool
	version         int
	component_nbt   nbt.RootTag
}
