module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v431.enums

pub struct LevelEventPacket {
pub mut:
	event_type enums.LevelEvent
	position   types_291.Vector3f
	data       i32
}

pub fn (p &LevelEventPacket) pid() u16 {
	return 25
}

pub fn (p &LevelEventPacket) name() string {
	return 'LevelEventPacket'
}

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	p.event_type.encode(mut w)
	p.position.encode(mut w)
	w.write_varint32(p.data)
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_type = enums.LevelEvent.decode(mut r)!
	p.position = types_291.Vector3f.decode(mut r)!
	p.data = r.read_varint32()!
}
