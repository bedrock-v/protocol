module packets

import protocol.serializer

pub struct ClientBoundAttributeLayerSyncPacket {
pub mut:
	data ClientBoundAttributeLayerSyncData = UpdateAttributeLayersData{}
}

pub fn (p &ClientBoundAttributeLayerSyncPacket) pid() u16 {
	return 345
}

pub fn (p &ClientBoundAttributeLayerSyncPacket) name() string {
	return 'ClientBoundAttributeLayerSyncPacket'
}

pub fn (p &ClientBoundAttributeLayerSyncPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundAttributeLayerSyncPacket) encode_payload(mut w serializer.Writer) {
	p.data.encode(mut w)
}

pub fn (mut p ClientBoundAttributeLayerSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = ClientBoundAttributeLayerSyncData.decode(mut r)!
}

pub struct UpdateAttributeLayersData {
pub mut:
	layers []AttributeLayerData
}

pub struct UpdateAttributeLayerSettingsData {
pub mut:
	name      string
	dimension i32
	settings  AttributeLayerSettings
}

pub struct UpdateEnvironmentAttributesData {
pub mut:
	name       string
	dimension  i32
	attributes []EnvironmentAttributeData
}

pub struct RemoveEnvironmentAttributesData {
pub mut:
	name       string
	dimension  i32
	attributes []string
}

pub type ClientBoundAttributeLayerSyncData = RemoveEnvironmentAttributesData
	| UpdateAttributeLayerSettingsData
	| UpdateAttributeLayersData
	| UpdateEnvironmentAttributesData

fn write_environment_attribute_list(mut w serializer.Writer, list []EnvironmentAttributeData) {
	w.write_varuint32(u32(list.len))
	for e in list {
		e.encode(mut w)
	}
}

fn read_environment_attribute_list(mut r serializer.Reader) ![]EnvironmentAttributeData {
	count := int(r.read_varuint32()!)
	mut out := []EnvironmentAttributeData{cap: count}
	for _ in 0 .. count {
		out << EnvironmentAttributeData.decode(mut r)!
	}
	return out
}

pub fn (t ClientBoundAttributeLayerSyncData) encode(mut w serializer.Writer) {
	match t {
		UpdateAttributeLayersData {
			w.write_varuint32(0)
			w.write_varuint32(u32(t.layers.len))
			for e in t.layers {
				e.encode(mut w)
			}
		}
		UpdateAttributeLayerSettingsData {
			w.write_varuint32(1)
			w.write_string(t.name)
			w.write_varint32(t.dimension)
			t.settings.encode(mut w)
		}
		UpdateEnvironmentAttributesData {
			w.write_varuint32(2)
			w.write_string(t.name)
			w.write_varint32(t.dimension)
			write_environment_attribute_list(mut w, t.attributes)
		}
		RemoveEnvironmentAttributesData {
			w.write_varuint32(3)
			w.write_string(t.name)
			w.write_varint32(t.dimension)
			w.write_varuint32(u32(t.attributes.len))
			for s in t.attributes {
				w.write_string(s)
			}
		}
	}
}

pub fn ClientBoundAttributeLayerSyncData.decode(mut r serializer.Reader) !ClientBoundAttributeLayerSyncData {
	d := r.read_varuint32()!
	match d {
		0 {
			count := int(r.read_varuint32()!)
			mut layers := []AttributeLayerData{cap: count}
			for _ in 0 .. count {
				layers << AttributeLayerData.decode(mut r)!
			}
			return UpdateAttributeLayersData{
				layers: layers
			}
		}
		1 {
			return UpdateAttributeLayerSettingsData{
				name:      r.read_string()!
				dimension: r.read_varint32()!
				settings:  AttributeLayerSettings.decode(mut r)!
			}
		}
		2 {
			return UpdateEnvironmentAttributesData{
				name:       r.read_string()!
				dimension:  r.read_varint32()!
				attributes: read_environment_attribute_list(mut r)!
			}
		}
		3 {
			name := r.read_string()!
			dimension := r.read_varint32()!
			count := int(r.read_varuint32()!)
			mut attributes := []string{cap: count}
			for _ in 0 .. count {
				attributes << r.read_string()!
			}
			return RemoveEnvironmentAttributesData{
				name:       name
				dimension:  dimension
				attributes: attributes
			}
		}
		else {
			return error('invalid ClientBoundAttributeLayerSyncData ${d}')
		}
	}
}

pub struct AttributeLayerData {
pub mut:
	name       string
	noise_name ?string
	dimension  i32
	settings   AttributeLayerSettings
	attributes []EnvironmentAttributeData
}

pub fn (t AttributeLayerData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	if v := t.noise_name {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	w.write_varint32(t.dimension)
	t.settings.encode(mut w)
	write_environment_attribute_list(mut w, t.attributes)
}

pub fn AttributeLayerData.decode(mut r serializer.Reader) !AttributeLayerData {
	mut t := AttributeLayerData{}
	t.name = r.read_string()!
	if r.bool()! {
		t.noise_name = r.read_string()!
	}
	t.dimension = r.read_varint32()!
	t.settings = AttributeLayerSettings.decode(mut r)!
	t.attributes = read_environment_attribute_list(mut r)!
	return t
}

pub struct AttributeLayerSettings {
pub mut:
	priority           i32
	weight             f32
	enabled            bool
	transitions_paused bool
}

pub fn (t AttributeLayerSettings) encode(mut w serializer.Writer) {
	w.le_i32(t.priority)
	w.le_f32(t.weight)
	w.bool(t.enabled)
	w.bool(t.transitions_paused)
}

pub fn AttributeLayerSettings.decode(mut r serializer.Reader) !AttributeLayerSettings {
	return AttributeLayerSettings{
		priority:           r.le_i32()!
		weight:             r.le_f32()!
		enabled:            r.bool()!
		transitions_paused: r.bool()!
	}
}

fn write_optional_i32(mut w serializer.Writer, value ?i32) {
	if v := value {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

fn write_optional_f32(mut w serializer.Writer, value ?f32) {
	if v := value {
		w.bool(true)
		w.le_f32(v)
	} else {
		w.bool(false)
	}
}

pub struct EnvironmentAttributeData {
pub mut:
	attribute_name           string
	from_attribute           ?AttributeData
	attribute                AttributeData = AttributeDataBool{}
	to_attribute             ?AttributeData
	current_transition_ticks u32
	total_transition_ticks   u32
	easing                   string
	local_transition_ticks   u32
	noise_transition         bool
	noise_alignment          NoiseAlignment
}

pub fn (t EnvironmentAttributeData) encode(mut w serializer.Writer) {
	w.write_string(t.attribute_name)
	if v := t.from_attribute {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	t.attribute.encode(mut w)
	if v := t.to_attribute {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.le_u32(t.current_transition_ticks)
	w.le_u32(t.total_transition_ticks)
	w.write_string(t.easing)
	w.le_u32(t.local_transition_ticks)
	w.bool(t.noise_transition)
	t.noise_alignment.encode(mut w)
}

pub fn EnvironmentAttributeData.decode(mut r serializer.Reader) !EnvironmentAttributeData {
	mut t := EnvironmentAttributeData{}
	t.attribute_name = r.read_string()!
	if r.bool()! {
		t.from_attribute = AttributeData.decode(mut r)!
	}
	t.attribute = AttributeData.decode(mut r)!
	if r.bool()! {
		t.to_attribute = AttributeData.decode(mut r)!
	}
	t.current_transition_ticks = r.le_u32()!
	t.total_transition_ticks = r.le_u32()!
	t.easing = r.read_string()!
	t.local_transition_ticks = r.le_u32()!
	t.noise_transition = r.bool()!
	t.noise_alignment = NoiseAlignment.decode(mut r)!
	return t
}

pub enum NoiseAlignmentType as u8 {
	min_local_transition_end = 0
}

pub fn (e NoiseAlignmentType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn NoiseAlignmentType.decode(mut r serializer.Reader) !NoiseAlignmentType {
	return unsafe { NoiseAlignmentType(r.u8()!) }
}

pub struct NoiseAlignment {
pub mut:
	alignment_type NoiseAlignmentType
	value          u32
}

pub fn (t NoiseAlignment) encode(mut w serializer.Writer) {
	t.alignment_type.encode(mut w)
	w.write_varuint32(t.value)
}

pub fn NoiseAlignment.decode(mut r serializer.Reader) !NoiseAlignment {
	return NoiseAlignment{
		alignment_type: NoiseAlignmentType.decode(mut r)!
		value:          r.read_varuint32()!
	}
}

pub struct AttributeDataBool {
pub mut:
	value     bool
	operation ?i32
}

pub struct AttributeDataFloat {
pub mut:
	value          f32
	operation      ?i32
	constraint_min ?f32
	constraint_max ?f32
}

pub struct AttributeDataColor {
pub mut:
	value     i32
	operation ?i32
}

pub type AttributeData = AttributeDataBool | AttributeDataColor | AttributeDataFloat

pub fn (t AttributeData) encode(mut w serializer.Writer) {
	match t {
		AttributeDataBool {
			w.write_varuint32(0)
			w.bool(t.value)
			write_optional_i32(mut w, t.operation)
		}
		AttributeDataFloat {
			w.write_varuint32(1)
			w.le_f32(t.value)
			write_optional_i32(mut w, t.operation)
			write_optional_f32(mut w, t.constraint_min)
			write_optional_f32(mut w, t.constraint_max)
		}
		AttributeDataColor {
			w.write_varuint32(2)
			w.le_i32(t.value)
			write_optional_i32(mut w, t.operation)
		}
	}
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	d := r.read_varuint32()!
	match d {
		0 {
			value := r.bool()!
			mut operation := ?i32(none)
			if r.bool()! {
				operation = r.le_i32()!
			}
			return AttributeDataBool{
				value:     value
				operation: operation
			}
		}
		1 {
			value := r.le_f32()!
			mut operation := ?i32(none)
			if r.bool()! {
				operation = r.le_i32()!
			}
			mut constraint_min := ?f32(none)
			if r.bool()! {
				constraint_min = r.le_f32()!
			}
			mut constraint_max := ?f32(none)
			if r.bool()! {
				constraint_max = r.le_f32()!
			}
			return AttributeDataFloat{
				value:          value
				operation:      operation
				constraint_min: constraint_min
				constraint_max: constraint_max
			}
		}
		2 {
			value := r.le_i32()!
			mut operation := ?i32(none)
			if r.bool()! {
				operation = r.le_i32()!
			}
			return AttributeDataColor{
				value:     value
				operation: operation
			}
		}
		else {
			return error('invalid AttributeData ${d}')
		}
	}
}
