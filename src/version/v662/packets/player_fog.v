module packets

import protocol.serializer

pub struct PlayerFogPacket {
pub mut:
	fog_stack []string
}

pub fn (p &PlayerFogPacket) pid() u16 {
	return 160
}

pub fn (p &PlayerFogPacket) name() string {
	return 'PlayerFogPacket'
}

pub fn (p &PlayerFogPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerFogPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.fog_stack.len))
	for e in p.fog_stack {
		w.write_string(e)
	}
}

pub fn (mut p PlayerFogPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.fog_stack = []string{cap: count}
		for _ in 0 .. count {
			p.fog_stack << r.read_string()!
		}
	}
}
