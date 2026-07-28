module types

import protocol.serializer
import protocol.version.v2168.enums

pub struct DataItem {
pub mut:
	data_item_id   u32
	data_item_type enums.DataItemType = enums.DataItemByte{}
}

pub fn (t DataItem) encode(mut w serializer.Writer) {
	w.write_varuint32(t.data_item_id)
	t.data_item_type.encode(mut w)
}

pub fn DataItem.decode(mut r serializer.Reader) !DataItem {
	return DataItem{
		data_item_id:   r.read_varuint32()!
		data_item_type: enums.DataItemType.decode(mut r)!
	}
}
