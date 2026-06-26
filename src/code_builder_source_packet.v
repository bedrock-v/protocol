module src

import src.serializer

pub struct CodeBuilderSourcePacket {
pub mut:
	operation   int
	category    int
	code_status int
}

pub fn (p &CodeBuilderSourcePacket) pid() u16 {
	return code_builder_source_packet
}

pub fn (p &CodeBuilderSourcePacket) name() string {
	return 'CodeBuilderSourcePacket'
}

pub fn (p &CodeBuilderSourcePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CodeBuilderSourcePacket) decode_payload(mut r serializer.Reader) ! {
	p.operation = int(r.u8()!)
	p.category = int(r.u8()!)
	p.code_status = int(r.u8()!)
}

pub fn (p &CodeBuilderSourcePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.operation))
	w.u8(u8(p.category))
	w.u8(u8(p.code_status))
}
