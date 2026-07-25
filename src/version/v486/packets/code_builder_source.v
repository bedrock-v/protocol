module packets

import serializer

pub enum CodeBuilderOperationType as u8 {
	@none = 0
	get   = 1
	set   = 2
	reset = 3
}

pub enum CodeBuilderCategoryType as u8 {
	@none         = 0
	code_status   = 1
	instantiation = 2
}

pub struct CodeBuilderSourcePacket {
pub mut:
	operation CodeBuilderOperationType
	category  CodeBuilderCategoryType
	value     string
}

pub fn (p &CodeBuilderSourcePacket) pid() u16 {
	return 178
}

pub fn (p &CodeBuilderSourcePacket) name() string {
	return 'CodeBuilderSourcePacket'
}

pub fn (p &CodeBuilderSourcePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CodeBuilderSourcePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.operation))
	w.u8(u8(p.category))
	w.write_string(p.value)
}

pub fn (mut p CodeBuilderSourcePacket) decode_payload(mut r serializer.Reader) ! {
	p.operation = unsafe { CodeBuilderOperationType(r.u8()!) }
	p.category = unsafe { CodeBuilderCategoryType(r.u8()!) }
	p.value = r.read_string()!
}
