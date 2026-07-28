module packets

import protocol.serializer

pub struct AdventureSettingsPacket {
pub mut:
	flags           u32
	user_permission u32
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 0x38
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.flags)
	w.write_varuint32(p.user_permission)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.read_varuint32()!
	p.user_permission = r.read_varuint32()!
}
