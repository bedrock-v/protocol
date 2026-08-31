module types

import protocol.serializer
import protocol.version.v2168.enums

pub struct ItemStackResponseInfo {
pub mut:
	result            enums.ItemStackNetResult
	client_request_id i32
	has_containers    bool
	containers        ?[]ItemStackResponseContainerInfo
}

pub fn (t ItemStackResponseInfo) encode(mut w serializer.Writer) {
	t.result.encode(mut w)
	w.write_varint32(t.client_request_id)
	w.bool(t.has_containers)
	if t.has_containers {
		if containers := t.containers {
			w.bool(true)
			w.write_varuint32(u32(containers.len))
			for e in containers {
				e.encode(mut w)
			}
		} else {
			w.bool(false)
		}
	}
}

pub fn ItemStackResponseInfo.decode(mut r serializer.Reader) !ItemStackResponseInfo {
	mut t := ItemStackResponseInfo{}
	t.result = enums.ItemStackNetResult.decode(mut r)!
	t.client_request_id = r.read_varint32()!
	t.has_containers = r.bool()!
	if t.has_containers {
		if r.bool()! {
			count := r.read_count()!
			mut items := []ItemStackResponseContainerInfo{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				items << ItemStackResponseContainerInfo.decode(mut r)!
			}
			t.containers = items
		}
	}
	return t
}
