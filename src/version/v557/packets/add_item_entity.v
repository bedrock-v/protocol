module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v431.types as types_431
import protocol.version.v557.types

pub struct AddItemEntityPacket {
pub mut:
	unique_entity_id  i64
	runtime_entity_id u64
	item_in_hand      types_431.ItemData
	position          types_291.Vector3f
	motion            types_291.Vector3f
	metadata          []types.DataItem
	from_fishing      bool
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
	w.write_varint64(p.unique_entity_id)
	w.write_varuint64(p.runtime_entity_id)
	p.item_in_hand.encode(mut w)
	p.position.encode(mut w)
	p.motion.encode(mut w)
	types.write_entity_data(mut w, p.metadata)
	w.bool(p.from_fishing)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.runtime_entity_id = r.read_varuint64()!
	p.item_in_hand = types_431.ItemData.decode(mut r)!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector3f.decode(mut r)!
	p.metadata = types.read_entity_data(mut r)!
	p.from_fishing = r.bool()!
}
