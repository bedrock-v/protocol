module types

import protocol.serializer
import protocol.version.v662.types as types_662

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

pub struct ItemStackActionPlaceInItemContainer {
pub mut:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct ItemStackActionTakeFromItemContainer {
pub mut:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
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
	times_crafted              i8
	ingredients                []types_662.ItemDescriptorCount
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

pub struct ItemStackActionCraftResults {}

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
	| ItemStackActionPlaceInItemContainer
	| ItemStackActionScreenBeaconPayment
	| ItemStackActionScreenHudMineBlock
	| ItemStackActionScreenLabTableCombine
	| ItemStackActionSwap
	| ItemStackActionTake
	| ItemStackActionTakeFromItemContainer

pub fn (t ItemStackRequestActionType) encode(mut w serializer.Writer) {
	match t {
		ItemStackActionTake {
			w.i8(0)
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionPlace {
			w.i8(1)
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionSwap {
			w.i8(2)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionDrop {
			w.i8(3)
			w.i8(t.amount)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		ItemStackActionDestroy {
			w.i8(4)
			w.i8(t.amount)
			t.source.encode(mut w)
		}
		ItemStackActionConsume {
			w.i8(5)
			w.i8(t.amount)
			t.source.encode(mut w)
		}
		ItemStackActionCreate {
			w.i8(6)
			w.i8(t.slot)
		}
		ItemStackActionPlaceInItemContainer {
			w.i8(7)
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionTakeFromItemContainer {
			w.i8(8)
			w.i8(t.amount)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		ItemStackActionScreenLabTableCombine {
			w.i8(9)
		}
		ItemStackActionScreenBeaconPayment {
			w.i8(10)
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		ItemStackActionScreenHudMineBlock {
			w.i8(11)
			w.write_varint32(t.hotbar_slot)
			w.write_varint32(t.predicted_durability)
			w.write_varint32(t.stack_network_id)
		}
		ItemStackActionCraftRecipe {
			w.i8(12)
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftRecipeAuto {
			w.i8(13)
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
			w.i8(t.times_crafted)
			w.write_varuint32(u32(t.ingredients.len))
			for e in t.ingredients {
				e.encode(mut w)
			}
		}
		ItemStackActionCraftCreative {
			w.i8(14)
			w.write_varuint32(t.creative_item_network_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftRecipeOptional {
			w.i8(15)
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_strings_index)
		}
		ItemStackActionCraftRepairAndDisenchant {
			w.i8(16)
			w.write_varuint32(t.recipe_network_id)
			w.i8(t.number_of_requested_crafts)
			w.write_varint32(t.repair_cost)
		}
		ItemStackActionCraftLoom {
			w.i8(17)
			w.write_string(t.pattern_id)
			w.i8(t.number_of_requested_crafts)
		}
		ItemStackActionCraftNonImplemented {
			w.i8(18)
		}
		ItemStackActionCraftResults {
			w.i8(19)
		}
	}
}

pub fn ItemStackRequestActionType.decode(mut r serializer.Reader) !ItemStackRequestActionType {
	d := r.i8()!
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
			return ItemStackActionPlaceInItemContainer{
				amount:      r.i8()!
				source:      ItemStackRequestSlotInfo.decode(mut r)!
				destination: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		8 {
			return ItemStackActionTakeFromItemContainer{
				amount:      r.i8()!
				source:      ItemStackRequestSlotInfo.decode(mut r)!
				destination: ItemStackRequestSlotInfo.decode(mut r)!
			}
		}
		9 {
			return ItemStackActionScreenLabTableCombine{}
		}
		10 {
			return ItemStackActionScreenBeaconPayment{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		11 {
			return ItemStackActionScreenHudMineBlock{
				hotbar_slot:          r.read_varint32()!
				predicted_durability: r.read_varint32()!
				stack_network_id:     r.read_varint32()!
			}
		}
		12 {
			return ItemStackActionCraftRecipe{
				recipe_network_id:          r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
			}
		}
		13 {
			recipe_network_id := r.read_varuint32()!
			number_of_requested_crafts := r.i8()!
			times_crafted := r.i8()!
			count := r.read_count()!
			mut ings := []types_662.ItemDescriptorCount{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				ings << types_662.ItemDescriptorCount.decode(mut r)!
			}
			return ItemStackActionCraftRecipeAuto{
				recipe_network_id:          recipe_network_id
				number_of_requested_crafts: number_of_requested_crafts
				times_crafted:              times_crafted
				ingredients:                ings
			}
		}
		14 {
			return ItemStackActionCraftCreative{
				creative_item_network_id:   r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
			}
		}
		15 {
			return ItemStackActionCraftRecipeOptional{
				recipe_network_id:      r.read_varuint32()!
				filtered_strings_index: r.le_i32()!
			}
		}
		16 {
			return ItemStackActionCraftRepairAndDisenchant{
				recipe_network_id:          r.read_varuint32()!
				number_of_requested_crafts: r.i8()!
				repair_cost:                r.read_varint32()!
			}
		}
		17 {
			return ItemStackActionCraftLoom{
				pattern_id:                 r.read_string()!
				number_of_requested_crafts: r.i8()!
			}
		}
		18 {
			return ItemStackActionCraftNonImplemented{}
		}
		19 {
			return ItemStackActionCraftResults{}
		}
		else {
			return error('invalid ItemStackRequestActionType ${d}')
		}
	}
}
