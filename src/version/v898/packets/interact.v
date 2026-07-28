module packets

import protocol.serializer
import protocol.version.v662.types

pub enum InteractPacketAction as i8 {
	invalid         = 0
	interact        = 1
	damage          = 2
	stop_riding     = 3
	interact_update = 4
	npc_open        = 5
	open_inventory  = 6
}

pub struct InteractPacket {
pub mut:
	action            InteractPacketAction
	target_runtime_id types.ActorRuntimeID
	mouse_position    ?[3]f32
}

pub fn (p &InteractPacket) pid() u16 {
	return 33
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.i8(i8(p.action))
	p.target_runtime_id.encode(mut w)
	if v := p.mouse_position {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { InteractPacketAction(r.i8()!) }
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	if r.bool()! {
		p.mouse_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
}
