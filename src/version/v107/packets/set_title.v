module packets

import protocol.serializer

pub struct SetTitlePacket {
pub mut:
	type          i32
	text          string
	fade_in_time  i32
	stay_time     i32
	fade_out_time i32
}

pub fn (p &SetTitlePacket) pid() u16 {
	return 0x58
}

pub fn (p &SetTitlePacket) name() string {
	return 'SetTitlePacket'
}

pub fn (p &SetTitlePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetTitlePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.type)
	w.write_string(p.text)
	w.write_varint32(p.fade_in_time)
	w.write_varint32(p.stay_time)
	w.write_varint32(p.fade_out_time)
}

pub fn (mut p SetTitlePacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.read_varint32()!
	p.text = r.read_string()!
	p.fade_in_time = r.read_varint32()!
	p.stay_time = r.read_varint32()!
	p.fade_out_time = r.read_varint32()!
}
