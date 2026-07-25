module packets

import serializer

pub struct TickingAreaLoadStatusPacket {
pub mut:
	waiting_for_preload bool
}

pub fn (p &TickingAreaLoadStatusPacket) pid() u16 { return 179 }

pub fn (p &TickingAreaLoadStatusPacket) name() string { return 'TickingAreaLoadStatusPacket' }

pub fn (p &TickingAreaLoadStatusPacket) can_be_sent_before_login() bool { return false }

pub fn (p &TickingAreaLoadStatusPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.waiting_for_preload)
}

pub fn (mut p TickingAreaLoadStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.waiting_for_preload = r.bool()!
}
