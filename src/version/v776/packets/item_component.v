module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v776.enums

pub struct ItemsEntry {
pub mut:
	component_item_name string
	runtime_id          i16
	is_component_based  bool
	version             enums.ItemVersion
	component_data      nbt.RootTag
}

pub fn (e ItemsEntry) encode(mut w serializer.Writer) {
	w.write_string(e.component_item_name)
	w.le_i16(e.runtime_id)
	w.bool(e.is_component_based)
	e.version.encode(mut w)
	w.write_nbt_compound_root(e.component_data)
}

pub fn ItemsEntry.decode(mut r serializer.Reader) !ItemsEntry {
	return ItemsEntry{
		component_item_name: r.read_string()!
		runtime_id:          r.le_i16()!
		is_component_based:  r.bool()!
		version:             enums.ItemVersion.decode(mut r)!
		component_data:      r.read_nbt_compound_root()!
	}
}

pub struct ItemComponentPacket {
pub mut:
	items []ItemsEntry
}

pub fn (p &ItemComponentPacket) pid() u16 {
	return 162
}

pub fn (p &ItemComponentPacket) name() string {
	return 'ItemComponentPacket'
}

pub fn (p &ItemComponentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemComponentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.items.len))
	for e in p.items {
		e.encode(mut w)
	}
}

pub fn (mut p ItemComponentPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.items = []ItemsEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.items << ItemsEntry.decode(mut r)!
	}
}
