module serializer

import src.types

pub fn (mut r Reader) read_string() !string {
	length := int(r.read_varuint32()!)
	return r.read_raw(length)!.bytestr()
}

pub fn (mut w Writer) write_string(v string) {
	w.write_varuint32(u32(v.len))
	w.write_raw(v.bytes())
}

pub fn (mut r Reader) read_string_bytes() ![]u8 {
	length := int(r.read_varuint32()!)
	return r.read_raw(length)!
}

pub fn (mut w Writer) write_string_bytes(v []u8) {
	w.write_varuint32(u32(v.len))
	w.write_raw(v)
}

pub fn (mut r Reader) read_actor_unique_id() !i64 {
	return r.read_varint64()!
}

pub fn (mut w Writer) write_actor_unique_id(v i64) {
	w.write_varint64(v)
}

pub fn (mut r Reader) read_actor_runtime_id() !u64 {
	return r.read_varuint64()!
}

pub fn (mut w Writer) write_actor_runtime_id(v u64) {
	w.write_varuint64(v)
}

pub fn (mut r Reader) read_vector3() !types.Vector3 {
	return types.Vector3{
		x: r.le_f32()!
		y: r.le_f32()!
		z: r.le_f32()!
	}
}

pub fn (mut w Writer) write_vector3(v types.Vector3) {
	w.le_f32(v.x)
	w.le_f32(v.y)
	w.le_f32(v.z)
}

pub fn (mut r Reader) read_vector2() !types.Vector2 {
	return types.Vector2{
		x: r.le_f32()!
		y: r.le_f32()!
	}
}

pub fn (mut w Writer) write_vector2(v types.Vector2) {
	w.le_f32(v.x)
	w.le_f32(v.y)
}

pub fn (mut r Reader) read_block_position() !types.BlockPosition {
	return types.BlockPosition{
		x: int(r.read_varint32()!)
		y: int(r.read_varint32()!)
		z: int(r.read_varint32()!)
	}
}

pub fn (mut w Writer) write_block_position(v types.BlockPosition) {
	w.write_varint32(i32(v.x))
	w.write_varint32(i32(v.y))
	w.write_varint32(i32(v.z))
}

pub fn (mut r Reader) read_rotation_byte() !f32 {
	return f32(r.u8()!) * (360.0 / 256.0)
}

pub fn (mut w Writer) write_rotation_byte(v f32) {
	w.u8(u8(int(v / (360.0 / 256.0)) & 0xff))
}

pub fn (mut r Reader) read_uuid() !types.UUID {
	mut p1 := r.read_raw(8)!
	mut p2 := r.read_raw(8)!
	p1.reverse_in_place()
	p2.reverse_in_place()
	p1 << p2
	return types.uuid_from_bytes(p1)
}

pub fn (mut w Writer) write_uuid(u types.UUID) {
	b := u.to_array()
	mut p1 := b[0..8].clone()
	mut p2 := b[8..16].clone()
	p1.reverse_in_place()
	p2.reverse_in_place()
	w.write_raw(p1)
	w.write_raw(p2)
}
