module packets

import protocol.serializer
import protocol.version.v100.types

pub struct SetEntityDataPacket {
pub mut:
	eid      i32
	metadata types.EraBMetadata
}

pub fn (p &SetEntityDataPacket) pid() u16 {
	return 0x27
}

pub fn (p &SetEntityDataPacket) name() string {
	return 'SetEntityDataPacket'
}

pub fn (p &SetEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	p.metadata.encode(mut w)
}

pub fn (mut p SetEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.metadata = types.EraBMetadata.decode(mut r)!
}
