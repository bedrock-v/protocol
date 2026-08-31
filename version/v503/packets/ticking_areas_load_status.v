module packets

import protocol.serializer

pub struct TickingAreasLoadStatusPacket {
pub mut:
	waiting_for_preload bool
}

pub fn (p &TickingAreasLoadStatusPacket) pid() u16 {
	return 179
}

pub fn (p &TickingAreasLoadStatusPacket) name() string {
	return 'TickingAreasLoadStatusPacket'
}

pub fn (p &TickingAreasLoadStatusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TickingAreasLoadStatusPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.waiting_for_preload)
}

pub fn (mut p TickingAreasLoadStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.waiting_for_preload = r.bool()!
}
