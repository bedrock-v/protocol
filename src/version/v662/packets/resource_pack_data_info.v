module packets

import serializer
import version.v662.enums

pub struct ResourcePackDataInfoPacket {
pub mut:
	resource_name string
	chunk_size    u32
	chunk_amount  u32
	file_size     u64
	file_hash     []u8
	is_premium    bool
	pack_type     enums.PackType
}

pub fn (p &ResourcePackDataInfoPacket) pid() u16 { return 82 }

pub fn (p &ResourcePackDataInfoPacket) name() string { return 'ResourcePackDataInfoPacket' }

pub fn (p &ResourcePackDataInfoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ResourcePackDataInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.resource_name)
	w.le_u32(p.chunk_size)
	w.le_u32(p.chunk_amount)
	w.le_u64(p.file_size)
	w.write_string_bytes(p.file_hash)
	w.bool(p.is_premium)
	p.pack_type.encode(mut w)
}

pub fn (mut p ResourcePackDataInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.resource_name = r.read_string()!
	p.chunk_size = r.le_u32()!
	p.chunk_amount = r.le_u32()!
	p.file_size = r.le_u64()!
	p.file_hash = r.read_string_bytes()!
	p.is_premium = r.bool()!
	p.pack_type = enums.PackType.decode(mut r)!
}
