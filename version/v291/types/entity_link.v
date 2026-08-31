module types

import protocol.serializer
import protocol.version.v291.enums

pub struct EntityLinkData {
pub mut:
	from      i64
	to        i64
	link_type enums.EntityLinkType
	immediate bool
}

pub fn (t EntityLinkData) encode(mut w serializer.Writer) {
	w.write_varint64(t.from)
	w.write_varint64(t.to)
	t.link_type.encode(mut w)
	w.bool(t.immediate)
}

pub fn EntityLinkData.decode(mut r serializer.Reader) !EntityLinkData {
	return EntityLinkData{
		from:      r.read_varint64()!
		to:        r.read_varint64()!
		link_type: enums.EntityLinkType.decode(mut r)!
		immediate: r.bool()!
	}
}
