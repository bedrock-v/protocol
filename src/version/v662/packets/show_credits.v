module packets

import serializer
import version.v662.types

pub enum ShowCreditsState as i32 {
	start    = 0
	finished = 1
}

pub struct ShowCreditsPacket {
pub mut:
	player_runtime_id types.ActorRuntimeID
	credits_state     ShowCreditsState
}

pub fn (p &ShowCreditsPacket) pid() u16 { return 75 }

pub fn (p &ShowCreditsPacket) name() string { return 'ShowCreditsPacket' }

pub fn (p &ShowCreditsPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ShowCreditsPacket) encode_payload(mut w serializer.Writer) {
	p.player_runtime_id.encode(mut w)
	w.write_varint32(i32(p.credits_state))
}

pub fn (mut p ShowCreditsPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.credits_state = unsafe { ShowCreditsState(r.read_varint32()!) }
}
