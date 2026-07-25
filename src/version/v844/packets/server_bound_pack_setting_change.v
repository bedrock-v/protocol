module packets

import serializer
import version.v662.types

pub struct PackSettingFloat {
pub mut:
	value f32
}

pub struct PackSettingBool {
pub mut:
	value bool
}

pub struct PackSettingString {
pub mut:
	value string
}

pub type PackSettingValue = PackSettingBool | PackSettingFloat | PackSettingString

pub fn (t PackSettingValue) encode(mut w serializer.Writer) {
	match t {
		PackSettingFloat {
			w.write_varuint32(0)
			w.le_f32(t.value)
		}
		PackSettingBool {
			w.write_varuint32(1)
			w.bool(t.value)
		}
		PackSettingString {
			w.write_varuint32(2)
			w.write_string(t.value)
		}
	}
}

pub fn PackSettingValue.decode(mut r serializer.Reader) !PackSettingValue {
	d := r.read_varuint32()!
	match d {
		0 { return PackSettingFloat{ value: r.le_f32()! } }
		1 { return PackSettingBool{ value: r.bool()! } }
		2 { return PackSettingString{ value: r.read_string()! } }
		else { return error('invalid PackSettingValue ${d}') }
	}
}

pub struct PackSetting {
pub mut:
	name  string
	value PackSettingValue = PackSettingFloat{}
}

pub fn (t PackSetting) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	t.value.encode(mut w)
}

pub fn PackSetting.decode(mut r serializer.Reader) !PackSetting {
	return PackSetting{
		name:  r.read_string()!
		value: PackSettingValue.decode(mut r)!
	}
}

pub struct ServerBoundPackSettingChangePacket {
pub mut:
	pack_id      types.Uuid
	pack_setting PackSetting
}

pub fn (p &ServerBoundPackSettingChangePacket) pid() u16 { return 329 }

pub fn (p &ServerBoundPackSettingChangePacket) name() string { return 'ServerBoundPackSettingChangePacket' }

pub fn (p &ServerBoundPackSettingChangePacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerBoundPackSettingChangePacket) encode_payload(mut w serializer.Writer) {
	p.pack_id.encode(mut w)
	p.pack_setting.encode(mut w)
}

pub fn (mut p ServerBoundPackSettingChangePacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = types.Uuid.decode(mut r)!
	p.pack_setting = PackSetting.decode(mut r)!
}
