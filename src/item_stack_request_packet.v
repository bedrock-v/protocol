module src

import src.serializer
import src.types

pub const stack_request_action_take = u8(0)
pub const stack_request_action_place = u8(1)
pub const stack_request_action_swap = u8(2)
pub const stack_request_action_drop = u8(3)
pub const stack_request_action_destroy = u8(4)
pub const stack_request_action_consume = u8(5)
pub const stack_request_action_create = u8(6)
pub const stack_request_action_place_in_container = u8(7)
pub const stack_request_action_take_out_container = u8(8)
pub const stack_request_action_lab_table_combine = u8(9)
pub const stack_request_action_beacon_payment = u8(10)
pub const stack_request_action_mine_block = u8(11)
pub const stack_request_action_craft_recipe = u8(12)
pub const stack_request_action_craft_recipe_auto = u8(13)
pub const stack_request_action_craft_creative = u8(14)
pub const stack_request_action_craft_recipe_optional = u8(15)
pub const stack_request_action_craft_grindstone = u8(16)
pub const stack_request_action_craft_loom = u8(17)
pub const stack_request_action_craft_non_implemented = u8(18)
pub const stack_request_action_craft_results_deprecated = u8(19)

pub struct StackRequestSlotInfo {
pub mut:
	container        types.FullContainerName
	slot             u8
	stack_network_id int
}

pub struct StackRequestAction {
pub mut:
	action_type             u8
	count                   u8
	source                  StackRequestSlotInfo
	destination             StackRequestSlotInfo
	randomly                bool
	results_slot            u8
	primary_effect          int
	secondary_effect        int
	hotbar_slot             int
	predicted_durability    int
	stack_network_id        int
	recipe_network_id       u32
	number_of_crafts        u8
	times_crafted           u8
	ingredients             []types.ItemDescriptorCount
	creative_item_network_id u32
	filter_string_index     int
	cost                    int
	pattern                 string
	result_items            []types.ItemStack
}

pub struct ItemStackRequestEntry {
pub mut:
	request_id     int
	actions        []StackRequestAction
	filter_strings []string
	filter_cause   int
}

pub struct ItemStackRequestPacket {
pub mut:
	requests []ItemStackRequestEntry
}

pub fn (p &ItemStackRequestPacket) pid() u16 {
	return item_stack_request_packet
}

pub fn (p &ItemStackRequestPacket) name() string {
	return 'ItemStackRequestPacket'
}

pub fn (p &ItemStackRequestPacket) can_be_sent_before_login() bool {
	return false
}

fn read_stack_request_slot_info(mut r serializer.Reader) !StackRequestSlotInfo {
	return StackRequestSlotInfo{
		container:        r.read_full_container_name()!
		slot:             r.u8()!
		stack_network_id: r.read_varint32()!
	}
}

fn write_stack_request_slot_info(mut w serializer.Writer, s StackRequestSlotInfo) {
	w.write_full_container_name(s.container)
	w.u8(s.slot)
	w.write_varint32(s.stack_network_id)
}

fn read_stack_request_action(mut r serializer.Reader) !StackRequestAction {
	mut a := StackRequestAction{
		action_type: r.u8()!
	}
	match a.action_type {
		stack_request_action_take, stack_request_action_place, stack_request_action_place_in_container,
		stack_request_action_take_out_container {
			a.count = r.u8()!
			a.source = read_stack_request_slot_info(mut r)!
			a.destination = read_stack_request_slot_info(mut r)!
		}
		stack_request_action_swap {
			a.source = read_stack_request_slot_info(mut r)!
			a.destination = read_stack_request_slot_info(mut r)!
		}
		stack_request_action_drop {
			a.count = r.u8()!
			a.source = read_stack_request_slot_info(mut r)!
			a.randomly = r.bool()!
		}
		stack_request_action_destroy, stack_request_action_consume {
			a.count = r.u8()!
			a.source = read_stack_request_slot_info(mut r)!
		}
		stack_request_action_create {
			a.results_slot = r.u8()!
		}
		stack_request_action_lab_table_combine {}
		stack_request_action_beacon_payment {
			a.primary_effect = r.read_varint32()!
			a.secondary_effect = r.read_varint32()!
		}
		stack_request_action_mine_block {
			a.hotbar_slot = r.read_varint32()!
			a.predicted_durability = r.read_varint32()!
			a.stack_network_id = r.read_varint32()!
		}
		stack_request_action_craft_recipe {
			a.recipe_network_id = r.read_varuint32()!
			a.number_of_crafts = r.u8()!
		}
		stack_request_action_craft_recipe_auto {
			a.recipe_network_id = r.read_varuint32()!
			a.number_of_crafts = r.u8()!
			a.times_crafted = r.u8()!
			ing_count := r.read_varuint32()!
			a.ingredients = []types.ItemDescriptorCount{}
			for _ in 0 .. ing_count {
				a.ingredients << r.read_item_descriptor_count()!
			}
		}
		stack_request_action_craft_creative {
			a.creative_item_network_id = r.read_varuint32()!
			a.number_of_crafts = r.u8()!
		}
		stack_request_action_craft_recipe_optional {
			a.recipe_network_id = r.read_varuint32()!
			a.filter_string_index = r.le_i32()!
		}
		stack_request_action_craft_grindstone {
			a.recipe_network_id = r.read_varuint32()!
			a.number_of_crafts = r.u8()!
			a.cost = r.read_varint32()!
		}
		stack_request_action_craft_loom {
			a.pattern = r.read_string()!
			a.times_crafted = r.u8()!
		}
		stack_request_action_craft_non_implemented {}
		stack_request_action_craft_results_deprecated {
			res_count := r.read_varuint32()!
			a.result_items = []types.ItemStack{}
			for _ in 0 .. res_count {
				a.result_items << r.read_item_stack_without_stack_id()!
			}
			a.times_crafted = r.u8()!
		}
		else {}
	}
	return a
}

fn write_stack_request_action(mut w serializer.Writer, a StackRequestAction) {
	w.u8(a.action_type)
	match a.action_type {
		stack_request_action_take, stack_request_action_place, stack_request_action_place_in_container,
		stack_request_action_take_out_container {
			w.u8(a.count)
			write_stack_request_slot_info(mut w, a.source)
			write_stack_request_slot_info(mut w, a.destination)
		}
		stack_request_action_swap {
			write_stack_request_slot_info(mut w, a.source)
			write_stack_request_slot_info(mut w, a.destination)
		}
		stack_request_action_drop {
			w.u8(a.count)
			write_stack_request_slot_info(mut w, a.source)
			w.bool(a.randomly)
		}
		stack_request_action_destroy, stack_request_action_consume {
			w.u8(a.count)
			write_stack_request_slot_info(mut w, a.source)
		}
		stack_request_action_create {
			w.u8(a.results_slot)
		}
		stack_request_action_lab_table_combine {}
		stack_request_action_beacon_payment {
			w.write_varint32(a.primary_effect)
			w.write_varint32(a.secondary_effect)
		}
		stack_request_action_mine_block {
			w.write_varint32(a.hotbar_slot)
			w.write_varint32(a.predicted_durability)
			w.write_varint32(a.stack_network_id)
		}
		stack_request_action_craft_recipe {
			w.write_varuint32(a.recipe_network_id)
			w.u8(a.number_of_crafts)
		}
		stack_request_action_craft_recipe_auto {
			w.write_varuint32(a.recipe_network_id)
			w.u8(a.number_of_crafts)
			w.u8(a.times_crafted)
			w.write_varuint32(u32(a.ingredients.len))
			for ing in a.ingredients {
				w.write_item_descriptor_count(ing)
			}
		}
		stack_request_action_craft_creative {
			w.write_varuint32(a.creative_item_network_id)
			w.u8(a.number_of_crafts)
		}
		stack_request_action_craft_recipe_optional {
			w.write_varuint32(a.recipe_network_id)
			w.le_i32(a.filter_string_index)
		}
		stack_request_action_craft_grindstone {
			w.write_varuint32(a.recipe_network_id)
			w.u8(a.number_of_crafts)
			w.write_varint32(a.cost)
		}
		stack_request_action_craft_loom {
			w.write_string(a.pattern)
			w.u8(a.times_crafted)
		}
		stack_request_action_craft_non_implemented {}
		stack_request_action_craft_results_deprecated {
			w.write_varuint32(u32(a.result_items.len))
			for item in a.result_items {
				w.write_item_stack_without_stack_id(item)
			}
			w.u8(a.times_crafted)
		}
		else {}
	}
}

fn read_item_stack_request_entry(mut r serializer.Reader) !ItemStackRequestEntry {
	mut e := ItemStackRequestEntry{
		request_id: r.read_varint32()!
	}
	action_count := r.read_varuint32()!
	e.actions = []StackRequestAction{}
	for _ in 0 .. action_count {
		e.actions << read_stack_request_action(mut r)!
	}
	filter_count := r.read_varuint32()!
	e.filter_strings = []string{}
	for _ in 0 .. filter_count {
		e.filter_strings << r.read_string()!
	}
	e.filter_cause = r.le_i32()!
	return e
}

fn write_item_stack_request_entry(mut w serializer.Writer, e ItemStackRequestEntry) {
	w.write_varint32(e.request_id)
	w.write_varuint32(u32(e.actions.len))
	for a in e.actions {
		write_stack_request_action(mut w, a)
	}
	w.write_varuint32(u32(e.filter_strings.len))
	for s in e.filter_strings {
		w.write_string(s)
	}
	w.le_i32(e.filter_cause)
}

pub fn (mut p ItemStackRequestPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.requests = []ItemStackRequestEntry{}
	for _ in 0 .. count {
		p.requests << read_item_stack_request_entry(mut r)!
	}
}

pub fn (p &ItemStackRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.requests.len))
	for e in p.requests {
		write_item_stack_request_entry(mut w, e)
	}
}
