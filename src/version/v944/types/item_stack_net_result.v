module types

import serializer
import version.v944.enums

pub struct ItemStackNetResult {
pub mut:
	kind               enums.ItemStackNetResultKind
	success_containers []ItemStackResponseContainerInfo
}

pub fn (t ItemStackNetResult) encode(mut w serializer.Writer) {
	t.kind.encode(mut w)
	if t.kind == .success {
		w.write_varuint32(u32(t.success_containers.len))
		for e in t.success_containers {
			e.encode(mut w)
		}
	}
}

pub fn ItemStackNetResult.decode(mut r serializer.Reader) !ItemStackNetResult {
	kind := enums.ItemStackNetResultKind.decode(mut r)!
	mut containers := []ItemStackResponseContainerInfo{}
	if kind == .success {
		count := int(r.read_varuint32()!)
		containers = []ItemStackResponseContainerInfo{cap: count}
		for _ in 0 .. count {
			containers << ItemStackResponseContainerInfo.decode(mut r)!
		}
	}
	return ItemStackNetResult{
		kind:               kind
		success_containers: containers
	}
}
