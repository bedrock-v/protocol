module packets

import serializer
import version.v557.types

pub struct SetEntityDataPacket {
pub mut:
	runtime_entity_id u64
	metadata          []types.DataItem
	properties        types.EntityProperties
	tick              u64
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
	p.properties.encode(mut w)
	w.write_varuint64(p.tick)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.metadata = types.read_entity_data(mut r)!
	p.properties = types.EntityProperties.decode(mut r)!
	p.tick = r.read_varuint64()!
}
