module packets

import protocol.serializer
import protocol.version.v662.types

pub struct MapCreateLockedCopyPacket {
pub mut:
	original_map_id types.ActorUniqueID
	new_map_id      types.ActorUniqueID
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
	p.original_map_id.encode(mut w)
	p.new_map_id.encode(mut w)
}

pub fn (mut p MapCreateLockedCopyPacket) decode_payload(mut r serializer.Reader) ! {
	p.original_map_id = types.ActorUniqueID.decode(mut r)!
	p.new_map_id = types.ActorUniqueID.decode(mut r)!
}
