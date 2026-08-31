module packets

import protocol.serializer

pub struct SetDisplayObjectivePacket {
pub mut:
	display_slot   string
	objective_name string
	display_name   string
	criteria_name  string
	sort_order     i32
}

pub fn (p &SetDisplayObjectivePacket) pid() u16 {
	return 107
}

pub fn (p &SetDisplayObjectivePacket) name() string {
	return 'SetDisplayObjectivePacket'
}

pub fn (p &SetDisplayObjectivePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetDisplayObjectivePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.display_slot)
	w.write_string(p.objective_name)
	w.write_string(p.display_name)
	w.write_string(p.criteria_name)
	w.write_varint32(p.sort_order)
}

pub fn (mut p SetDisplayObjectivePacket) decode_payload(mut r serializer.Reader) ! {
	p.display_slot = r.read_string()!
	p.objective_name = r.read_string()!
	p.display_name = r.read_string()!
	p.criteria_name = r.read_string()!
	p.sort_order = r.read_varint32()!
}
