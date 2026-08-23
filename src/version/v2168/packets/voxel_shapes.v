module packets

import protocol.serializer

pub struct VoxelShapeNameEntry {
pub mut:
	name string
	id   u16
}

pub fn (t VoxelShapeNameEntry) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_u16(t.id)
}

pub fn VoxelShapeNameEntry.decode(mut r serializer.Reader) !VoxelShapeNameEntry {
	return VoxelShapeNameEntry{
		name: r.read_string()!
		id:   r.le_u16()!
	}
}

pub struct VoxelCells {
pub mut:
	x_size  u8
	y_size  u8
	z_size  u8
	storage []u8
}

pub fn (t VoxelCells) encode(mut w serializer.Writer) {
	w.u8(t.x_size)
	w.u8(t.y_size)
	w.u8(t.z_size)
	w.write_varuint32(u32(t.storage.len))
	for b in t.storage {
		w.u8(b)
	}
}

pub fn VoxelCells.decode(mut r serializer.Reader) !VoxelCells {
	mut t := VoxelCells{
		x_size: r.u8()!
		y_size: r.u8()!
		z_size: r.u8()!
	}
	count := r.read_count()!
	t.storage = []u8{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.storage << r.u8()!
	}
	return t
}

pub struct VoxelShape {
pub mut:
	cells         VoxelCells
	x_coordinates []f32
	y_coordinates []f32
	z_coordinates []f32
}

pub fn (t VoxelShape) encode(mut w serializer.Writer) {
	t.cells.encode(mut w)
	encode_f32_slice(mut w, t.x_coordinates)
	encode_f32_slice(mut w, t.y_coordinates)
	encode_f32_slice(mut w, t.z_coordinates)
}

pub fn VoxelShape.decode(mut r serializer.Reader) !VoxelShape {
	return VoxelShape{
		cells:         VoxelCells.decode(mut r)!
		x_coordinates: decode_f32_slice(mut r)!
		y_coordinates: decode_f32_slice(mut r)!
		z_coordinates: decode_f32_slice(mut r)!
	}
}

fn encode_f32_slice(mut w serializer.Writer, values []f32) {
	w.write_varuint32(u32(values.len))
	for v in values {
		w.le_f32(v)
	}
}

fn decode_f32_slice(mut r serializer.Reader) ![]f32 {
	count := r.read_count()!
	mut out := []f32{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		out << r.le_f32()!
	}
	return out
}

pub struct VoxelShapesPacket {
pub mut:
	shapes             []VoxelShape
	name_map           []VoxelShapeNameEntry
	custom_shape_count u16
}

pub fn (p &VoxelShapesPacket) pid() u16 {
	return 337
}

pub fn (p &VoxelShapesPacket) name() string {
	return 'VoxelShapesPacket'
}

pub fn (p &VoxelShapesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &VoxelShapesPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shapes.len))
	for e in p.shapes {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.name_map.len))
	for e in p.name_map {
		e.encode(mut w)
	}
	w.le_u16(p.custom_shape_count)
}

pub fn (mut p VoxelShapesPacket) decode_payload(mut r serializer.Reader) ! {
	shape_count := r.read_count()!
	p.shapes = []VoxelShape{cap: serializer.prealloc(shape_count)}
	for _ in 0 .. shape_count {
		p.shapes << VoxelShape.decode(mut r)!
	}
	name_count := r.read_count()!
	p.name_map = []VoxelShapeNameEntry{cap: serializer.prealloc(name_count)}
	for _ in 0 .. name_count {
		p.name_map << VoxelShapeNameEntry.decode(mut r)!
	}
	p.custom_shape_count = r.le_u16()!
}
