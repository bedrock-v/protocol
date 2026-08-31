module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct SetPlayerInventoryOptionsPacket {
pub mut:
	left_inventory_tab  enums.InventoryLeftTabIndex
	right_inventory_tab enums.InventoryRightTabIndex
	filtering           bool
	layout_inv          enums.InventoryLayout
	layout_craft        enums.InventoryLayout
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
	p.left_inventory_tab.encode(mut w)
	p.right_inventory_tab.encode(mut w)
	w.bool(p.filtering)
	p.layout_inv.encode(mut w)
	p.layout_craft.encode(mut w)
}

pub fn (mut p SetPlayerInventoryOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.left_inventory_tab = enums.InventoryLeftTabIndex.decode(mut r)!
	p.right_inventory_tab = enums.InventoryRightTabIndex.decode(mut r)!
	p.filtering = r.bool()!
	p.layout_inv = enums.InventoryLayout.decode(mut r)!
	p.layout_craft = enums.InventoryLayout.decode(mut r)!
}
