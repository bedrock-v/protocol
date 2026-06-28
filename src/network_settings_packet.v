module protocol

import serializer

pub struct NetworkSettingsPacket {
pub mut:
	compression_threshold   int
	compression_algorithm   int
	enable_client_throttling bool
	client_throttle_threshold int
	client_throttle_scalar  f32
}

pub fn (p &NetworkSettingsPacket) pid() u16 {
	return network_settings_packet
}

pub fn (p &NetworkSettingsPacket) name() string {
	return 'NetworkSettingsPacket'
}

pub fn (p &NetworkSettingsPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p NetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.compression_threshold = int(r.le_u16()!)
	p.compression_algorithm = int(r.le_u16()!)
	p.enable_client_throttling = r.bool()!
	p.client_throttle_threshold = int(r.u8()!)
	p.client_throttle_scalar = r.le_f32()!
}

pub fn (p &NetworkSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(u16(p.compression_threshold))
	w.le_u16(u16(p.compression_algorithm))
	w.bool(p.enable_client_throttling)
	w.u8(u8(p.client_throttle_threshold))
	w.le_f32(p.client_throttle_scalar)
}
