module types

import protocol.serializer
import protocol.version.v471.types as types_471

pub struct ItemStackRequest {
pub mut:
	request_id             i32
	actions                []types_471.ItemStackRequestAction
	filter_strings         []string
	text_processing_origin i32 = -1
}

pub fn (t ItemStackRequest) encode(mut w serializer.Writer) {
	w.write_varint32(t.request_id)
	w.write_varuint32(u32(t.actions.len))
	for action in t.actions {
		action.encode(mut w)
	}
	w.write_varuint32(u32(t.filter_strings.len))
	for filter_string in t.filter_strings {
		w.write_string(filter_string)
	}
	w.le_i32(t.text_processing_origin)
}

pub fn ItemStackRequest.decode(mut r serializer.Reader) !ItemStackRequest {
	request_id := r.read_varint32()!
	action_count := int(r.read_varuint32()!)
	mut actions := []types_471.ItemStackRequestAction{cap: action_count}
	for _ in 0 .. action_count {
		actions << types_471.ItemStackRequestAction.decode(mut r)!
	}
	filter_count := int(r.read_varuint32()!)
	mut filter_strings := []string{cap: filter_count}
	for _ in 0 .. filter_count {
		filter_strings << r.read_string()!
	}
	return ItemStackRequest{
		request_id:             request_id
		actions:                actions
		filter_strings:         filter_strings
		text_processing_origin: r.le_i32()!
	}
}
