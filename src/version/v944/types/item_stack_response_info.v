module types

import protocol.serializer
import protocol.version.v944.enums

pub struct ItemStackResponseInfo {
pub mut:
	result            ItemStackNetResult
	client_request_id i32
}

pub fn (t ItemStackResponseInfo) encode(mut w serializer.Writer) {
	t.result.kind.encode(mut w)
	w.write_varint32(t.client_request_id)
	if t.result.kind == .success {
		w.write_varuint32(u32(t.result.success_containers.len))
		for e in t.result.success_containers {
			e.encode(mut w)
		}
	}
}

pub fn ItemStackResponseInfo.decode(mut r serializer.Reader) !ItemStackResponseInfo {
	kind := enums.ItemStackNetResultKind.decode(mut r)!
	client_request_id := r.read_varint32()!
	mut containers := []ItemStackResponseContainerInfo{}
	if kind == .success {
		count := int(r.read_varuint32()!)
		containers = []ItemStackResponseContainerInfo{cap: count}
		for _ in 0 .. count {
			containers << ItemStackResponseContainerInfo.decode(mut r)!
		}
	}
	return ItemStackResponseInfo{
		result:            ItemStackNetResult{
			kind:               kind
			success_containers: containers
		}
		client_request_id: client_request_id
	}
}
