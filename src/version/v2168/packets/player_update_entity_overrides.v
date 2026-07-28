module packets

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct UpdateTypeClearOverrides {}

pub struct UpdateTypeRemoveOverride {}

pub struct UpdateTypeSetIntOverride {
pub mut:
	value i32
}

pub struct UpdateTypeSetFloatOverride {
pub mut:
	value f32
}

pub type UpdateType = UpdateTypeClearOverrides
	| UpdateTypeRemoveOverride
	| UpdateTypeSetFloatOverride
	| UpdateTypeSetIntOverride

pub fn (t UpdateType) type_id() u32 {
	return match t {
		UpdateTypeClearOverrides { u32(0) }
		UpdateTypeRemoveOverride { u32(1) }
		UpdateTypeSetIntOverride { u32(2) }
		UpdateTypeSetFloatOverride { u32(3) }
	}
}

pub fn (t UpdateType) string_id() string {
	return match t {
		UpdateTypeClearOverrides { 'clearoverrides' }
		UpdateTypeRemoveOverride { 'removeoverride' }
		UpdateTypeSetIntOverride { 'setintoverride' }
		UpdateTypeSetFloatOverride { 'setfloatoverride' }
	}
}

pub fn (t UpdateType) encode(mut w serializer.Writer) {
	w.write_varuint32(t.type_id())
	w.write_string(t.string_id())
	match t {
		UpdateTypeClearOverrides {}
		UpdateTypeRemoveOverride {}
		UpdateTypeSetIntOverride { w.le_i32(t.value) }
		UpdateTypeSetFloatOverride { w.le_f32(t.value) }
	}
}

pub fn UpdateType.decode(mut r serializer.Reader) !UpdateType {
	d := r.read_varuint32()!
	r.read_string()!
	match d {
		0 { return UpdateTypeClearOverrides{} }
		1 { return UpdateTypeRemoveOverride{} }
		2 { return UpdateTypeSetIntOverride{
				value: r.le_i32()!
			} }
		3 { return UpdateTypeSetFloatOverride{
				value: r.le_f32()!
			} }
		else { return error('invalid UpdateType ${d}') }
	}
}

pub struct PlayerUpdateEntityOverridesPacket {
pub mut:
	entity_unique_id types_662.ActorUniqueID
	property_index   u32
	update_type      UpdateType = UpdateTypeClearOverrides{}
}

pub fn (p &PlayerUpdateEntityOverridesPacket) pid() u16 {
	return 325
}

pub fn (p &PlayerUpdateEntityOverridesPacket) name() string {
	return 'PlayerUpdateEntityOverridesPacket'
}

pub fn (p &PlayerUpdateEntityOverridesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerUpdateEntityOverridesPacket) encode_payload(mut w serializer.Writer) {
	p.entity_unique_id.encode(mut w)
	w.write_varuint32(p.property_index)
	p.update_type.encode(mut w)
}

pub fn (mut p PlayerUpdateEntityOverridesPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = types_662.ActorUniqueID.decode(mut r)!
	p.property_index = r.read_varuint32()!
	p.update_type = UpdateType.decode(mut r)!
}
