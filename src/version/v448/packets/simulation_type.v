module packets

import protocol.serializer

pub enum SimulationType as u8 {
	game   = 0
	editor = 1
	test   = 2
}

pub struct SimulationTypePacket {
pub mut:
	simulation_type SimulationType
}

pub fn (p &SimulationTypePacket) pid() u16 {
	return 168
}

pub fn (p &SimulationTypePacket) name() string {
	return 'SimulationTypePacket'
}

pub fn (p &SimulationTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SimulationTypePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.simulation_type))
}

pub fn (mut p SimulationTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.simulation_type = unsafe { SimulationType(r.u8()!) }
}
