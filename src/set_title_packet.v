module src

import src.serializer

pub struct SetTitlePacket {
pub mut:
	type                int
	text                string
	fade_in_time        int
	stay_time           int
	fade_out_time       int
	xuid                string
	platform_online_id  string
	filtered_title_text string
}

pub fn (p &SetTitlePacket) pid() u16 {
	return set_title_packet
}

pub fn (p &SetTitlePacket) name() string {
	return 'SetTitlePacket'
}

pub fn (p &SetTitlePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetTitlePacket) decode_payload(mut r serializer.Reader) ! {
	p.type = int(r.read_varint32()!)
	p.text = r.read_string()!
	p.fade_in_time = int(r.read_varint32()!)
	p.stay_time = int(r.read_varint32()!)
	p.fade_out_time = int(r.read_varint32()!)
	p.xuid = r.read_string()!
	p.platform_online_id = r.read_string()!
	p.filtered_title_text = r.read_string()!
}

pub fn (p &SetTitlePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.type))
	w.write_string(p.text)
	w.write_varint32(i32(p.fade_in_time))
	w.write_varint32(i32(p.stay_time))
	w.write_varint32(i32(p.fade_out_time))
	w.write_string(p.xuid)
	w.write_string(p.platform_online_id)
	w.write_string(p.filtered_title_text)
}
