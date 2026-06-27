module src

import src.serializer
import src.types

pub const item_stack_response_status_ok = u8(0)

pub struct StackResponseSlotInfo {
pub mut:
	slot                  u8
	hotbar_slot           u8
	count                 u8
	stack_network_id      int
	custom_name           string
	filtered_custom_name  string
	durability_correction int
}

pub struct StackResponseContainerInfo {
pub mut:
	container types.FullContainerName
	slot_info []StackResponseSlotInfo
}

pub struct ItemStackResponseEntry {
pub mut:
	status         u8
	request_id     int
	container_info []StackResponseContainerInfo
}

pub struct ItemStackResponsePacket {
pub mut:
	responses []ItemStackResponseEntry
}

pub fn (p &ItemStackResponsePacket) pid() u16 {
	return item_stack_response_packet
}

pub fn (p &ItemStackResponsePacket) name() string {
	return 'ItemStackResponsePacket'
}

pub fn (p &ItemStackResponsePacket) can_be_sent_before_login() bool {
	return false
}

fn read_item_stack_response_entry(mut r serializer.Reader) !ItemStackResponseEntry {
	mut e := ItemStackResponseEntry{
		status:     r.u8()!
		request_id: r.read_varint32()!
	}
	if e.status == item_stack_response_status_ok {
		ci_count := r.read_varuint32()!
		e.container_info = []StackResponseContainerInfo{}
		for _ in 0 .. ci_count {
			mut ci := StackResponseContainerInfo{
				container: r.read_full_container_name()!
			}
			si_count := r.read_varuint32()!
			ci.slot_info = []StackResponseSlotInfo{}
			for _ in 0 .. si_count {
				ci.slot_info << StackResponseSlotInfo{
					slot:                  r.u8()!
					hotbar_slot:           r.u8()!
					count:                 r.u8()!
					stack_network_id:      r.read_varint32()!
					custom_name:           r.read_string()!
					filtered_custom_name:  r.read_string()!
					durability_correction: r.read_varint32()!
				}
			}
			e.container_info << ci
		}
	}
	return e
}

fn write_item_stack_response_entry(mut w serializer.Writer, e ItemStackResponseEntry) {
	w.u8(e.status)
	w.write_varint32(e.request_id)
	if e.status == item_stack_response_status_ok {
		w.write_varuint32(u32(e.container_info.len))
		for ci in e.container_info {
			w.write_full_container_name(ci.container)
			w.write_varuint32(u32(ci.slot_info.len))
			for si in ci.slot_info {
				w.u8(si.slot)
				w.u8(si.hotbar_slot)
				w.u8(si.count)
				w.write_varint32(si.stack_network_id)
				w.write_string(si.custom_name)
				w.write_string(si.filtered_custom_name)
				w.write_varint32(si.durability_correction)
			}
		}
	}
}

pub fn (mut p ItemStackResponsePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.responses = []ItemStackResponseEntry{}
	for _ in 0 .. count {
		p.responses << read_item_stack_response_entry(mut r)!
	}
}

pub fn (p &ItemStackResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.responses.len))
	for e in p.responses {
		write_item_stack_response_entry(mut w, e)
	}
}
