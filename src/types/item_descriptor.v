module types

pub const item_descriptor_invalid = u8(0)
pub const item_descriptor_default = u8(1)
pub const item_descriptor_molang = u8(2)
pub const item_descriptor_item_tag = u8(3)
pub const item_descriptor_deferred = u8(4)
pub const item_descriptor_complex_alias = u8(5)

pub struct ItemDescriptorCount {
pub mut:
	descriptor_type u8
	network_id      i16
	metadata_value  i16
	expression      string
	version         u8
	tag             string
	name            string
	count           int
}
