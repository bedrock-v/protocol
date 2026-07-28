module packets

import protocol.serializer
import protocol.version.v354.types

pub struct SetEntityDataPacket {
pub mut:
	runtime_entity_id u64
	metadata          []types.DataItem
}

pub fn (p &SetEntityDataPacket) pid() u16 {
	return 39
}

pub fn (p &SetEntityDataPacket) name() string {
	return 'SetEntityDataPacket'
}

pub fn (p &SetEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	types.write_entity_data(mut w, p.metadata)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.metadata = types.read_entity_data(mut r)!
}
