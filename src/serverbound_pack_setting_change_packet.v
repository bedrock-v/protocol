module src

import src.serializer
import src.types

pub const pack_setting_type_float = u8(0)
pub const pack_setting_type_bool = u8(1)
pub const pack_setting_type_string = u8(2)

pub struct ServerboundPackSettingChangePacket {
pub mut:
	pack_id      types.UUID
	setting_name string
	setting_type u8
	float_value  f32
	bool_value   bool
	string_value string
}

pub fn (p &ServerboundPackSettingChangePacket) pid() u16 {
	return serverbound_pack_setting_change_packet
}

pub fn (p &ServerboundPackSettingChangePacket) name() string {
	return 'ServerboundPackSettingChangePacket'
}

pub fn (p &ServerboundPackSettingChangePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerboundPackSettingChangePacket) decode_payload(mut r serializer.Reader) ! {
	p.pack_id = r.read_uuid()!
	p.setting_name = r.read_string()!
	p.setting_type = u8(r.read_varuint32()!)
	match p.setting_type {
		pack_setting_type_float { p.float_value = r.le_f32()! }
		pack_setting_type_bool { p.bool_value = r.bool()! }
		pack_setting_type_string { p.string_value = r.read_string()! }
		else {}
	}
}

pub fn (p &ServerboundPackSettingChangePacket) encode_payload(mut w serializer.Writer) {
	w.write_uuid(p.pack_id)
	w.write_string(p.setting_name)
	w.write_varuint32(u32(p.setting_type))
	match p.setting_type {
		pack_setting_type_float { w.le_f32(p.float_value) }
		pack_setting_type_bool { w.bool(p.bool_value) }
		pack_setting_type_string { w.write_string(p.string_value) }
		else {}
	}
}
