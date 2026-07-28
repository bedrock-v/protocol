module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct NetworkSettingsPacket {
pub mut:
	compression_threshold     u16
	compression_algorithm     enums.PacketCompressionAlgorithm
	client_throttle_enabled   bool
	client_throttle_threshold i8
	client_throttle_scalar    f32
}

pub fn (p &NetworkSettingsPacket) pid() u16 {
	return 143
}

pub fn (p &NetworkSettingsPacket) name() string {
	return 'NetworkSettingsPacket'
}

pub fn (p &NetworkSettingsPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &NetworkSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(p.compression_threshold)
	p.compression_algorithm.encode(mut w)
	w.bool(p.client_throttle_enabled)
	w.i8(p.client_throttle_threshold)
	w.le_f32(p.client_throttle_scalar)
}

pub fn (mut p NetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.compression_threshold = r.le_u16()!
	p.compression_algorithm = enums.PacketCompressionAlgorithm.decode(mut r)!
	p.client_throttle_enabled = r.bool()!
	p.client_throttle_threshold = r.i8()!
	p.client_throttle_scalar = r.le_f32()!
}
