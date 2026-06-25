module src

import src.serializer

pub struct CodeBuilderPacket {
pub mut:
	url               string
	open_code_builder bool
}

pub fn (p &CodeBuilderPacket) pid() u16 {
	return code_builder_packet
}

pub fn (p &CodeBuilderPacket) name() string {
	return 'CodeBuilderPacket'
}

pub fn (p &CodeBuilderPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CodeBuilderPacket) decode_payload(mut r serializer.Reader) ! {
	p.url = r.read_string()!
	p.open_code_builder = r.bool()!
}

pub fn (p &CodeBuilderPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.url)
	w.bool(p.open_code_builder)
}
