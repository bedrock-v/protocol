module packets

import protocol.serializer
import protocol.version.v113.types

pub struct AddItemEntityPacket {
pub mut:
	entity_unique_id  i64
	entity_runtime_id u64
	item              types.EraBItem
	x                 f32
	y                 f32
	z                 f32
	speed_x           f32
	speed_y           f32
	speed_z           f32
	metadata          types.EraBMetadata
}

pub fn (p &AddItemEntityPacket) pid() u16 {
	return 0x0f
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
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.speed_x)
	w.le_f32(p.speed_y)
	w.le_f32(p.speed_z)
	p.metadata.encode(mut w)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.item = types.EraBItem.decode(mut r)!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.speed_x = r.le_f32()!
	p.speed_y = r.le_f32()!
	p.speed_z = r.le_f32()!
	p.metadata = types.EraBMetadata.decode(mut r)!
}
