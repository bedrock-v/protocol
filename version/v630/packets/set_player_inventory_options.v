module packets

import protocol.serializer
import protocol.version.v630.enums

pub struct SetPlayerInventoryOptionsPacket {
pub mut:
	left_tab        enums.InventoryTabLeft
	right_tab       enums.InventoryTabRight
	filtering       bool
	layout          enums.InventoryLayout
	crafting_layout enums.InventoryLayout
}

pub fn (p &SetPlayerInventoryOptionsPacket) pid() u16 {
	return 307
}

pub fn (p &SetPlayerInventoryOptionsPacket) name() string {
	return 'SetPlayerInventoryOptionsPacket'
}

pub fn (p &SetPlayerInventoryOptionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetPlayerInventoryOptionsPacket) encode_payload(mut w serializer.Writer) {
	p.left_tab.encode(mut w)
	p.right_tab.encode(mut w)
	w.bool(p.filtering)
	p.layout.encode(mut w)
	p.crafting_layout.encode(mut w)
}

pub fn (mut p SetPlayerInventoryOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.left_tab = enums.InventoryTabLeft.decode(mut r)!
	p.right_tab = enums.InventoryTabRight.decode(mut r)!
	p.filtering = r.bool()!
	p.layout = enums.InventoryLayout.decode(mut r)!
	p.crafting_layout = enums.InventoryLayout.decode(mut r)!
}
