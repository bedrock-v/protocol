module packets

import protocol.serializer
import protocol.version.v137.types

pub struct AddItemEntityPacket {
pub mut:
	entity_unique_id  i64
	entity_runtime_id u64
	item              types.ItemData
	position          types.Vector3f
	motion            types.Vector3f
	metadata          []types.DataItem
	is_from_fishing   bool
}

pub fn (p &AddItemEntityPacket) pid() u16 {
	return 15
}

pub fn (p &AddItemEntityPacket) name() string {
	return 'AddItemEntityPacket'
}

pub fn (p &AddItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	p.item.encode(mut w)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	types.write_entity_data(mut w, p.metadata)
	w.bool(p.is_from_fishing)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.item = types.ItemData.decode(mut r)!
	p.position = types.Vector3f.decode(mut r)!
	p.motion = types.Vector3f.decode(mut r)!
	p.metadata = types.read_entity_data(mut r)!
	p.is_from_fishing = r.bool()!
}
