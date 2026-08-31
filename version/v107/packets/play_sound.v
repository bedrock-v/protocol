module packets

import protocol.serializer

pub struct PlaySoundPacket {
pub mut:
	string1 string
	x       i32
	y       u32
	z       i32
	float1  f32
	float2  f32
}

pub fn (p &PlaySoundPacket) pid() u16 {
	return 0x56
}

pub fn (p &PlaySoundPacket) name() string {
	return 'PlaySoundPacket'
}

pub fn (p &PlaySoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlaySoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.string1)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.le_f32(p.float1)
	w.le_f32(p.float2)
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.string1 = r.read_string()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.float1 = r.le_f32()!
	p.float2 = r.le_f32()!
}
