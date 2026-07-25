module packets

import serializer
import version.v407.types

pub struct ItemStackResponse {
pub mut:
	success    bool
	request_id i32
	containers []types.ItemStackResponseContainer
}

pub fn (t ItemStackResponse) encode(mut w serializer.Writer) {
	w.bool(t.success)
	w.write_varint32(t.request_id)
	if !t.success {
		return
	}
	w.write_varuint32(u32(t.containers.len))
	for container in t.containers {
		container.encode(mut w)
	}
}

pub fn ItemStackResponse.decode(mut r serializer.Reader) !ItemStackResponse {
	mut t := ItemStackResponse{}
	t.success = r.bool()!
	t.request_id = r.read_varint32()!
	if !t.success {
		return t
	}
	count := int(r.read_varuint32()!)
	t.containers = []types.ItemStackResponseContainer{cap: count}
	for _ in 0 .. count {
		t.containers << types.ItemStackResponseContainer.decode(mut r)!
	}
	return t
}

pub struct ItemStackResponsePacket {
pub mut:
	entries []ItemStackResponse
}

pub fn (p &ItemStackResponsePacket) pid() u16 {
	return 148
}

pub fn (p &ItemStackResponsePacket) name() string {
	return 'ItemStackResponsePacket'
}

pub fn (p &ItemStackResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemStackResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		entry.encode(mut w)
	}
}

pub fn (mut p ItemStackResponsePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.entries = []ItemStackResponse{cap: count}
	for _ in 0 .. count {
		p.entries << ItemStackResponse.decode(mut r)!
	}
}
