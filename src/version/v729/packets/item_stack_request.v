module packets

import serializer
import version.v729.types
import version.v662.enums

pub struct RequestsEntry {
pub mut:
	client_request_id        u32
	actions                  []types.ItemStackRequestActionType
	strings_to_filter        []string
	strings_to_filter_origin enums.TextProcessingEventOrigin
}

pub fn (e RequestsEntry) encode(mut w serializer.Writer) {
	w.write_varuint32(e.client_request_id)
	w.write_varuint32(u32(e.actions.len))
	for a in e.actions {
		a.encode(mut w)
	}
	w.write_varuint32(u32(e.strings_to_filter.len))
	for s in e.strings_to_filter {
		w.write_string(s)
	}
	e.strings_to_filter_origin.encode(mut w)
}

pub fn RequestsEntry.decode(mut r serializer.Reader) !RequestsEntry {
	mut e := RequestsEntry{}
	e.client_request_id = r.read_varuint32()!
	act_count := int(r.read_varuint32()!)
	e.actions = []types.ItemStackRequestActionType{cap: act_count}
	for _ in 0 .. act_count {
		e.actions << types.ItemStackRequestActionType.decode(mut r)!
	}
	str_count := int(r.read_varuint32()!)
	e.strings_to_filter = []string{cap: str_count}
	for _ in 0 .. str_count {
		e.strings_to_filter << r.read_string()!
	}
	e.strings_to_filter_origin = enums.TextProcessingEventOrigin.decode(mut r)!
	return e
}

pub struct ItemStackRequestPacket {
pub mut:
	requests []RequestsEntry
}

pub fn (p &ItemStackRequestPacket) pid() u16 { return 147 }

pub fn (p &ItemStackRequestPacket) name() string { return 'ItemStackRequestPacket' }

pub fn (p &ItemStackRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ItemStackRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.requests.len))
	for e in p.requests {
		e.encode(mut w)
	}
}

pub fn (mut p ItemStackRequestPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.requests = []RequestsEntry{cap: count}
	for _ in 0 .. count {
		p.requests << RequestsEntry.decode(mut r)!
	}
}
