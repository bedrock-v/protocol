module packets

import protocol.serializer

pub struct ClientCacheBlobStatusPacket {
pub mut:
	naks []i64
	acks []i64
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
	w.write_varuint32(u32(p.naks.len))
	w.write_varuint32(u32(p.acks.len))
	for nak in p.naks {
		w.le_i64(nak)
	}
	for ack in p.acks {
		w.le_i64(ack)
	}
}

pub fn (mut p ClientCacheBlobStatusPacket) decode_payload(mut r serializer.Reader) ! {
	nak_count := r.read_count()!
	ack_count := r.read_count()!
	p.naks = []i64{cap: serializer.prealloc(nak_count)}
	for _ in 0 .. nak_count {
		p.naks << r.le_i64()!
	}
	p.acks = []i64{cap: serializer.prealloc(ack_count)}
	for _ in 0 .. ack_count {
		p.acks << r.le_i64()!
	}
}
