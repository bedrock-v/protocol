module protocol

import serializer

pub struct SetDisplayObjectivePacket {
pub mut:
	display_slot   string
	objective_name string
	display_name   string
	criteria_name  string
	sort_order     int
}

pub fn (p &SetDisplayObjectivePacket) pid() u16 {
	return set_display_objective_packet
}

pub fn (p &SetDisplayObjectivePacket) name() string {
	return 'SetDisplayObjectivePacket'
}

pub fn (p &SetDisplayObjectivePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetDisplayObjectivePacket) decode_payload(mut r serializer.Reader) ! {
	p.display_slot = r.read_string()!
	p.objective_name = r.read_string()!
	p.display_name = r.read_string()!
	p.criteria_name = r.read_string()!
	p.sort_order = int(r.read_varint32()!)
}

pub fn (p &SetDisplayObjectivePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.display_slot)
	w.write_string(p.objective_name)
	w.write_string(p.display_name)
	w.write_string(p.criteria_name)
	w.write_varint32(i32(p.sort_order))
}
