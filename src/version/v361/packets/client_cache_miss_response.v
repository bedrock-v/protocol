module packets

import protocol.serializer

pub struct CacheBlob {
pub mut:
	id   i64
	data []u8
}

pub struct ClientCacheMissResponsePacket {
pub mut:
	blobs []CacheBlob
}

pub fn (p &ClientCacheMissResponsePacket) pid() u16 {
	return 136
}

pub fn (p &ClientCacheMissResponsePacket) name() string {
	return 'ClientCacheMissResponsePacket'
}

pub fn (p &ClientCacheMissResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientCacheMissResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.blobs.len))
	for blob in p.blobs {
		w.le_i64(blob.id)
		w.write_string_bytes(blob.data)
	}
}

pub fn (mut p ClientCacheMissResponsePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.blobs = []CacheBlob{cap: count}
	for _ in 0 .. count {
		p.blobs << CacheBlob{
			id:   r.le_i64()!
			data: r.read_string_bytes()!
		}
	}
}
