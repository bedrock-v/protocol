module types

pub struct IntProperty {
pub mut:
	key   u32
	value i32
}

pub struct FloatProperty {
pub mut:
	key   u32
	value f32
}

pub struct PropertySyncData {
pub mut:
	int_properties   []IntProperty
	float_properties []FloatProperty
}
