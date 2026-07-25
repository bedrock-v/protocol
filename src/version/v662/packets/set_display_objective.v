module packets

import serializer
import version.v662.enums

pub struct SetDisplayObjectivePacket {
pub mut:
	display_slot_name      string
	objective_name         string
	objective_display_name string
	criteria_name          string
	sort_order             enums.ObjectiveSortOrder
}

pub fn (p &SetDisplayObjectivePacket) pid() u16 { return 107 }

pub fn (p &SetDisplayObjectivePacket) name() string { return 'SetDisplayObjectivePacket' }

pub fn (p &SetDisplayObjectivePacket) can_be_sent_before_login() bool { return false }

pub fn (p &SetDisplayObjectivePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.display_slot_name)
	w.write_string(p.objective_name)
	w.write_string(p.objective_display_name)
	w.write_string(p.criteria_name)
	p.sort_order.encode(mut w)
}

pub fn (mut p SetDisplayObjectivePacket) decode_payload(mut r serializer.Reader) ! {
	p.display_slot_name = r.read_string()!
	p.objective_name = r.read_string()!
	p.objective_display_name = r.read_string()!
	p.criteria_name = r.read_string()!
	p.sort_order = enums.ObjectiveSortOrder.decode(mut r)!
}
