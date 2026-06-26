module src

import src.serializer

pub struct ChunkCacheBlob {
pub mut:
	hash    u64
	payload string
}

pub struct ClientCacheMissResponsePacket {
pub mut:
	blobs []ChunkCacheBlob
}

pub fn (p &ClientCacheMissResponsePacket) pid() u16 {
	return client_cache_miss_response_packet
}

pub fn (p &ClientCacheMissResponsePacket) name() string {
	return 'ClientCacheMissResponsePacket'
}

pub fn (p &ClientCacheMissResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientCacheMissResponsePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.blobs = []ChunkCacheBlob{}
	for _ in 0 .. count {
		p.blobs << ChunkCacheBlob{
			hash:    r.le_u64()!
			payload: r.read_string()!
		}
	}
}

pub fn (p &ClientCacheMissResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.blobs.len))
	for b in p.blobs {
		w.le_u64(b.hash)
		w.write_string(b.payload)
	}
}
