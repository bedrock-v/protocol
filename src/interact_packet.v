module protocol

import serializer
import types

pub struct InteractPacket {
pub mut:
	action                 int
	target_actor_runtime_id u64
	position               ?types.Vector3
}

pub fn (p &InteractPacket) pid() u16 {
	return interact_packet
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = int(r.u8()!)
	p.target_actor_runtime_id = r.read_actor_runtime_id()!
	if r.bool()! {
		p.position = r.read_vector3()!
	} else {
		p.position = none
	}
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_actor_runtime_id(p.target_actor_runtime_id)
	if pos := p.position {
		w.bool(true)
		w.write_vector3(pos)
	} else {
		w.bool(false)
	}
}
