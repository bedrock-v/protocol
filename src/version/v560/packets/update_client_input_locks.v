module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct UpdateClientInputLocksPacket {
pub mut:
	lock_component_data u32
	server_position     types_291.Vector3f
}

pub fn (p &UpdateClientInputLocksPacket) pid() u16 {
	return 196
}

pub fn (p &UpdateClientInputLocksPacket) name() string {
	return 'UpdateClientInputLocksPacket'
}

pub fn (p &UpdateClientInputLocksPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateClientInputLocksPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.lock_component_data)
	p.server_position.encode(mut w)
}

pub fn (mut p UpdateClientInputLocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.lock_component_data = r.read_varuint32()!
	p.server_position = types_291.Vector3f.decode(mut r)!
}
