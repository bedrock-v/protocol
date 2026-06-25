module src

import src.serializer
import src.types

pub struct InventoryContentPacket {
pub mut:
	window_id      int
	items          []types.ItemStackWrapper
	container_name types.FullContainerName
	storage        types.ItemStackWrapper
}

pub fn (p &InventoryContentPacket) pid() u16 {
	return inventory_content_packet
}

pub fn (p &InventoryContentPacket) name() string {
	return 'InventoryContentPacket'
}

pub fn (p &InventoryContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p InventoryContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = int(r.read_varuint32()!)
	count := int(r.read_varuint32()!)
	p.items = []types.ItemStackWrapper{}
	for _ in 0 .. count {
		p.items << r.read_network_item_stack_descriptor()!
	}
	p.container_name = r.read_full_container_name()!
	p.storage = r.read_network_item_stack_descriptor()!
}

pub fn (p &InventoryContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.window_id))
	w.write_varuint32(u32(p.items.len))
	for item in p.items {
		w.write_network_item_stack_descriptor(item)
	}
	w.write_full_container_name(p.container_name)
	w.write_network_item_stack_descriptor(p.storage)
}
