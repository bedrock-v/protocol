module serializer

import src.types

pub fn (mut r Reader) read_entity_link() !types.EntityLink {
	return types.EntityLink{
		from_actor_unique_id:     r.read_actor_unique_id()!
		to_actor_unique_id:       r.read_actor_unique_id()!
		type:                     int(r.u8()!)
		immediate:                r.bool()!
		caused_by_rider:          r.bool()!
		vehicle_angular_velocity: r.le_f32()!
	}
}

pub fn (mut w Writer) write_entity_link(link types.EntityLink) {
	w.write_actor_unique_id(link.from_actor_unique_id)
	w.write_actor_unique_id(link.to_actor_unique_id)
	w.u8(u8(link.type))
	w.bool(link.immediate)
	w.bool(link.caused_by_rider)
	w.le_f32(link.vehicle_angular_velocity)
}

pub fn (mut r Reader) read_attribute_modifier() !types.AttributeModifier {
	return types.AttributeModifier{
		id:           r.read_string()!
		name:         r.read_string()!
		amount:       r.le_f32()!
		operation:    int(r.le_i32()!)
		operand:      int(r.le_i32()!)
		serializable: r.bool()!
	}
}

pub fn (mut w Writer) write_attribute_modifier(m types.AttributeModifier) {
	w.write_string(m.id)
	w.write_string(m.name)
	w.le_f32(m.amount)
	w.le_i32(i32(m.operation))
	w.le_i32(i32(m.operand))
	w.bool(m.serializable)
}

pub fn (mut r Reader) read_update_attribute() !types.UpdateAttribute {
	min := r.le_f32()!
	max := r.le_f32()!
	current := r.le_f32()!
	default_min := r.le_f32()!
	default_max := r.le_f32()!
	default := r.le_f32()!
	id := r.read_string()!
	modifier_count := int(r.read_varuint32()!)
	mut modifiers := []types.AttributeModifier{cap: modifier_count}
	for _ in 0 .. modifier_count {
		modifiers << r.read_attribute_modifier()!
	}
	return types.UpdateAttribute{
		id:          id
		min:         min
		max:         max
		current:     current
		default_min: default_min
		default_max: default_max
		default:     default
		modifiers:   modifiers
	}
}

pub fn (mut w Writer) write_update_attribute(a types.UpdateAttribute) {
	w.le_f32(a.min)
	w.le_f32(a.max)
	w.le_f32(a.current)
	w.le_f32(a.default_min)
	w.le_f32(a.default_max)
	w.le_f32(a.default)
	w.write_string(a.id)
	w.write_varuint32(u32(a.modifiers.len))
	for modifier in a.modifiers {
		w.write_attribute_modifier(modifier)
	}
}
