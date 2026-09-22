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
	for b in t.storage {
		w.u8(b)
	}
}

pub fn VoxelShapeCells.decode(mut r serializer.Reader) !VoxelShapeCells {
	size := [r.u8()!, r.u8()!, r.u8()!]!
	count := r.read_count()!
	return VoxelShapeCells{
		size:    size
		storage: r.read_raw(count)!
	}
}

pub struct VoxelShape {
pub mut:
	cells         VoxelShapeCells
	x_coordinates []f32
	y_coordinates []f32
	z_coordinates []f32
}

pub fn (t VoxelShape) encode(mut w serializer.Writer) {
	t.cells.encode(mut w)
	w.write_varuint32(u32(t.x_coordinates.len))
	for v in t.x_coordinates {
		w.le_f32(v)
	}
	w.write_varuint32(u32(t.y_coordinates.len))
	for v in t.y_coordinates {
		w.le_f32(v)
	}
	w.write_varuint32(u32(t.z_coordinates.len))
	for v in t.z_coordinates {
		w.le_f32(v)
	}
}

pub fn VoxelShape.decode(mut r serializer.Reader) !VoxelShape {
	mut t := VoxelShape{}
	t.cells = VoxelShapeCells.decode(mut r)!
	x_count := r.read_count()!
	t.x_coordinates = []f32{cap: serializer.prealloc(x_count)}
	for _ in 0 .. x_count {
		t.x_coordinates << r.le_f32()!
	}
	y_count := r.read_count()!
	t.y_coordinates = []f32{cap: serializer.prealloc(y_count)}
	for _ in 0 .. y_count {
		t.y_coordinates << r.le_f32()!
	}
	z_count := r.read_count()!
	t.z_coordinates = []f32{cap: serializer.prealloc(z_count)}
	for _ in 0 .. z_count {
		t.z_coordinates << r.le_f32()!
	}
	return t
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
	shapes             []VoxelShape
	names              []VoxelShapeName
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
	w.write_varuint32(u32(p.names.len))
	for e in p.names {
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
	p.names = []VoxelShapeName{cap: serializer.prealloc(name_count)}
	for _ in 0 .. name_count {
		p.names << VoxelShapeName.decode(mut r)!
	}
	p.custom_shape_count = r.le_u16()!
}
