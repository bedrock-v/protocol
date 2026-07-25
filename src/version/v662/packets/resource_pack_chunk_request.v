module packets

import serializer

pub struct ResourcePackChunkRequestPacket {
pub mut:
	resource_name string
	chunk         u32
}

pub fn (p &ResourcePackChunkRequestPacket) pid() u16 { return 84 }

pub fn (p &ResourcePackChunkRequestPacket) name() string { return 'ResourcePackChunkRequestPacket' }

pub fn (p &ResourcePackChunkRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ResourcePackChunkRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.resource_name)
	w.le_u32(p.chunk)
}

pub fn (mut p ResourcePackChunkRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.resource_name = r.read_string()!
	p.chunk = r.le_u32()!
}
