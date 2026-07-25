module types

import serializer
import version.v407.types as types_407
import version.v431.types as types_431
import version.v554.types as types_554

pub struct TakeAction {
pub mut:
	count       u8
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct PlaceAction {
pub mut:
	count       u8
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct SwapAction {
pub mut:
	source      types_407.ItemStackRequestSlotData
	destination types_407.ItemStackRequestSlotData
}

pub struct DropAction {
pub mut:
	count    u8
	source   types_407.ItemStackRequestSlotData
	randomly bool
}

pub struct DestroyAction {
pub mut:
	count  u8
	source types_407.ItemStackRequestSlotData
}

pub struct ConsumeAction {
pub mut:
	count  u8
	source types_407.ItemStackRequestSlotData
}

pub struct CreateAction {
pub mut:
	slot u8
}

pub struct LabTableCombineAction {}

pub struct BeaconPaymentAction {
pub mut:
	primary_effect   i32
	secondary_effect i32
}

pub struct MineBlockAction {
pub mut:
	hotbar_slot          i32
	predicted_durability i32
	stack_network_id     i32
}

pub struct CraftRecipeAction {
pub mut:
	recipe_network_id u32
}

pub struct AutoCraftRecipeAction {
pub mut:
	recipe_network_id u32
	times_crafted     u8
	ingredients       []types_554.ItemDescriptorWithCount
}

pub struct CraftCreativeAction {
pub mut:
	creative_item_network_id u32
}

pub struct CraftRecipeOptionalAction {
pub mut:
	recipe_network_id     u32
	filtered_string_index i32
}

pub struct CraftGrindstoneAction {
pub mut:
	recipe_network_id u32
	repair_cost       i32
}

pub struct CraftLoomAction {
pub mut:
	pattern_id string
}

pub struct CraftNonImplementedAction {}

pub struct CraftResultsDeprecatedAction {
pub mut:
	result_items  []types_431.ItemData
	times_crafted u8
}

pub type ItemStackRequestAction = AutoCraftRecipeAction
	| BeaconPaymentAction
	| ConsumeAction
	| CraftCreativeAction
	| CraftGrindstoneAction
	| CraftLoomAction
	| CraftNonImplementedAction
	| CraftRecipeAction
	| CraftRecipeOptionalAction
	| CraftResultsDeprecatedAction
	| CreateAction
	| DestroyAction
	| DropAction
	| LabTableCombineAction
	| MineBlockAction
	| PlaceAction
	| SwapAction
	| TakeAction

pub fn (t ItemStackRequestAction) encode(mut w serializer.Writer) {
	match t {
		TakeAction {
			w.u8(0)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		PlaceAction {
			w.u8(1)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		SwapAction {
			w.u8(2)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		DropAction {
			w.u8(3)
			w.u8(t.count)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		DestroyAction {
			w.u8(4)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		ConsumeAction {
			w.u8(5)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		CreateAction {
			w.u8(6)
			w.u8(t.slot)
		}
		LabTableCombineAction {
			w.u8(9)
		}
		BeaconPaymentAction {
			w.u8(10)
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		MineBlockAction {
			w.u8(11)
			w.write_varint32(t.hotbar_slot)
			w.write_varint32(t.predicted_durability)
			w.write_varint32(t.stack_network_id)
		}
		CraftRecipeAction {
			w.u8(12)
			w.write_varuint32(t.recipe_network_id)
		}
		AutoCraftRecipeAction {
			w.u8(13)
			w.write_varuint32(t.recipe_network_id)
			w.u8(t.times_crafted)
			w.u8(u8(t.ingredients.len))
			for ingredient in t.ingredients {
				ingredient.encode(mut w)
			}
		}
		CraftCreativeAction {
			w.u8(14)
			w.write_varuint32(t.creative_item_network_id)
		}
		CraftRecipeOptionalAction {
			w.u8(15)
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_string_index)
		}
		CraftGrindstoneAction {
			w.u8(16)
			w.write_varuint32(t.recipe_network_id)
			w.write_varint32(t.repair_cost)
		}
		CraftLoomAction {
			w.u8(17)
			w.write_string(t.pattern_id)
		}
		CraftNonImplementedAction {
			w.u8(18)
		}
		CraftResultsDeprecatedAction {
			w.u8(19)
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
			return TakeAction{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		1 {
			return PlaceAction{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		2 {
			return SwapAction{
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		3 {
			return DropAction{
				count:    r.u8()!
				source:   types_407.ItemStackRequestSlotData.decode(mut r)!
				randomly: r.bool()!
			}
		}
		4 {
			return DestroyAction{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		5 {
			return ConsumeAction{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		6 {
			return CreateAction{
				slot: r.u8()!
			}
		}
		9 {
			return LabTableCombineAction{}
		}
		10 {
			return BeaconPaymentAction{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		11 {
			return MineBlockAction{
				hotbar_slot:          r.read_varint32()!
				predicted_durability: r.read_varint32()!
				stack_network_id:     r.read_varint32()!
			}
		}
		12 {
			return CraftRecipeAction{
				recipe_network_id: r.read_varuint32()!
			}
		}
		13 {
			recipe_network_id := r.read_varuint32()!
			times_crafted := r.u8()!
			ingredient_count := int(r.u8()!)
			mut ingredients := []types_554.ItemDescriptorWithCount{cap: ingredient_count}
			for _ in 0 .. ingredient_count {
				ingredients << types_554.ItemDescriptorWithCount.decode(mut r)!
			}
			return AutoCraftRecipeAction{
				recipe_network_id: recipe_network_id
				times_crafted:     times_crafted
				ingredients:       ingredients
			}
		}
		14 {
			return CraftCreativeAction{
				creative_item_network_id: r.read_varuint32()!
			}
		}
		15 {
			return CraftRecipeOptionalAction{
				recipe_network_id:     r.read_varuint32()!
				filtered_string_index: r.le_i32()!
			}
		}
		16 {
			return CraftGrindstoneAction{
				recipe_network_id: r.read_varuint32()!
				repair_cost:       r.read_varint32()!
			}
		}
		17 {
			return CraftLoomAction{
				pattern_id: r.read_string()!
			}
		}
		18 {
			return CraftNonImplementedAction{}
		}
		19 {
			item_count := int(r.read_varuint32()!)
			mut result_items := []types_431.ItemData{cap: item_count}
			for _ in 0 .. item_count {
				result_items << types_431.ItemData.decode_instance(mut r)!
			}
			return CraftResultsDeprecatedAction{
				result_items:  result_items
				times_crafted: r.u8()!
			}
		}
		else {
			return error('unhandled item stack request action type ${action_type}')
		}
	}
}
