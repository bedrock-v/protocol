module types

import protocol.serializer
import protocol.version.v2168.enums

pub struct ItemDescriptorCount {
pub mut:
	descriptor enums.ItemDescriptorType = enums.ItemDescEmpty{}
	count      i32
}

pub fn (t ItemDescriptorCount) encode(mut w serializer.Writer) {
	t.descriptor.encode(mut w)
	w.write_varint32(t.count)
}

pub fn ItemDescriptorCount.decode(mut r serializer.Reader) !ItemDescriptorCount {
	return ItemDescriptorCount{
		descriptor: enums.ItemDescriptorType.decode(mut r)!
		count:      r.read_varint32()!
	}
}

pub struct ItemStackActionTake {
pub mut:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct ItemStackActionPlace {
pub mut:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct ItemStackActionSwap {
pub mut:
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct ItemStackActionDrop {
pub mut:
	amount   i8
	source   ItemStackRequestSlotInfo
	randomly bool
}

pub struct ItemStackActionDestroy {
pub mut:
	amount i8
	source ItemStackRequestSlotInfo
}

pub struct ItemStackActionConsume {
pub mut:
	amount i8
	source ItemStackRequestSlotInfo
}

pub struct ItemStackActionCreate {
pub mut:
	slot i8
}

pub struct ItemStackActionScreenLabTableCombine {}

pub struct ItemStackActionScreenBeaconPayment {
pub mut:
	primary_effect   i32
	secondary_effect i32
}

pub struct ItemStackActionScreenHudMineBlock {
pub mut:
	hotbar_slot          i32
	predicted_durability i32
	stack_network_id     i32
}

pub struct ItemStackActionCraftRecipe {
pub mut:
	recipe_network_id          u32
	number_of_requested_crafts i8
}

pub struct ItemStackActionCraftRecipeAuto {
pub mut:
	recipe_network_id          u32
	number_of_requested_crafts i8
	ingredients                []ItemDescriptorCount
}

pub struct ItemStackActionCraftCreative {
pub mut:
	creative_item_network_id   u32
	number_of_requested_crafts i8
}

pub struct ItemStackActionCraftRecipeOptional {
pub mut:
	recipe_network_id      u32
	filtered_strings_index i32
}

pub struct ItemStackActionCraftRepairAndDisenchant {
pub mut:
	recipe_network_id          u32
	number_of_requested_crafts i8
	repair_cost                i32
}

pub struct ItemStackActionCraftLoom {
pub mut:
	pattern_id                 string
	number_of_requested_crafts i8
}

pub struct ItemStackActionCraftNonImplemented {}

pub struct ItemStackActionCraftResults {
pub mut:
	result_items  []ItemStackRequestNetworkItemInstanceDescriptor
	times_crafted i8
}

pub type ItemStackRequestActionType = ItemStackActionConsume
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
	| ItemStackActionPlace
	| ItemStackActionScreenBeaconPayment
	| ItemStackActionScreenHudMineBlock
	| ItemStackActionScreenLabTableCombine
	| ItemStackActionSwap
	| ItemStackActionTake

pub fn (t ItemStackRequestActionType) type_id() u32 {
	return match t {
		ItemStackActionTake { u32(0) }
		ItemStackActionPlace { u32(1) }
		ItemStackActionSwap { u32(2) }
		ItemStackActionDrop { u32(3) }
		ItemStackActionDestroy { u32(4) }
		ItemStackActionConsume { u32(5) }
		ItemStackActionCreate { u32(6) }
		ItemStackActionScreenLabTableCombine { u32(7) }
		ItemStackActionScreenBeaconPayment { u32(8) }
		ItemStackActionScreenHudMineBlock { u32(9) }
		ItemStackActionCraftRecipe { u32(10) }
		ItemStackActionCraftRecipeAuto { u32(11) }
		ItemStackActionCraftCreative { u32(12) }
		ItemStackActionCraftRecipeOptional { u32(13) }
		ItemStackActionCraftRepairAndDisenchant { u32(14) }
		ItemStackActionCraftLoom { u32(15) }
		ItemStackActionCraftNonImplemented { u32(16) }
		ItemStackActionCraftResults { u32(17) }
	}
}

pub fn (t ItemStackRequestActionType) legacy_type_id() u8 {
	return match t {
		ItemStackActionTake { u8(0) }
		ItemStackActionPlace { u8(1) }
		ItemStackActionSwap { u8(2) }
		ItemStackActionDrop { u8(3) }
		ItemStackActionDestroy { u8(4) }
		ItemStackActionConsume { u8(5) }
		ItemStackActionCreate { u8(6) }
		ItemStackActionScreenLabTableCombine { u8(9) }
		ItemStackActionScreenBeaconPayment { u8(10) }
		ItemStackActionScreenHudMineBlock { u8(11) }
		ItemStackActionCraftRecipe { u8(12) }
		ItemStackActionCraftRecipeAuto { u8(13) }
		ItemStackActionCraftCreative { u8(14) }
		ItemStackActionCraftRecipeOptional { u8(15) }
		ItemStackActionCraftRepairAndDisenchant { u8(16) }
		ItemStackActionCraftLoom { u8(17) }
		ItemStackActionCraftNonImplemented { u8(18) }
		ItemStackActionCraftResults { u8(19) }
	}
}

pub fn (t ItemStackRequestActionType) encode(mut w serializer.Writer) {
	w.write_varuint32(t.type_id())
	w.u8(t.legacy_type_id())
	match t {
		ItemStackActionTake {
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionPlace {
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionSwap {
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionDrop {
			w.i8(t.amount)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		ItemStackActionDestroy {
			w.i8(t.amount)
			t.source.encode(mut w)
		}
		ItemStackActionConsume {
			w.i8(t.amount)
			t.source.encode(mut w)
		}
		ItemStackActionCreate {
			w.i8(t.slot)
		}
		ItemStackActionScreenLabTableCombine {}
		ItemStackActionScreenBeaconPayment {
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		ItemStackActionScreenHudMineBlock {
			w.write_varint32(t.hotbar_slot)
			w.write_varint32(t.predicted_durability)
			w.write_varint32(t.stack_network_id)
		}
		ItemStackActionCraftRecipe {
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftRecipeAuto {
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
			w.write_varuint32(u32(t.ingredients.len))
			for e in t.ingredients {
				e.encode(mut w)
			}
		}
		ItemStackActionCraftCreative {
			w.write_varuint32(t.creative_item_network_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftRecipeOptional {
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_strings_index)
		}
		ItemStackActionCraftRepairAndDisenchant {
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
			w.write_varint32(t.repair_cost)
		}
		ItemStackActionCraftLoom {
			w.write_string(t.pattern_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftNonImplemented {}
		ItemStackActionCraftResults {
			w.write_varuint32(u32(t.result_items.len))
			for e in t.result_items {
				e.encode(mut w)
			}
			w.i8(t.times_crafted)
		}
	}
}

pub fn ItemStackRequestActionType.decode(mut r serializer.Reader) !ItemStackRequestActionType {
	d := r.read_varuint32()!
	r.u8()!
	match d {
		0 {
			return ItemStackActionTake{
				amount:      r.i8()!
				source:      ItemStackRequestSlotInfo.decode(mut r)!
				destination: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		1 {
			return ItemStackActionPlace{
				amount:      r.i8()!
				source:      ItemStackRequestSlotInfo.decode(mut r)!
				destination: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		2 {
			return ItemStackActionSwap{
				source:      ItemStackRequestSlotInfo.decode(mut r)!
				destination: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		3 {
			return ItemStackActionDrop{
				amount:   r.i8()!
				source:   ItemStackRequestSlotInfo.decode(mut r)!
				randomly: r.bool()!
			}
		}
		4 {
			return ItemStackActionDestroy{
				amount: r.i8()!
				source: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		5 {
			return ItemStackActionConsume{
				amount: r.i8()!
				source: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		6 {
			return ItemStackActionCreate{
				slot: r.i8()!
			}
		}
		7 {
			return ItemStackActionScreenLabTableCombine{}
		}
		8 {
			return ItemStackActionScreenBeaconPayment{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		9 {
			return ItemStackActionScreenHudMineBlock{
				hotbar_slot:          r.read_varint32()!
				predicted_durability: r.read_varint32()!
				stack_network_id:     r.read_varint32()!
			}
		}
		10 {
			return ItemStackActionCraftRecipe{
				recipe_network_id:          r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
			}
		}
		11 {
			recipe_network_id := r.read_varuint32()!
			number_of_requested_crafts := r.i8()!
			count := r.read_count()!
			mut ings := []ItemDescriptorCount{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				ings << ItemDescriptorCount.decode(mut r)!
			}
			return ItemStackActionCraftRecipeAuto{
				recipe_network_id:          recipe_network_id
				number_of_requested_crafts: number_of_requested_crafts
				ingredients:                ings
			}
		}
		12 {
			return ItemStackActionCraftCreative{
				creative_item_network_id:   r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
			}
		}
		13 {
			return ItemStackActionCraftRecipeOptional{
				recipe_network_id:      r.read_varuint32()!
				filtered_strings_index: r.le_i32()!
			}
		}
		14 {
			return ItemStackActionCraftRepairAndDisenchant{
				recipe_network_id:          r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
				repair_cost:                r.read_varint32()!
			}
		}
		15 {
			return ItemStackActionCraftLoom{
				pattern_id:                 r.read_string()!
				number_of_requested_crafts: r.i8()!
			}
		}
		16 {
			return ItemStackActionCraftNonImplemented{}
		}
		17 {
			count := r.read_count()!
			mut items := []ItemStackRequestNetworkItemInstanceDescriptor{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				items << ItemStackRequestNetworkItemInstanceDescriptor.decode(mut r)!
			}
			return ItemStackActionCraftResults{
				result_items:  items
				times_crafted: r.i8()!
			}
		}
		else {
			return error('invalid ItemStackRequestActionType ${d}')
		}
	}
}
