module types

pub struct ActorAttribute {
pub mut:
	id      string
	min     f32
	current f32
	max     f32
}

pub struct AttributeModifier {
pub mut:
	id           string
	name         string
	amount       f32
	operation    int
	operand      int
	serializable bool
}

pub struct UpdateAttribute {
pub mut:
	id          string
	min         f32
	max         f32
	current     f32
	default_min f32
	default_max f32
	default     f32
	modifiers   []AttributeModifier
}
