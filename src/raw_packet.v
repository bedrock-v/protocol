module protocol

import protocol.serializer

// RawPacket carries a pre-encoded payload for a packet the library has no
// typed definition for, so captured payloads can be replayed verbatim.
pub struct RawPacket {
pub mut:
	packet_id u16
	raw_name  string
	payload   []u8
}

pub fn (p &RawPacket) pid() u16 {
	return p.packet_id
}

pub fn (p &RawPacket) name() string {
	return p.raw_name
}

pub fn (p &RawPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RawPacket) encode_payload(mut w serializer.Writer) {
	w.write_raw(p.payload)
}

pub fn (mut p RawPacket) decode_payload(mut r serializer.Reader) ! {
	p.payload = r.read_raw(r.remaining())!
}
