module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct AttributeModifier {
pub mut:
	id              string
	name            string
	amount          f32
	operation       enums.AttributeModifierOperation
	operand         enums.AttributeOperands
	is_serializable bool
}

pub fn (e AttributeModifier) encode(mut w serializer.Writer) {
	w.write_string(e.id)
	w.write_string(e.name)
	w.le_f32(e.amount)
	e.operation.encode(mut w)
	e.operand.encode(mut w)
	w.bool(e.is_serializable)
}

pub fn AttributeModifier.decode(mut r serializer.Reader) !AttributeModifier {
	return AttributeModifier{
		id:              r.read_string()!
		name:            r.read_string()!
		amount:          r.le_f32()!
		operation:       enums.AttributeModifierOperation.decode(mut r)!
		operand:         enums.AttributeOperands.decode(mut r)!
		is_serializable: r.bool()!
	}
}

pub struct AttributeData {
pub mut:
	min_value           f32
	max_value           f32
	current_value       f32
	default_value       f32
	attribute_name      string
	attribute_modifiers []AttributeModifier
}

pub fn (e AttributeData) encode(mut w serializer.Writer) {
	w.le_f32(e.min_value)
	w.le_f32(e.max_value)
	w.le_f32(e.current_value)
	w.le_f32(e.default_value)
	w.write_string(e.attribute_name)
	w.write_varuint32(u32(e.attribute_modifiers.len))
	for m in e.attribute_modifiers {
		m.encode(mut w)
	}
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	mut e := AttributeData{}
	e.min_value = r.le_f32()!
	e.max_value = r.le_f32()!
	e.current_value = r.le_f32()!
	e.default_value = r.le_f32()!
	e.attribute_name = r.read_string()!
	count := int(r.read_varuint32()!)
	e.attribute_modifiers = []AttributeModifier{cap: count}
	for _ in 0 .. count {
		e.attribute_modifiers << AttributeModifier.decode(mut r)!
	}
	return e
}

pub struct UpdateAttributesPacket {
pub mut:
	target_runtime_id       types.ActorRuntimeID
	attribute_list          []AttributeData
	ticks_since_sim_started u64
}

pub fn (p &UpdateAttributesPacket) pid() u16 {
	return 29
}

pub fn (p &UpdateAttributesPacket) name() string {
	return 'UpdateAttributesPacket'
}

pub fn (p &UpdateAttributesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAttributesPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	w.write_varuint32(u32(p.attribute_list.len))
	for e in p.attribute_list {
		e.encode(mut w)
	}
	w.write_varuint64(p.ticks_since_sim_started)
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	count := int(r.read_varuint32()!)
	p.attribute_list = []AttributeData{cap: count}
	for _ in 0 .. count {
		p.attribute_list << AttributeData.decode(mut r)!
	}
	p.ticks_since_sim_started = r.read_varuint64()!
}
