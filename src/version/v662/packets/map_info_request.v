module packets

import serializer
import version.v662.types

pub struct ClientPixelsListEntry {
pub mut:
	pixel u32
	index u16
}

pub fn (e ClientPixelsListEntry) encode(mut w serializer.Writer) {
	w.le_u32(e.pixel)
	w.le_u16(e.index)
}

pub fn ClientPixelsListEntry.decode(mut r serializer.Reader) !ClientPixelsListEntry {
	return ClientPixelsListEntry{
		pixel: r.le_u32()!
		index: r.le_u16()!
	}
}

pub struct MapInfoRequestPacket {
pub mut:
	map_unique_id      types.ActorUniqueID
	client_pixels_list []ClientPixelsListEntry
}

pub fn (p &MapInfoRequestPacket) pid() u16 { return 68 }

pub fn (p &MapInfoRequestPacket) name() string { return 'MapInfoRequestPacket' }

pub fn (p &MapInfoRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &MapInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	p.map_unique_id.encode(mut w)
	w.le_u32(u32(p.client_pixels_list.len))
	for e in p.client_pixels_list {
		e.encode(mut w)
	}
}

pub fn (mut p MapInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_unique_id = types.ActorUniqueID.decode(mut r)!
	count := int(r.le_u32()!)
	p.client_pixels_list = []ClientPixelsListEntry{cap: count}
	for _ in 0 .. count {
		p.client_pixels_list << ClientPixelsListEntry.decode(mut r)!
	}
}
