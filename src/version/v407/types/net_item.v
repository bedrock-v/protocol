module types

import serializer
import version.v340.types as types_340

pub struct NetItemData {
pub mut:
	net_id i32
	item   types_340.ItemData
}

pub fn (t NetItemData) encode(mut w serializer.Writer) {
	w.write_varint32(t.net_id)
	t.item.encode(mut w)
}

pub fn NetItemData.decode(mut r serializer.Reader) !NetItemData {
	return NetItemData{
		net_id: r.read_varint32()!
		item:   types_340.ItemData.decode(mut r)!
	}
}
