module types

import serializer
import version.v291.enums as enums_291

pub struct EntityLinkData {
pub mut:
	from            i64
	to              i64
	link_type       enums_291.EntityLinkType
	immediate       bool
	rider_initiated bool
}

pub fn (t EntityLinkData) encode(mut w serializer.Writer) {
	w.write_varint64(t.from)
	w.write_varint64(t.to)
	w.u8(u8(t.link_type))
	w.bool(t.immediate)
	w.bool(t.rider_initiated)
}

pub fn EntityLinkData.decode(mut r serializer.Reader) !EntityLinkData {
	return EntityLinkData{
		from:            r.read_varint64()!
		to:              r.read_varint64()!
		link_type:       unsafe { enums_291.EntityLinkType(r.u8()!) }
		immediate:       r.bool()!
		rider_initiated: r.bool()!
	}
}
