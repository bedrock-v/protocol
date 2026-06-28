module protocol

import serializer
import types

pub struct LevelEventPacket {
pub mut:
	event_id   int
	position   types.Vector3
	event_data int
}

pub fn (p &LevelEventPacket) pid() u16 {
	return level_event_packet
}

pub fn (p &LevelEventPacket) name() string {
	return 'LevelEventPacket'
}

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_id = int(r.read_varint32()!)
	p.position = r.read_vector3()!
	p.event_data = int(r.read_varint32()!)
}

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.event_id))
	w.write_vector3(p.position)
	w.write_varint32(i32(p.event_data))
}
