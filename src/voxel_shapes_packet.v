module protocol

import serializer

pub struct VoxelCells {
pub mut:
	x_size  u8
	y_size  u8
	z_size  u8
	storage []u8
}

pub struct VoxelShape {
pub mut:
	cells         VoxelCells
	x_coordinates []f32
	y_coordinates []f32
	z_coordinates []f32
}

pub struct VoxelShapeNameEntry {
pub mut:
	name string
	id   u16
}

pub struct VoxelShapesPacket {
pub mut:
	shapes             []VoxelShape
	name_map           []VoxelShapeNameEntry
	custom_shape_count u16
}

pub fn (p &VoxelShapesPacket) pid() u16 {
	return voxel_shapes_packet
}

pub fn (p &VoxelShapesPacket) name() string {
	return 'VoxelShapesPacket'
}

pub fn (p &VoxelShapesPacket) can_be_sent_before_login() bool {
	return false
}

fn read_f32_list(mut r serializer.Reader) ![]f32 {
	count := r.read_varuint32()!
	mut out := []f32{}
	for _ in 0 .. count {
		out << r.le_f32()!
	}
	return out
}

fn write_f32_list(mut w serializer.Writer, list []f32) {
	w.write_varuint32(u32(list.len))
	for v in list {
		w.le_f32(v)
	}
}

fn read_voxel_shape(mut r serializer.Reader) !VoxelShape {
	mut s := VoxelShape{}
	s.cells.x_size = r.u8()!
	s.cells.y_size = r.u8()!
	s.cells.z_size = r.u8()!
	storage_count := r.read_varuint32()!
	s.cells.storage = []u8{}
	for _ in 0 .. storage_count {
		s.cells.storage << r.u8()!
	}
	s.x_coordinates = read_f32_list(mut r)!
	s.y_coordinates = read_f32_list(mut r)!
	s.z_coordinates = read_f32_list(mut r)!
	return s
}

fn write_voxel_shape(mut w serializer.Writer, s VoxelShape) {
	w.u8(s.cells.x_size)
	w.u8(s.cells.y_size)
	w.u8(s.cells.z_size)
	w.write_varuint32(u32(s.cells.storage.len))
	for b in s.cells.storage {
		w.u8(b)
	}
	write_f32_list(mut w, s.x_coordinates)
	write_f32_list(mut w, s.y_coordinates)
	write_f32_list(mut w, s.z_coordinates)
}

pub fn (mut p VoxelShapesPacket) decode_payload(mut r serializer.Reader) ! {
	shape_count := r.read_varuint32()!
	p.shapes = []VoxelShape{}
	for _ in 0 .. shape_count {
		p.shapes << read_voxel_shape(mut r)!
	}
	name_count := r.read_varuint32()!
	p.name_map = []VoxelShapeNameEntry{}
	for _ in 0 .. name_count {
		p.name_map << VoxelShapeNameEntry{
			name: r.read_string()!
			id:   r.le_u16()!
		}
	}
	p.custom_shape_count = r.le_u16()!
}

pub fn (p &VoxelShapesPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.shapes.len))
	for s in p.shapes {
		write_voxel_shape(mut w, s)
	}
	w.write_varuint32(u32(p.name_map.len))
	for n in p.name_map {
		w.write_string(n.name)
		w.le_u16(n.id)
	}
	w.le_u16(p.custom_shape_count)
}
