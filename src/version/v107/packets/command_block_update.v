module packets

import serializer

pub struct CommandBlockUpdatePacket {
pub mut:
	is_block            bool
	x                   i32
	y                   u32
	z                   i32
	command_block_mode  u32
	is_redstone_mode    bool
	is_conditional      bool
	minecart_eid        u64
	command             string
	last_output         string
	name_str            string
	should_track_output bool
}

pub fn (p &CommandBlockUpdatePacket) pid() u16 {
	return 0x50
}

pub fn (p &CommandBlockUpdatePacket) name() string {
	return 'CommandBlockUpdatePacket'
}

pub fn (p &CommandBlockUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.u8(if p.is_block { u8(1) } else { u8(0) })
	if p.is_block {
		w.write_varint32(p.x)
		w.write_varuint32(p.y)
		w.write_varint32(p.z)
		w.write_varuint32(p.command_block_mode)
		w.u8(if p.is_redstone_mode { u8(1) } else { u8(0) })
		w.u8(if p.is_conditional { u8(1) } else { u8(0) })
	} else {
		w.write_varuint64(p.minecart_eid)
	}
	w.write_string(p.command)
	w.write_string(p.last_output)
	w.write_string(p.name_str)
	w.u8(if p.should_track_output { u8(1) } else { u8(0) })
}

pub fn (mut p CommandBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.is_block = r.u8()! > 0
	if p.is_block {
		p.x = r.read_varint32()!
		p.y = r.read_varuint32()!
		p.z = r.read_varint32()!
		p.command_block_mode = r.read_varuint32()!
		p.is_redstone_mode = r.u8()! > 0
		p.is_conditional = r.u8()! > 0
	} else {
		p.minecart_eid = r.read_varuint64()!
	}
	p.command = r.read_string()!
	p.last_output = r.read_string()!
	p.name_str = r.read_string()!
	p.should_track_output = r.u8()! > 0
}
