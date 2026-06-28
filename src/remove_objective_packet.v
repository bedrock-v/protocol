module protocol

import serializer

pub struct RemoveObjectivePacket {
pub mut:
	objective_name string
}

pub fn (p &RemoveObjectivePacket) pid() u16 {
	return remove_objective_packet
}

pub fn (p &RemoveObjectivePacket) name() string {
	return 'RemoveObjectivePacket'
}

pub fn (p &RemoveObjectivePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RemoveObjectivePacket) decode_payload(mut r serializer.Reader) ! {
	p.objective_name = r.read_string()!
}

pub fn (p &RemoveObjectivePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.objective_name)
}
