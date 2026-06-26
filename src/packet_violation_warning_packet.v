module src

import src.serializer

pub struct PacketViolationWarningPacket {
pub mut:
	type      int
	severity  int
	packet_id int
	message   string
}

pub fn (p &PacketViolationWarningPacket) pid() u16 {
	return packet_violation_warning_packet
}

pub fn (p &PacketViolationWarningPacket) name() string {
	return 'PacketViolationWarningPacket'
}

pub fn (p &PacketViolationWarningPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p PacketViolationWarningPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.read_varint32()!
	p.severity = r.read_varint32()!
	p.packet_id = r.read_varint32()!
	p.message = r.read_string()!
}

pub fn (p &PacketViolationWarningPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.type)
	w.write_varint32(p.severity)
	w.write_varint32(p.packet_id)
	w.write_string(p.message)
}
