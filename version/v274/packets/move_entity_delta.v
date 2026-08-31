module packets

import protocol.serializer

pub struct MoveEntityDeltaPacket {
pub mut:
	flags  u8
	x_diff i32
	y_diff i32
	z_diff i32
	x_rot  u8
	y_rot  u8
	z_rot  u8
}

pub fn (p &MoveEntityDeltaPacket) pid() u16 {
	return 111
}

pub fn (p &MoveEntityDeltaPacket) name() string {
	return 'MoveEntityDeltaPacket'
}

pub fn (p &MoveEntityDeltaPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityDeltaPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.flags)
	if p.flags & 0x01 != 0 {
		w.write_varint32(p.x_diff)
	}
	if p.flags & 0x02 != 0 {
		w.write_varint32(p.y_diff)
	}
	if p.flags & 0x04 != 0 {
		w.write_varint32(p.z_diff)
	}
	if p.flags & 0x08 != 0 {
		w.u8(p.x_rot)
	}
	if p.flags & 0x10 != 0 {
		w.u8(p.y_rot)
	}
	if p.flags & 0x20 != 0 {
		w.u8(p.z_rot)
	}
}

pub fn (mut p MoveEntityDeltaPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.u8()!
	if p.flags & 0x01 != 0 {
		p.x_diff = r.read_varint32()!
	}
	if p.flags & 0x02 != 0 {
		p.y_diff = r.read_varint32()!
	}
	if p.flags & 0x04 != 0 {
		p.z_diff = r.read_varint32()!
	}
	if p.flags & 0x08 != 0 {
		p.x_rot = r.u8()!
	}
	if p.flags & 0x10 != 0 {
		p.y_rot = r.u8()!
	}
	if p.flags & 0x20 != 0 {
		p.z_rot = r.u8()!
	}
}
