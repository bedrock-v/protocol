module packets

import serializer

pub struct LevelEventPacket {
pub mut:
	event_id i32
	position [3]f32
	data     i32
}

pub fn (p &LevelEventPacket) pid() u16 { return 25 }

pub fn (p &LevelEventPacket) name() string { return 'LevelEventPacket' }

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool { return false }

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.event_id)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.data)
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_id = r.read_varint32()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.data = r.read_varint32()!
}
