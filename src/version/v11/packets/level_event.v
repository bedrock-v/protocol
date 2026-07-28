module packets

import protocol.serializer

pub struct LevelEventPacket {
pub mut:
	unknown1 i16
	unknown2 i16
	unknown3 i16
	unknown4 i16
	unknown5 i32
}

pub fn (p &LevelEventPacket) pid() u16 {
	return 0x9a
}

pub fn (p &LevelEventPacket) name() string {
	return 'LevelEventPacket'
}

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	w.be_i16(p.unknown1)
	w.be_i16(p.unknown2)
	w.be_i16(p.unknown3)
	w.be_i16(p.unknown4)
	w.be_i32(p.unknown5)
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown1 = r.be_i16()!
	p.unknown2 = r.be_i16()!
	p.unknown3 = r.be_i16()!
	p.unknown4 = r.be_i16()!
	p.unknown5 = r.be_i32()!
}
