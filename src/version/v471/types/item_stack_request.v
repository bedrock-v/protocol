module types

import serializer
import version.v407.types as types_407
import version.v431.types as types_431

pub struct ItemStackActionTake {
pub mut:
	count       u8
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct ItemStackActionPlace {
pub mut:
	count       u8
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct ItemStackActionSwap {
pub mut:
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct ItemStackActionDrop {
pub mut:
	count    u8
	source   types_407.ItemStackRequestSlotData
	randomly bool
}

pub struct ItemStackActionDestroy {
pub mut:
	count  u8
	source types_407.ItemStackRequestSlotData
}

pub struct ItemStackActionConsume {
pub mut:
	count  u8
	source types_407.ItemStackRequestSlotData
}

pub struct ItemStackActionCreate {
pub mut:
	slot u8
}

pub struct ItemStackActionLabTableCombine {}

pub struct ItemStackActionBeaconPayment {
pub mut:
	primary_effect   i32
	secondary_effect i32
}

pub struct ItemStackActionMineBlock {
pub mut:
	hotbar_slot          i32
	predicted_durability i32
	stack_network_id     i32
}

pub struct ItemStackActionCraftRecipe {
pub mut:
	recipe_network_id u32
}

pub struct ItemStackActionCraftRecipeAuto {
pub mut:
	recipe_network_id u32
	times_crafted     u8
}

pub struct ItemStackActionCraftCreative {
pub mut:
	creative_item_network_id u32
}

pub struct ItemStackActionCraftRecipeOptional {
pub mut:
	recipe_network_id     u32
	filtered_string_index i32
}

pub struct ItemStackActionCraftRepairAndDisenchant {
pub mut:
	recipe_network_id u32
	repair_cost       i32
}

pub struct ItemStackActionCraftLoom {
pub mut:
	pattern_id string
}

pub struct ItemStackActionCraftNonImplemented {}

pub struct ItemStackActionCraftResults {
pub mut:
	result_items  []types_431.ItemData
	times_crafted u8
}

pub type ItemStackRequestAction = ItemStackActionBeaconPayment
	| ItemStackActionConsume
	| ItemStackActionCraftCreative
	| ItemStackActionCraftLoom
	| ItemStackActionCraftNonImplemented
	| ItemStackActionCraftRecipe
	| ItemStackActionCraftRecipeAuto
	| ItemStackActionCraftRecipeOptional
	| ItemStackActionCraftRepairAndDisenchant
	| ItemStackActionCraftResults
	| ItemStackActionCreate
	| ItemStackActionDestroy
	| ItemStackActionDrop
	| ItemStackActionLabTableCombine
	| ItemStackActionMineBlock
	| ItemStackActionPlace
	| ItemStackActionSwap
	| ItemStackActionTake

pub fn (t ItemStackRequestAction) encode(mut w serializer.Writer) {
	match t {
		ItemStackActionTake {
			w.u8(0)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionPlace {
			w.u8(1)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionSwap {
			w.u8(2)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionDrop {
			w.u8(3)
			w.u8(t.count)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		ItemStackActionDestroy {
			w.u8(4)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		ItemStackActionConsume {
			w.u8(5)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		ItemStackActionCreate {
			w.u8(6)
			w.u8(t.slot)
		}
		ItemStackActionLabTableCombine {
			w.u8(7)
		}
		ItemStackActionBeaconPayment {
			w.u8(8)
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		ItemStackActionMineBlock {
			w.u8(9)
			w.write_varint32(t.hotbar_slot)
			w.write_varint32(t.predicted_durability)
			w.write_varint32(t.stack_network_id)
		}
		ItemStackActionCraftRecipe {
			w.u8(10)
			w.write_varuint32(t.recipe_network_id)
		}
		ItemStackActionCraftRecipeAuto {
			w.u8(11)
			w.write_varuint32(t.recipe_network_id)
			w.u8(t.times_crafted)
		}
		ItemStackActionCraftCreative {
			w.u8(12)
			w.write_varuint32(t.creative_item_network_id)
		}
		ItemStackActionCraftRecipeOptional {
			w.u8(13)
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_string_index)
		}
		ItemStackActionCraftRepairAndDisenchant {
			w.u8(14)
			w.write_varuint32(t.recipe_network_id)
			w.write_varint32(t.repair_cost)
		}
		ItemStackActionCraftLoom {
			w.u8(15)
			w.write_string(t.pattern_id)
		}
		ItemStackActionCraftNonImplemented {
			w.u8(16)
		}
		ItemStackActionCraftResults {
			w.u8(17)
			w.write_varuint32(u32(t.result_items.len))
			for item in t.result_items {
				item.encode_instance(mut w)
			}
			w.u8(t.times_crafted)
		}
	}
}

pub fn ItemStackRequestAction.decode(mut r serializer.Reader) !ItemStackRequestAction {
	action_type := r.u8()!
	match action_type {
		0 {
			return ItemStackActionTake{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		1 {
			return ItemStackActionPlace{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		2 {
			return ItemStackActionSwap{
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		3 {
			return ItemStackActionDrop{
				count:    r.u8()!
				source:   types_407.ItemStackRequestSlotData.decode(mut r)!
				randomly: r.bool()!
			}
		}
		4 {
			return ItemStackActionDestroy{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		5 {
			return ItemStackActionConsume{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		6 {
			return ItemStackActionCreate{
				slot: r.u8()!
			}
		}
		7 {
			return ItemStackActionLabTableCombine{}
		}
		8 {
			return ItemStackActionBeaconPayment{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		9 {
			return ItemStackActionMineBlock{
				hotbar_slot:          r.read_varint32()!
				predicted_durability: r.read_varint32()!
				stack_network_id:     r.read_varint32()!
			}
		}
		10 {
			return ItemStackActionCraftRecipe{
				recipe_network_id: r.read_varuint32()!
			}
		}
		11 {
			return ItemStackActionCraftRecipeAuto{
				recipe_network_id: r.read_varuint32()!
				times_crafted:     r.u8()!
			}
		}
		12 {
			return ItemStackActionCraftCreative{
				creative_item_network_id: r.read_varuint32()!
			}
		}
		13 {
			return ItemStackActionCraftRecipeOptional{
				recipe_network_id:     r.read_varuint32()!
				filtered_string_index: r.le_i32()!
			}
		}
		14 {
			return ItemStackActionCraftRepairAndDisenchant{
				recipe_network_id: r.read_varuint32()!
				repair_cost:       r.read_varint32()!
			}
		}
		15 {
			return ItemStackActionCraftLoom{
				pattern_id: r.read_string()!
			}
		}
		16 {
			return ItemStackActionCraftNonImplemented{}
		}
		17 {
			mut t := ItemStackActionCraftResults{}
			item_count := int(r.read_varuint32()!)
			t.result_items = []types_431.ItemData{cap: item_count}
			for _ in 0 .. item_count {
				t.result_items << types_431.ItemData.decode_instance(mut r)!
			}
			t.times_crafted = r.u8()!
			return t
		}
		else {
			return error('invalid item stack request action type ${action_type}')
		}
	}
}
