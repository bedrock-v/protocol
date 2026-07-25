module packets

import serializer

pub enum SetTitleType as i32 {
	clear          = 0
	reset          = 1
	title          = 2
	subtitle       = 3
	actionbar      = 4
	times          = 5
	title_json     = 6
	subtitle_json  = 7
	actionbar_json = 8
}

pub struct SetTitlePacket {
pub mut:
	title_type    SetTitleType
	text          string
	fade_in_time  i32
	stay_time     i32
	fade_out_time i32
}

pub fn (p &SetTitlePacket) pid() u16 {
	return 88
}

pub fn (p &SetTitlePacket) name() string {
	return 'SetTitlePacket'
}

pub fn (p &SetTitlePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetTitlePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.title_type))
	w.write_string(p.text)
	w.write_varint32(p.fade_in_time)
	w.write_varint32(p.stay_time)
	w.write_varint32(p.fade_out_time)
}

pub fn (mut p SetTitlePacket) decode_payload(mut r serializer.Reader) ! {
	p.title_type = unsafe { SetTitleType(r.read_varint32()!) }
	p.text = r.read_string()!
	p.fade_in_time = r.read_varint32()!
	p.stay_time = r.read_varint32()!
	p.fade_out_time = r.read_varint32()!
}
