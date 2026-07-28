module packets

import protocol.serializer

pub struct ShowCreditsPacket {
pub mut:
	player_eid u64
	status     i32
}

pub fn (p &ShowCreditsPacket) pid() u16 {
	return 0x4d
}

pub fn (p &ShowCreditsPacket) name() string {
	return 'ShowCreditsPacket'
}

pub fn (p &ShowCreditsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ShowCreditsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.player_eid)
	w.write_varint32(p.status)
}

pub fn (mut p ShowCreditsPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_eid = r.read_varuint64()!
	p.status = r.read_varint32()!
}
