module packets

import protocol.serializer
import protocol.version.v137.types

pub struct SetEntityDataPacket {
pub mut:
	entity_runtime_id u64
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
	w.write_varuint64(p.entity_runtime_id)
	types.write_entity_data(mut w, p.metadata)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.metadata = types.read_entity_data(mut r)!
}
