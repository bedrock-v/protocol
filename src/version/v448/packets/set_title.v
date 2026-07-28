module packets

import protocol.serializer
import protocol.version.v291.packets as packets_291

pub struct SetTitlePacket {
pub mut:
	title_type         packets_291.SetTitleType
	text               string
	fade_in_time       i32
	stay_time          i32
	fade_out_time      i32
	xuid               string
	platform_online_id string
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
	w.write_string(p.xuid)
	w.write_string(p.platform_online_id)
}

pub fn (mut p SetTitlePacket) decode_payload(mut r serializer.Reader) ! {
	p.title_type = unsafe { packets_291.SetTitleType(r.read_varint32()!) }
	p.text = r.read_string()!
	p.fade_in_time = r.read_varint32()!
	p.stay_time = r.read_varint32()!
	p.fade_out_time = r.read_varint32()!
	p.xuid = r.read_string()!
	p.platform_online_id = r.read_string()!
}
