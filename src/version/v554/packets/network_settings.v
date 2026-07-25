module packets

import serializer

pub enum PacketCompressionAlgorithm as u16 {
	zlib   = 0
	snappy = 1
	@none  = 2
}

pub struct NetworkSettingsPacket {
pub mut:
	compression_threshold     u16
	compression_algorithm     PacketCompressionAlgorithm
	client_throttle_enabled   bool
	client_throttle_threshold u8
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
	w.le_u16(u16(p.compression_algorithm))
	w.bool(p.client_throttle_enabled)
	w.u8(p.client_throttle_threshold)
	w.le_f32(p.client_throttle_scalar)
}

pub fn (mut p NetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.compression_threshold = r.le_u16()!
	p.compression_algorithm = unsafe { PacketCompressionAlgorithm(r.le_u16()!) }
	p.client_throttle_enabled = r.bool()!
	p.client_throttle_threshold = r.u8()!
	p.client_throttle_scalar = r.le_f32()!
}
