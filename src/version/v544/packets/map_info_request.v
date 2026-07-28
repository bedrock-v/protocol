module packets

import protocol.serializer

pub struct MapPixel {
pub mut:
	pixel i32
	index u16
}

pub fn (t MapPixel) encode(mut w serializer.Writer) {
	w.le_i32(t.pixel)
	w.le_u16(t.index)
}

pub fn MapPixel.decode(mut r serializer.Reader) !MapPixel {
	return MapPixel{
		pixel: r.le_i32()!
		index: r.le_u16()!
	}
}

pub struct MapInfoRequestPacket {
pub mut:
	unique_map_id i64
	pixels        []MapPixel
}

pub fn (p &MapInfoRequestPacket) pid() u16 {
	return 68
}

pub fn (p &MapInfoRequestPacket) name() string {
	return 'MapInfoRequestPacket'
}

pub fn (p &MapInfoRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MapInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.unique_map_id)
	w.le_u32(u32(p.pixels.len))
	for pixel in p.pixels {
		pixel.encode(mut w)
	}
}

pub fn (mut p MapInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_map_id = r.read_varint64()!
	pixel_count := int(r.le_u32()!)
	p.pixels = []MapPixel{cap: pixel_count}
	for _ in 0 .. pixel_count {
		p.pixels << MapPixel.decode(mut r)!
	}
}
