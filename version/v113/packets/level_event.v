module packets

import protocol.serializer

pub struct LevelEventPacket {
pub mut:
	evid i32
	x    f32
	y    f32
	z    f32
	data i32
}

pub fn (p &LevelEventPacket) pid() u16 {
	return 0x1a
}

pub fn (p &LevelEventPacket) name() string {
	return 'LevelEventPacket'
}

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.evid)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.write_varint32(p.data)
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.evid = r.read_varint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.data = r.read_varint32()!
}
