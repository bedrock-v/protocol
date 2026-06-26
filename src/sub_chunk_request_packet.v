module src

import src.serializer

pub struct SubChunkPositionOffset {
pub mut:
	x_offset i8
	y_offset i8
	z_offset i8
}

pub struct SubChunkRequestPacket {
pub mut:
	dimension     int
	entries       []SubChunkPositionOffset
	base_x        i32
	base_y        i32
	base_z        i32
}

pub fn (p &SubChunkRequestPacket) pid() u16 {
	return sub_chunk_request_packet
}

pub fn (p &SubChunkRequestPacket) name() string {
	return 'SubChunkRequestPacket'
}

pub fn (p &SubChunkRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SubChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = r.read_varint32()!
	count := r.read_varuint32()!
	p.entries = []SubChunkPositionOffset{}
	for _ in 0 .. count {
		p.entries << SubChunkPositionOffset{
			x_offset: r.i8()!
			y_offset: r.i8()!
			z_offset: r.i8()!
		}
	}
	p.base_x = r.le_i32()!
	p.base_y = r.le_i32()!
	p.base_z = r.le_i32()!
}

pub fn (p &SubChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.dimension)
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		w.i8(e.x_offset)
		w.i8(e.y_offset)
		w.i8(e.z_offset)
	}
	w.le_i32(p.base_x)
	w.le_i32(p.base_y)
	w.le_i32(p.base_z)
}
