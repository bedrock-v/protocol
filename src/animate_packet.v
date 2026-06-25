module src

import src.serializer

pub struct AnimatePacket {
pub mut:
	action           int
	actor_runtime_id u64
	data             f32
	swing_source     ?string
}

pub fn (p &AnimatePacket) pid() u16 {
	return animate_packet
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = int(r.u8()!)
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.data = r.le_f32()!
	if r.bool()! {
		p.swing_source = r.read_string()!
	} else {
		p.swing_source = none
	}
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.le_f32(p.data)
	if source := p.swing_source {
		w.bool(true)
		w.write_string(source)
	} else {
		w.bool(false)
	}
}
