module src

import src.serializer

pub const attribute_layer_payload_update_layers = u32(0)
pub const attribute_layer_payload_update_settings = u32(1)
pub const attribute_layer_payload_update_environment = u32(2)
pub const attribute_layer_payload_remove_environment = u32(3)

pub const attribute_data_type_bool = u32(0)
pub const attribute_data_type_float = u32(1)
pub const attribute_data_type_colour = u32(2)

pub struct AttributeData {
pub mut:
	type_id                u32
	bool_value             bool
	has_bool_operation     bool
	bool_operation         int
	float_value            f32
	has_float_operation    bool
	float_operation        int
	has_float_min          bool
	float_min              f32
	has_float_max          bool
	float_max              f32
	colour_value           int
	has_colour_operation   bool
	colour_operation       int
}

pub struct EnvironmentAttributeData {
pub mut:
	attribute_name           string
	has_from_attribute       bool
	from_attribute           AttributeData
	attribute                AttributeData
	has_to_attribute         bool
	to_attribute             AttributeData
	current_transition_ticks u32
	total_transition_ticks   u32
	ease_type                string
	local_transition_ticks   u32
	noise_transition         bool
}

pub struct AttributeLayerSettings {
pub mut:
	priority           int
	float_weight       f32
	enabled            bool
	transitions_paused bool
}

pub struct AttributeLayerData {
pub mut:
	name                   string
	has_noise_name         bool
	noise_name             string
	dimension_id           int
	settings               AttributeLayerSettings
	environment_attributes []EnvironmentAttributeData
}

pub struct ClientboundAttributeLayerSyncPacket {
pub mut:
	payload_type           u32
	layers                 []AttributeLayerData
	layer_name             string
	dimension_id           int
	settings               AttributeLayerSettings
	environment_attributes []EnvironmentAttributeData
	remove_attribute_names []string
}

pub fn (p &ClientboundAttributeLayerSyncPacket) pid() u16 {
	return clientbound_attribute_layer_sync_packet
}

pub fn (p &ClientboundAttributeLayerSyncPacket) name() string {
	return 'ClientboundAttributeLayerSyncPacket'
}

pub fn (p &ClientboundAttributeLayerSyncPacket) can_be_sent_before_login() bool {
	return false
}

fn read_attribute_data(mut r serializer.Reader) !AttributeData {
	mut a := AttributeData{
		type_id: r.read_varuint32()!
	}
	match a.type_id {
		attribute_data_type_bool {
			a.bool_value = r.bool()!
			if r.bool()! {
				a.has_bool_operation = true
				a.bool_operation = r.le_i32()!
			}
		}
		attribute_data_type_float {
			a.float_value = r.le_f32()!
			if r.bool()! {
				a.has_float_operation = true
				a.float_operation = r.le_i32()!
			}
			if r.bool()! {
				a.has_float_min = true
				a.float_min = r.le_f32()!
			}
			if r.bool()! {
				a.has_float_max = true
				a.float_max = r.le_f32()!
			}
		}
		attribute_data_type_colour {
			a.colour_value = r.le_i32()!
			if r.bool()! {
				a.has_colour_operation = true
				a.colour_operation = r.le_i32()!
			}
		}
		else {}
	}
	return a
}

fn write_attribute_data(mut w serializer.Writer, a AttributeData) {
	w.write_varuint32(a.type_id)
	match a.type_id {
		attribute_data_type_bool {
			w.bool(a.bool_value)
			if a.has_bool_operation {
				w.bool(true)
				w.le_i32(a.bool_operation)
			} else {
				w.bool(false)
			}
		}
		attribute_data_type_float {
			w.le_f32(a.float_value)
			if a.has_float_operation {
				w.bool(true)
				w.le_i32(a.float_operation)
			} else {
				w.bool(false)
			}
			if a.has_float_min {
				w.bool(true)
				w.le_f32(a.float_min)
			} else {
				w.bool(false)
			}
			if a.has_float_max {
				w.bool(true)
				w.le_f32(a.float_max)
			} else {
				w.bool(false)
			}
		}
		attribute_data_type_colour {
			w.le_i32(a.colour_value)
			if a.has_colour_operation {
				w.bool(true)
				w.le_i32(a.colour_operation)
			} else {
				w.bool(false)
			}
		}
		else {}
	}
}

fn read_attribute_layer_settings(mut r serializer.Reader) !AttributeLayerSettings {
	return AttributeLayerSettings{
		priority:           r.le_i32()!
		float_weight:       r.le_f32()!
		enabled:            r.bool()!
		transitions_paused: r.bool()!
	}
}

fn write_attribute_layer_settings(mut w serializer.Writer, s AttributeLayerSettings) {
	w.le_i32(s.priority)
	w.le_f32(s.float_weight)
	w.bool(s.enabled)
	w.bool(s.transitions_paused)
}

fn read_environment_attribute(mut r serializer.Reader) !EnvironmentAttributeData {
	mut e := EnvironmentAttributeData{
		attribute_name: r.read_string()!
	}
	if r.bool()! {
		e.has_from_attribute = true
		e.from_attribute = read_attribute_data(mut r)!
	}
	e.attribute = read_attribute_data(mut r)!
	if r.bool()! {
		e.has_to_attribute = true
		e.to_attribute = read_attribute_data(mut r)!
	}
	e.current_transition_ticks = r.le_u32()!
	e.total_transition_ticks = r.le_u32()!
	e.ease_type = r.read_string()!
	e.local_transition_ticks = r.le_u32()!
	e.noise_transition = r.bool()!
	return e
}

fn write_environment_attribute(mut w serializer.Writer, e EnvironmentAttributeData) {
	w.write_string(e.attribute_name)
	if e.has_from_attribute {
		w.bool(true)
		write_attribute_data(mut w, e.from_attribute)
	} else {
		w.bool(false)
	}
	write_attribute_data(mut w, e.attribute)
	if e.has_to_attribute {
		w.bool(true)
		write_attribute_data(mut w, e.to_attribute)
	} else {
		w.bool(false)
	}
	w.le_u32(e.current_transition_ticks)
	w.le_u32(e.total_transition_ticks)
	w.write_string(e.ease_type)
	w.le_u32(e.local_transition_ticks)
	w.bool(e.noise_transition)
}

fn read_attribute_layer(mut r serializer.Reader) !AttributeLayerData {
	mut l := AttributeLayerData{
		name: r.read_string()!
	}
	if r.bool()! {
		l.has_noise_name = true
		l.noise_name = r.read_string()!
	}
	l.dimension_id = r.read_varint32()!
	l.settings = read_attribute_layer_settings(mut r)!
	count := r.read_varuint32()!
	l.environment_attributes = []EnvironmentAttributeData{}
	for _ in 0 .. count {
		l.environment_attributes << read_environment_attribute(mut r)!
	}
	return l
}

fn write_attribute_layer(mut w serializer.Writer, l AttributeLayerData) {
	w.write_string(l.name)
	if l.has_noise_name {
		w.bool(true)
		w.write_string(l.noise_name)
	} else {
		w.bool(false)
	}
	w.write_varint32(l.dimension_id)
	write_attribute_layer_settings(mut w, l.settings)
	w.write_varuint32(u32(l.environment_attributes.len))
	for e in l.environment_attributes {
		write_environment_attribute(mut w, e)
	}
}

pub fn (mut p ClientboundAttributeLayerSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.payload_type = r.read_varuint32()!
	match p.payload_type {
		attribute_layer_payload_update_layers {
			count := r.read_varuint32()!
			p.layers = []AttributeLayerData{}
			for _ in 0 .. count {
				p.layers << read_attribute_layer(mut r)!
			}
		}
		attribute_layer_payload_update_settings {
			p.layer_name = r.read_string()!
			p.dimension_id = r.read_varint32()!
			p.settings = read_attribute_layer_settings(mut r)!
		}
		attribute_layer_payload_update_environment {
			p.layer_name = r.read_string()!
			p.dimension_id = r.read_varint32()!
			count := r.read_varuint32()!
			p.environment_attributes = []EnvironmentAttributeData{}
			for _ in 0 .. count {
				p.environment_attributes << read_environment_attribute(mut r)!
			}
		}
		attribute_layer_payload_remove_environment {
			p.layer_name = r.read_string()!
			p.dimension_id = r.read_varint32()!
			count := r.read_varuint32()!
			p.remove_attribute_names = []string{}
			for _ in 0 .. count {
				p.remove_attribute_names << r.read_string()!
			}
		}
		else {}
	}
}

pub fn (p &ClientboundAttributeLayerSyncPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.payload_type)
	match p.payload_type {
		attribute_layer_payload_update_layers {
			w.write_varuint32(u32(p.layers.len))
			for l in p.layers {
				write_attribute_layer(mut w, l)
			}
		}
		attribute_layer_payload_update_settings {
			w.write_string(p.layer_name)
			w.write_varint32(p.dimension_id)
			write_attribute_layer_settings(mut w, p.settings)
		}
		attribute_layer_payload_update_environment {
			w.write_string(p.layer_name)
			w.write_varint32(p.dimension_id)
			w.write_varuint32(u32(p.environment_attributes.len))
			for e in p.environment_attributes {
				write_environment_attribute(mut w, e)
			}
		}
		attribute_layer_payload_remove_environment {
			w.write_string(p.layer_name)
			w.write_varint32(p.dimension_id)
			w.write_varuint32(u32(p.remove_attribute_names.len))
			for n in p.remove_attribute_names {
				w.write_string(n)
			}
		}
		else {}
	}
}
