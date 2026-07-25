module packets

import serializer

pub struct PassengerJumpPacket {
pub mut:
	jump_scale i32
}

pub fn (p &PassengerJumpPacket) pid() u16 { return 20 }

pub fn (p &PassengerJumpPacket) name() string { return 'PassengerJumpPacket' }

pub fn (p &PassengerJumpPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PassengerJumpPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.jump_scale)
}

pub fn (mut p PassengerJumpPacket) decode_payload(mut r serializer.Reader) ! {
	p.jump_scale = r.read_varint32()!
}
