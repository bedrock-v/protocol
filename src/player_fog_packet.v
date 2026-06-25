module src

import src.serializer

pub struct PlayerFogPacket {
pub mut:
	fog_layers []string
}

pub fn (p &PlayerFogPacket) pid() u16 {
	return player_fog_packet
}

pub fn (p &PlayerFogPacket) name() string {
	return 'PlayerFogPacket'
}

pub fn (p &PlayerFogPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerFogPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.fog_layers = []string{cap: count}
	for _ in 0 .. count {
		p.fog_layers << r.read_string()!
	}
}

pub fn (p &PlayerFogPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.fog_layers.len))
	for layer in p.fog_layers {
		w.write_string(layer)
	}
}
