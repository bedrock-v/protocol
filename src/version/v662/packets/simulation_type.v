module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct SimulationTypePacket {
pub mut:
	sim_type enums.SimulationType
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
	p.sim_type.encode(mut w)
}

pub fn (mut p SimulationTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.sim_type = enums.SimulationType.decode(mut r)!
}
