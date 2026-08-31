module packets

import protocol.serializer
import protocol.version.v662.types

pub struct EntityOverrideClear {}

pub struct EntityOverrideRemove {}

pub struct EntityOverrideSetInt {
pub mut:
	value i32
}

pub struct EntityOverrideSetFloat {
pub mut:
	value f32
}

pub type EntityOverrideUpdateType = EntityOverrideClear
	| EntityOverrideRemove
	| EntityOverrideSetFloat
	| EntityOverrideSetInt

pub fn (t EntityOverrideUpdateType) encode(mut w serializer.Writer) {
	match t {
		EntityOverrideClear {
			w.i8(0)
		}
		EntityOverrideRemove {
			w.i8(1)
		}
		EntityOverrideSetInt {
			w.i8(2)
			w.le_i32(t.value)
		}
		EntityOverrideSetFloat {
			w.i8(3)
			w.le_f32(t.value)
		}
	}
}

pub fn EntityOverrideUpdateType.decode(mut r serializer.Reader) !EntityOverrideUpdateType {
	d := r.i8()!
	match d {
		0 {
			return EntityOverrideClear{}
		}
		1 {
			return EntityOverrideRemove{}
		}
		2 {
			return EntityOverrideSetInt{
				value: r.le_i32()!
			}
		}
		3 {
			return EntityOverrideSetFloat{
				value: r.le_f32()!
			}
		}
		else {
			return error('invalid EntityOverrideUpdateType ${d}')
		}
	}
}

pub struct PlayerUpdateEntityOverridesPacket {
pub mut:
	entity_unique_id types.ActorUniqueID
	property_index   u32
	update_type      EntityOverrideUpdateType = EntityOverrideClear{}
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
	p.entity_unique_id = types.ActorUniqueID.decode(mut r)!
	p.property_index = r.read_varuint32()!
	p.update_type = EntityOverrideUpdateType.decode(mut r)!
}
