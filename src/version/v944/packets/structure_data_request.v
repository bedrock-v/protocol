module packets

import protocol.serializer
import protocol.version.v662.enums
import protocol.version.v944.types

pub struct StructureDataRequestPacket {
pub mut:
	structure_name      string
	structure_position  types.NetworkBlockPosition
	structure_settings  types.StructureSettings
	requested_operation enums.StructureTemplateRequestOperation
}

pub fn (p &StructureDataRequestPacket) pid() u16 {
	return 132
}

pub fn (p &StructureDataRequestPacket) name() string {
	return 'StructureDataRequestPacket'
}

pub fn (p &StructureDataRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StructureDataRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_name)
	p.structure_position.encode(mut w)
	p.structure_settings.encode(mut w)
	p.requested_operation.encode(mut w)
}

pub fn (mut p StructureDataRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_name = r.read_string()!
	p.structure_position = types.NetworkBlockPosition.decode(mut r)!
	p.structure_settings = types.StructureSettings.decode(mut r)!
	p.requested_operation = enums.StructureTemplateRequestOperation.decode(mut r)!
}
