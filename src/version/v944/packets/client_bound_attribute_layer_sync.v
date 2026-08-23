module packets

import protocol.serializer

pub enum BoolAttributeOperation {
	override
	alpha_blend
	and
	nand
	@or
	nor
	xor
	xnor
}

pub fn (e BoolAttributeOperation) str_value() string {
	return match e {
		.override { 'override' }
		.alpha_blend { 'alpha_blend' }
		.and { 'and' }
		.nand { 'nand' }
		.@or { 'or' }
		.nor { 'nor' }
		.xor { 'xor' }
		.xnor { 'xnor' }
	}
}

pub fn (e BoolAttributeOperation) encode(mut w serializer.Writer) {
	w.write_string(e.str_value())
}

pub fn BoolAttributeOperation.decode(mut r serializer.Reader) !BoolAttributeOperation {
	s := r.read_string()!
	return match s {
		'override' { BoolAttributeOperation.override }
		'alpha_blend' { BoolAttributeOperation.alpha_blend }
		'and' { BoolAttributeOperation.and }
		'nand' { BoolAttributeOperation.nand }
		'or' { BoolAttributeOperation.@or }
		'nor' { BoolAttributeOperation.nor }
		'xor' { BoolAttributeOperation.xor }
		'xnor' { BoolAttributeOperation.xnor }
		else { error('invalid BoolAttributeOperation ${s}') }
	}
}

pub enum FloatAttributeOperation {
	override
	alpha_blend
	add
	subtract
	multiply
	minimum
	maximum
}

pub fn (e FloatAttributeOperation) str_value() string {
	return match e {
		.override { 'override' }
		.alpha_blend { 'alpha_blend' }
		.add { 'add' }
		.subtract { 'subtract' }
		.multiply { 'multiply' }
		.minimum { 'minimum' }
		.maximum { 'maximum' }
	}
}

pub fn (e FloatAttributeOperation) encode(mut w serializer.Writer) {
	w.write_string(e.str_value())
}

pub fn FloatAttributeOperation.decode(mut r serializer.Reader) !FloatAttributeOperation {
	s := r.read_string()!
	return match s {
		'override' { FloatAttributeOperation.override }
		'alpha_blend' { FloatAttributeOperation.alpha_blend }
		'add' { FloatAttributeOperation.add }
		'subtract' { FloatAttributeOperation.subtract }
		'multiply' { FloatAttributeOperation.multiply }
		'minimum' { FloatAttributeOperation.minimum }
		'maximum' { FloatAttributeOperation.maximum }
		else { error('invalid FloatAttributeOperation ${s}') }
	}
}

pub enum ColorAttributeOperation {
	override
	alpha_blend
	add
	subtract
	multiply
}

pub fn (e ColorAttributeOperation) str_value() string {
	return match e {
		.override { 'override' }
		.alpha_blend { 'alpha_blend' }
		.add { 'add' }
		.subtract { 'subtract' }
		.multiply { 'multiply' }
	}
}

pub fn (e ColorAttributeOperation) encode(mut w serializer.Writer) {
	w.write_string(e.str_value())
}

pub fn ColorAttributeOperation.decode(mut r serializer.Reader) !ColorAttributeOperation {
	s := r.read_string()!
	return match s {
		'override' { ColorAttributeOperation.override }
		'alpha_blend' { ColorAttributeOperation.alpha_blend }
		'add' { ColorAttributeOperation.add }
		'subtract' { ColorAttributeOperation.subtract }
		'multiply' { ColorAttributeOperation.multiply }
		else { error('invalid ColorAttributeOperation ${s}') }
	}
}

pub struct Color255RgbaString {
pub mut:
	value string
}

pub struct Color255RgbaArray {
pub mut:
	value [4]i32
}

pub type Color255RGBA = Color255RgbaArray | Color255RgbaString

pub fn (t Color255RGBA) encode(mut w serializer.Writer) {
	match t {
		Color255RgbaString {
			w.write_varuint32(0)
			w.write_string(t.value)
		}
		Color255RgbaArray {
			w.write_varuint32(1)
			w.le_i32(t.value[0])
			w.le_i32(t.value[1])
			w.le_i32(t.value[2])
			w.le_i32(t.value[3])
		}
	}
}

pub fn Color255RGBA.decode(mut r serializer.Reader) !Color255RGBA {
	d := r.read_varuint32()!
	match d {
		0 {
			return Color255RgbaString{
				value: r.read_string()!
			}
		}
		1 {
			return Color255RgbaArray{
				value: [r.le_i32()!, r.le_i32()!, r.le_i32()!,
					r.le_i32()!]!
			}
		}
		else {
			return error('invalid Color255RGBA ${d}')
		}
	}
}

pub struct AttributeDataBool {
pub mut:
	value     bool
	operation BoolAttributeOperation
}

pub struct AttributeDataFloat {
pub mut:
	value          f32
	operation      FloatAttributeOperation
	constraint_min f32
	constraint_max f32
}

pub struct AttributeDataColor {
pub mut:
	value     Color255RGBA = Color255RgbaString{}
	operation ColorAttributeOperation
}

pub type AttributeData = AttributeDataBool | AttributeDataColor | AttributeDataFloat

pub fn (t AttributeData) encode(mut w serializer.Writer) {
	match t {
		AttributeDataBool {
			w.write_varuint32(0)
			w.bool(t.value)
			t.operation.encode(mut w)
		}
		AttributeDataFloat {
			w.write_varuint32(1)
			w.le_f32(t.value)
			t.operation.encode(mut w)
			w.le_f32(t.constraint_min)
			w.le_f32(t.constraint_max)
		}
		AttributeDataColor {
			w.write_varuint32(2)
			t.value.encode(mut w)
			t.operation.encode(mut w)
		}
	}
}

pub fn AttributeData.decode(mut r serializer.Reader) !AttributeData {
	d := r.read_varuint32()!
	match d {
		0 {
			return AttributeDataBool{
				value:     r.bool()!
				operation: BoolAttributeOperation.decode(mut r)!
			}
		}
		1 {
			return AttributeDataFloat{
				value:          r.le_f32()!
				operation:      FloatAttributeOperation.decode(mut r)!
				constraint_min: r.le_f32()!
				constraint_max: r.le_f32()!
			}
		}
		2 {
			return AttributeDataColor{
				value:     Color255RGBA.decode(mut r)!
				operation: ColorAttributeOperation.decode(mut r)!
			}
		}
		else {
			return error('invalid AttributeData ${d}')
		}
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
	return t
}

pub struct AttributeLayerWeightFloat {
pub mut:
	value f64
}

pub struct AttributeLayerWeightString {
pub mut:
	value string
}

pub type AttributeLayerWeight = AttributeLayerWeightFloat | AttributeLayerWeightString

pub fn (t AttributeLayerWeight) encode(mut w serializer.Writer) {
	match t {
		AttributeLayerWeightFloat {
			w.write_varuint32(0)
			w.le_f64(t.value)
		}
		AttributeLayerWeightString {
			w.write_varuint32(1)
			w.write_string(t.value)
		}
	}
}

pub fn AttributeLayerWeight.decode(mut r serializer.Reader) !AttributeLayerWeight {
	d := r.read_varuint32()!
	match d {
		0 {
			return AttributeLayerWeightFloat{
				value: r.le_f64()!
			}
		}
		1 {
			return AttributeLayerWeightString{
				value: r.read_string()!
			}
		}
		else {
			return error('invalid AttributeLayerWeight ${d}')
		}
	}
}

pub struct AttributeLayerSettings {
pub mut:
	priority           i32
	weight             AttributeLayerWeight = AttributeLayerWeightFloat{}
	enabled            bool
	transitions_paused bool
}

pub fn (t AttributeLayerSettings) encode(mut w serializer.Writer) {
	w.le_i32(t.priority)
	t.weight.encode(mut w)
	w.bool(t.enabled)
	w.bool(t.transitions_paused)
}

pub fn AttributeLayerSettings.decode(mut r serializer.Reader) !AttributeLayerSettings {
	return AttributeLayerSettings{
		priority:           r.le_i32()!
		weight:             AttributeLayerWeight.decode(mut r)!
		enabled:            r.bool()!
		transitions_paused: r.bool()!
	}
}

pub struct AttributeLayerData {
pub mut:
	name       string
	dimension  i32
	settings   AttributeLayerSettings
	attributes []EnvironmentAttributeData
}

pub fn (t AttributeLayerData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_varint32(t.dimension)
	t.settings.encode(mut w)
	w.write_varuint32(u32(t.attributes.len))
	for e in t.attributes {
		e.encode(mut w)
	}
}

pub fn AttributeLayerData.decode(mut r serializer.Reader) !AttributeLayerData {
	mut t := AttributeLayerData{}
	t.name = r.read_string()!
	t.dimension = r.read_varint32()!
	t.settings = AttributeLayerSettings.decode(mut r)!
	count := r.read_count()!
	t.attributes = []EnvironmentAttributeData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.attributes << EnvironmentAttributeData.decode(mut r)!
	}
	return t
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
			w.write_varuint32(u32(t.attributes.len))
			for e in t.attributes {
				e.encode(mut w)
			}
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
			count := r.read_count()!
			mut layers := []AttributeLayerData{cap: serializer.prealloc(count)}
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
			name := r.read_string()!
			dimension := r.read_varint32()!
			count := r.read_count()!
			mut attributes := []EnvironmentAttributeData{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				attributes << EnvironmentAttributeData.decode(mut r)!
			}
			return UpdateEnvironmentAttributesData{
				name:       name
				dimension:  dimension
				attributes: attributes
			}
		}
		3 {
			name := r.read_string()!
			dimension := r.read_varint32()!
			count := r.read_count()!
			mut attributes := []string{cap: serializer.prealloc(count)}
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
