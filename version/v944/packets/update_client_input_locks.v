module packets

import protocol.serializer

pub struct UpdateClientInputLocksPacket {
pub mut:
	input_lock_component_data u32
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
	w.write_varuint32(p.input_lock_component_data)
}

pub fn (mut p UpdateClientInputLocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.input_lock_component_data = r.read_varuint32()!
}
