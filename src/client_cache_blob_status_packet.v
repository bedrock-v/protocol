module src

import src.serializer

pub struct ClientCacheBlobStatusPacket {
pub mut:
	miss_hashes []u64
	hit_hashes  []u64
}

pub fn (p &ClientCacheBlobStatusPacket) pid() u16 {
	return client_cache_blob_status_packet
}

pub fn (p &ClientCacheBlobStatusPacket) name() string {
	return 'ClientCacheBlobStatusPacket'
}

pub fn (p &ClientCacheBlobStatusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientCacheBlobStatusPacket) decode_payload(mut r serializer.Reader) ! {
	miss_count := int(r.read_varuint32()!)
	p.miss_hashes = []u64{cap: miss_count}
	for _ in 0 .. miss_count {
		p.miss_hashes << r.le_u64()!
	}
	hit_count := int(r.read_varuint32()!)
	p.hit_hashes = []u64{cap: hit_count}
	for _ in 0 .. hit_count {
		p.hit_hashes << r.le_u64()!
	}
}

pub fn (p &ClientCacheBlobStatusPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.miss_hashes.len))
	for hash in p.miss_hashes {
		w.le_u64(hash)
	}
	w.write_varuint32(u32(p.hit_hashes.len))
	for hash in p.hit_hashes {
		w.le_u64(hash)
	}
}
