module packets

import protocol.serializer

pub enum PacketViolationType as i32 {
	unknown          = -1
	malformed_packet = 0
}

pub enum PacketViolationSeverity as i32 {
	unknown                = -1
	warning                = 0
	final_warning          = 1
	terminating_connection = 2
}

pub struct PacketViolationWarningPacket {
pub mut:
	violation_type  PacketViolationType
	severity        PacketViolationSeverity
	packet_cause_id i32
	context         string
}

pub fn (p &PacketViolationWarningPacket) pid() u16 {
	return 156
}

pub fn (p &PacketViolationWarningPacket) name() string {
	return 'PacketViolationWarningPacket'
}

pub fn (p &PacketViolationWarningPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PacketViolationWarningPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.violation_type))
	w.write_varint32(i32(p.severity))
	w.write_varint32(p.packet_cause_id)
	w.write_string(p.context)
}

pub fn (mut p PacketViolationWarningPacket) decode_payload(mut r serializer.Reader) ! {
	p.violation_type = unsafe { PacketViolationType(r.read_varint32()!) }
	p.severity = unsafe { PacketViolationSeverity(r.read_varint32()!) }
	p.packet_cause_id = r.read_varint32()!
	p.context = r.read_string()!
}
