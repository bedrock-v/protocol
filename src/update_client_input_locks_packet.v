module src

import src.serializer

pub struct UpdateClientInputLocksPacket {
pub mut:
	flags int
}

pub fn (p &UpdateClientInputLocksPacket) pid() u16 {
	return update_client_input_locks_packet
}

pub fn (p &UpdateClientInputLocksPacket) name() string {
	return 'UpdateClientInputLocksPacket'
}

pub fn (p &UpdateClientInputLocksPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateClientInputLocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = int(r.read_varuint32()!)
}

pub fn (p &UpdateClientInputLocksPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.flags))
}
