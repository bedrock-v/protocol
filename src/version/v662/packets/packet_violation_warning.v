module packets

import serializer
import version.v662.enums

pub struct PacketViolationWarningPacket {
pub mut:
	violation_type      enums.PacketViolationType
	violation_severity  enums.PacketViolationSeverity
	violating_packet_id enums.MinecraftPacketIds
	violation_context   string
}

pub fn (p &PacketViolationWarningPacket) pid() u16 { return 156 }

pub fn (p &PacketViolationWarningPacket) name() string { return 'PacketViolationWarningPacket' }

pub fn (p &PacketViolationWarningPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PacketViolationWarningPacket) encode_payload(mut w serializer.Writer) {
	p.violation_type.encode(mut w)
	p.violation_severity.encode(mut w)
	p.violating_packet_id.encode(mut w)
	w.write_string(p.violation_context)
}

pub fn (mut p PacketViolationWarningPacket) decode_payload(mut r serializer.Reader) ! {
	p.violation_type = enums.PacketViolationType.decode(mut r)!
	p.violation_severity = enums.PacketViolationSeverity.decode(mut r)!
	p.violating_packet_id = enums.MinecraftPacketIds.decode(mut r)!
	p.violation_context = r.read_string()!
}
