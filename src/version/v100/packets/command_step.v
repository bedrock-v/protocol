module packets

import serializer

pub struct CommandStepPacket {
pub mut:
	command   string
	overload  string
	uvarint1  u32
	uvarint2  u32
	flag      bool
	uvarint64 u32
	args      string
	string4   string
	trailing  []u8
}

pub fn (p &CommandStepPacket) pid() u16 {
	return 0x4e
}

pub fn (p &CommandStepPacket) name() string {
	return 'CommandStepPacket'
}

pub fn (p &CommandStepPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandStepPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	w.write_string(p.overload)
	w.write_varuint32(p.uvarint1)
	w.write_varuint32(p.uvarint2)
	w.u8(if p.flag { u8(1) } else { u8(0) })
	w.write_varuint32(p.uvarint64)
	w.write_string(p.args)
	w.write_string(p.string4)
	w.write_raw(p.trailing)
}

pub fn (mut p CommandStepPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.overload = r.read_string()!
	p.uvarint1 = r.read_varuint32()!
	p.uvarint2 = r.read_varuint32()!
	p.flag = r.u8()! > 0
	p.uvarint64 = r.read_varuint32()!
	p.args = r.read_string()!
	p.string4 = r.read_string()!
	p.trailing = r.read_raw(r.remaining())!
}
