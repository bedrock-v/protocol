module packets

import serializer

pub struct AdventureSettingsPacket {
pub mut:
	flags              u32
	command_permission u32
	flags2             u32
	player_permission  u32
	custom_flags       u32
	entity_unique_id   i64
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 55
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.flags)
	w.write_varuint32(p.command_permission)
	w.write_varuint32(p.flags2)
	w.write_varuint32(p.player_permission)
	w.write_varuint32(p.custom_flags)
	w.le_i64(p.entity_unique_id)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.read_varuint32()!
	p.command_permission = r.read_varuint32()!
	p.flags2 = r.read_varuint32()!
	p.player_permission = r.read_varuint32()!
	p.custom_flags = r.read_varuint32()!
	p.entity_unique_id = r.le_i64()!
}
