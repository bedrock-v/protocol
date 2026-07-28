module packets

import protocol.serializer

pub struct MissingBlobEntry {
pub mut:
	blob_id   u64
	blob_data []u8
}

pub fn (e MissingBlobEntry) encode(mut w serializer.Writer) {
	w.le_u64(e.blob_id)
	w.write_string_bytes(e.blob_data)
}

pub fn MissingBlobEntry.decode(mut r serializer.Reader) !MissingBlobEntry {
	return MissingBlobEntry{
		blob_id:   r.le_u64()!
		blob_data: r.read_string_bytes()!
	}
}

pub struct ClientCacheMissResponsePacket {
pub mut:
	missing_blobs []MissingBlobEntry
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
	w.write_varuint32(u32(p.missing_blobs.len))
	for e in p.missing_blobs {
		e.encode(mut w)
	}
}

pub fn (mut p ClientCacheMissResponsePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.missing_blobs = []MissingBlobEntry{cap: count}
	for _ in 0 .. count {
		p.missing_blobs << MissingBlobEntry.decode(mut r)!
	}
}
