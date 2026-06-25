module src

import src.serializer

pub struct SimulationTypePacket {
pub mut:
	type int
}

pub fn (p &SimulationTypePacket) pid() u16 {
	return simulation_type_packet
}

pub fn (p &SimulationTypePacket) name() string {
	return 'SimulationTypePacket'
}

pub fn (p &SimulationTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SimulationTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.type = int(r.u8()!)
}

pub fn (p &SimulationTypePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.type))
}
