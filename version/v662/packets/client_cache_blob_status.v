module packets

import protocol.serializer

pub struct ClientCacheBlobStatusPacket {
pub mut:
	missing_blobs  []u64
	obtained_blobs []u64
}

pub fn (p &ClientCacheBlobStatusPacket) pid() u16 {
	return 135
}

pub fn (p &ClientCacheBlobStatusPacket) name() string {
	return 'ClientCacheBlobStatusPacket'
}

pub fn (p &ClientCacheBlobStatusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientCacheBlobStatusPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.missing_blobs.len))
	w.write_varuint32(u32(p.obtained_blobs.len))
	for b in p.missing_blobs {
		w.le_u64(b)
	}
	for b in p.obtained_blobs {
		w.le_u64(b)
	}
}

pub fn (mut p ClientCacheBlobStatusPacket) decode_payload(mut r serializer.Reader) ! {
	missing_count := r.read_count()!
	obtained_count := r.read_count()!
	p.missing_blobs = []u64{cap: serializer.prealloc(missing_count)}
	for _ in 0 .. missing_count {
		p.missing_blobs << r.le_u64()!
	}
	p.obtained_blobs = []u64{cap: serializer.prealloc(obtained_count)}
	for _ in 0 .. obtained_count {
		p.obtained_blobs << r.le_u64()!
	}
}
