module packets

import serializer

pub struct AdventureSettingsPacket {
pub mut:
	x        i16
	y        u8
	z        i16
	lines    [4]string
	unknown1 []u8
	unknown2 []u8
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 0xb3
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_raw(p.unknown1)
	w.write_raw(p.unknown2)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i16()!
	p.y = r.u8()!
	p.z = r.be_i16()!
	for i in 0 .. 4 {
		l := int(r.le_i16()!)
		p.lines[i] = r.read_raw(l)!.bytestr()
	}
}
