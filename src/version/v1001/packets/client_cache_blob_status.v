module packets

import serializer

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
	for v in p.missing_blobs {
		w.le_u64(v)
	}
	w.write_varuint32(u32(p.obtained_blobs.len))
	for v in p.obtained_blobs {
		w.le_u64(v)
	}
}

pub fn (mut p ClientCacheBlobStatusPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.missing_blobs = []u64{cap: count}
		for _ in 0 .. count {
			p.missing_blobs << r.le_u64()!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.obtained_blobs = []u64{cap: count}
		for _ in 0 .. count {
			p.obtained_blobs << r.le_u64()!
		}
	}
}
