module protocol

import serializer

pub struct MapInfoRequestClientPixel {
pub mut:
	color u32
	index u16
}

pub struct MapInfoRequestPacket {
pub mut:
	map_id        i64
	client_pixels []MapInfoRequestClientPixel
}

pub fn (p &MapInfoRequestPacket) pid() u16 {
	return map_info_request_packet
}

pub fn (p &MapInfoRequestPacket) name() string {
	return 'MapInfoRequestPacket'
}

pub fn (p &MapInfoRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MapInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = r.read_actor_unique_id()!
	count := r.le_u32()!
	p.client_pixels = []MapInfoRequestClientPixel{}
	for _ in 0 .. count {
		p.client_pixels << MapInfoRequestClientPixel{
			color: r.le_u32()!
			index: r.le_u16()!
		}
	}
}

pub fn (p &MapInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.map_id)
	w.le_u32(u32(p.client_pixels.len))
	for px in p.client_pixels {
		w.le_u32(px.color)
		w.le_u16(px.index)
	}
}
