module src

import src.serializer

pub struct EduUriResourcePacket {
pub mut:
	button_name string
	link_uri    string
}

pub fn (p &EduUriResourcePacket) pid() u16 {
	return edu_uri_resource_packet
}

pub fn (p &EduUriResourcePacket) name() string {
	return 'EduUriResourcePacket'
}

pub fn (p &EduUriResourcePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p EduUriResourcePacket) decode_payload(mut r serializer.Reader) ! {
	p.button_name = r.read_string()!
	p.link_uri = r.read_string()!
}

pub fn (p &EduUriResourcePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.button_name)
	w.write_string(p.link_uri)
}
