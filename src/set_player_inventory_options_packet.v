module protocol

import serializer

pub struct SetPlayerInventoryOptionsPacket {
pub mut:
	left_tab         int
	right_tab        int
	filtering        bool
	inventory_layout int
	crafting_layout  int
}

pub fn (p &SetPlayerInventoryOptionsPacket) pid() u16 {
	return set_player_inventory_options_packet
}

pub fn (p &SetPlayerInventoryOptionsPacket) name() string {
	return 'SetPlayerInventoryOptionsPacket'
}

pub fn (p &SetPlayerInventoryOptionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetPlayerInventoryOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.left_tab = int(r.read_varint32()!)
	p.right_tab = int(r.read_varint32()!)
	p.filtering = r.bool()!
	p.inventory_layout = int(r.read_varint32()!)
	p.crafting_layout = int(r.read_varint32()!)
}

pub fn (p &SetPlayerInventoryOptionsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.left_tab))
	w.write_varint32(i32(p.right_tab))
	w.bool(p.filtering)
	w.write_varint32(i32(p.inventory_layout))
	w.write_varint32(i32(p.crafting_layout))
}
