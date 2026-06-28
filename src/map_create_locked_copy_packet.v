module protocol

import serializer

pub struct MapCreateLockedCopyPacket {
pub mut:
	original_map_id i64
	new_map_id      i64
}

pub fn (p &MapCreateLockedCopyPacket) pid() u16 {
	return map_create_locked_copy_packet
}

pub fn (p &MapCreateLockedCopyPacket) name() string {
	return 'MapCreateLockedCopyPacket'
}

pub fn (p &MapCreateLockedCopyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MapCreateLockedCopyPacket) decode_payload(mut r serializer.Reader) ! {
	p.original_map_id = r.read_actor_unique_id()!
	p.new_map_id = r.read_actor_unique_id()!
}

pub fn (p &MapCreateLockedCopyPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.original_map_id)
	w.write_actor_unique_id(p.new_map_id)
}
