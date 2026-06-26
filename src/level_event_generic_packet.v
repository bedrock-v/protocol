module src

import src.serializer

pub struct LevelEventGenericPacket {
pub mut:
	event_id  int
	event_data []u8
}

pub fn (p &LevelEventGenericPacket) pid() u16 {
	return level_event_generic_packet
}

pub fn (p &LevelEventGenericPacket) name() string {
	return 'LevelEventGenericPacket'
}

pub fn (p &LevelEventGenericPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LevelEventGenericPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_id = r.read_varint32()!
	p.event_data = r.read_raw(r.remaining())!
}

pub fn (p &LevelEventGenericPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.event_id)
	w.write_raw(p.event_data)
}
