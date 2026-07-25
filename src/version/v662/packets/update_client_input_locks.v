module packets

import serializer

pub struct UpdateClientInputLocksPacket {
pub mut:
	input_lock_component_data u32
	server_pos                [3]f32
}

pub fn (p &UpdateClientInputLocksPacket) pid() u16 { return 196 }

pub fn (p &UpdateClientInputLocksPacket) name() string { return 'UpdateClientInputLocksPacket' }

pub fn (p &UpdateClientInputLocksPacket) can_be_sent_before_login() bool { return false }

pub fn (p &UpdateClientInputLocksPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.input_lock_component_data)
	w.le_f32(p.server_pos[0])
	w.le_f32(p.server_pos[1])
	w.le_f32(p.server_pos[2])
}

pub fn (mut p UpdateClientInputLocksPacket) decode_payload(mut r serializer.Reader) ! {
	p.input_lock_component_data = r.read_varuint32()!
	p.server_pos = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
}
