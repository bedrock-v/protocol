module packets

import serializer
import version.v137.types

pub struct AddPaintingPacket {
pub mut:
	entity_unique_id  i64
	entity_runtime_id u64
	position          types.BlockPosition
	direction         i32
	title             string
}

pub fn (p &AddPaintingPacket) pid() u16 {
	return 22
}

pub fn (p &AddPaintingPacket) name() string {
	return 'AddPaintingPacket'
}

pub fn (p &AddPaintingPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddPaintingPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	p.position.encode(mut w)
	w.write_varint32(p.direction)
	w.write_string(p.title)
}

pub fn (mut p AddPaintingPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.position = types.BlockPosition.decode(mut r)!
	p.direction = r.read_varint32()!
	p.title = r.read_string()!
}
