module packets

import serializer

pub struct EventPacket {
pub mut:
	player_runtime_id u64
	event_data        i32
	type              u8
}

pub fn (p &EventPacket) pid() u16 {
	return 65
}

pub fn (p &EventPacket) name() string {
	return 'EventPacket'
}

pub fn (p &EventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.player_runtime_id)
	w.write_varint32(p.event_data)
	w.u8(p.type)
}

pub fn (mut p EventPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_runtime_id = r.read_varuint64()!
	p.event_data = r.read_varint32()!
	p.type = r.u8()!
}
