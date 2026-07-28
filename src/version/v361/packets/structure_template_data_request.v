module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v361.types

pub struct StructureTemplateDataRequestPacket {
pub mut:
	name      string
	position  types_291.BlockPosition
	settings  types.StructureSettings
	operation u8
}

pub fn (p &StructureTemplateDataRequestPacket) pid() u16 {
	return 132
}

pub fn (p &StructureTemplateDataRequestPacket) name() string {
	return 'StructureTemplateDataRequestPacket'
}

pub fn (p &StructureTemplateDataRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StructureTemplateDataRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.name)
	p.position.encode(mut w)
	p.settings.encode(mut w)
	w.u8(p.operation)
}

pub fn (mut p StructureTemplateDataRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.name = r.read_string()!
	p.position = types_291.BlockPosition.decode(mut r)!
	p.settings = types.StructureSettings.decode(mut r)!
	p.operation = r.u8()!
}
