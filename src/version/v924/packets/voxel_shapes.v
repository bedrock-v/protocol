module packets

import protocol.serializer

pub struct VoxelShapeCells {
pub mut:
	size    [3]u8
	storage []u8
}

pub fn (t VoxelShapeCells) encode(mut w serializer.Writer) {
	w.u8(t.size[0])
	w.u8(t.size[1])
	w.u8(t.size[2])
	w.write_varuint32(u32(t.storage.len))
	w.write_raw(t.storage)
}

pub fn VoxelShapeCells.decode(mut r serializer.Reader) !VoxelShapeCells {
	mut t := VoxelShapeCells{}
	t.size = [r.u8()!, r.u8()!, r.u8()!]!
	count := int(r.read_varuint32()!)
	t.storage = r.read_raw(count)!
	return t
}

pub struct VoxelShape {
pub mut:
	cells         VoxelShapeCells
	x_coordinates []f32
	y_coordinates []f32
	z_coordinates []f32
}

fn write_f32_list(mut w serializer.Writer, list []f32) {
	w.write_varuint32(u32(list.len))
	for v in list {
		w.le_f32(v)
	}
}

fn read_f32_list(mut r serializer.Reader) ![]f32 {
	count := int(r.read_varuint32()!)
	mut out := []f32{cap: count}
	for _ in 0 .. count {
		out << r.le_f32()!
	}
	return out
}

pub fn (t VoxelShape) encode(mut w serializer.Writer) {
	t.cells.encode(mut w)
	write_f32_list(mut w, t.x_coordinates)
	write_f32_list(mut w, t.y_coordinates)
	write_f32_list(mut w, t.z_coordinates)
}

pub fn VoxelShape.decode(mut r serializer.Reader) !VoxelShape {
	return VoxelShape{
		cells:         VoxelShapeCells.decode(mut r)!
		x_coordinates: read_f32_list(mut r)!
		y_coordinates: read_f32_list(mut r)!
		z_coordinates: read_f32_list(mut r)!
	}
}

pub struct VoxelShapeName {
pub mut:
	name  string
	index u16
}

pub fn (t VoxelShapeName) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_u16(t.index)
}

pub fn VoxelShapeName.decode(mut r serializer.Reader) !VoxelShapeName {
	return VoxelShapeName{
		name:  r.read_string()!
		index: r.le_u16()!
	}
}

pub struct VoxelShapesPacket {
pub mut:
	shapes []VoxelShape
	names  []VoxelShapeName
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
	for s in p.shapes {
		s.encode(mut w)
	}
	w.write_varuint32(u32(p.names.len))
	for n in p.names {
		n.encode(mut w)
	}
}

pub fn (mut p VoxelShapesPacket) decode_payload(mut r serializer.Reader) ! {
	shape_count := int(r.read_varuint32()!)
	p.shapes = []VoxelShape{cap: shape_count}
	for _ in 0 .. shape_count {
		p.shapes << VoxelShape.decode(mut r)!
	}
	name_count := int(r.read_varuint32()!)
	p.names = []VoxelShapeName{cap: name_count}
	for _ in 0 .. name_count {
		p.names << VoxelShapeName.decode(mut r)!
	}
}
