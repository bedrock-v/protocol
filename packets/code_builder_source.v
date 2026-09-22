module packets

import protocol.serializer
import protocol.enums

pub struct CodeBuilderSourcePacket {
pub mut:
	operation   enums.CodeBuilderStorageOperation
	category    enums.CodeBuilderStorageCategory
	code_status enums.CodeBuilderCodeStatus
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
	p.operation.encode(mut w)
	p.category.encode(mut w)
	p.code_status.encode(mut w)
}

pub fn (mut p CodeBuilderSourcePacket) decode_payload(mut r serializer.Reader) ! {
	p.operation = enums.CodeBuilderStorageOperation.decode(mut r)!
	p.category = enums.CodeBuilderStorageCategory.decode(mut r)!
	p.code_status = enums.CodeBuilderCodeStatus.decode(mut r)!
}
