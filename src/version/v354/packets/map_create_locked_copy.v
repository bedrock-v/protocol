module packets

import serializer

pub struct MapCreateLockedCopyPacket {
pub mut:
	original_map_id i64
	new_map_id      i64
}

pub fn (p &MapCreateLockedCopyPacket) pid() u16 {
	return 131
}

pub fn (p &MapCreateLockedCopyPacket) name() string {
	return 'MapCreateLockedCopyPacket'
}

pub fn (p &MapCreateLockedCopyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MapCreateLockedCopyPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.original_map_id)
	w.write_varint64(p.new_map_id)
}

pub fn (mut p MapCreateLockedCopyPacket) decode_payload(mut r serializer.Reader) ! {
	p.original_map_id = r.read_varint64()!
	p.new_map_id = r.read_varint64()!
}
