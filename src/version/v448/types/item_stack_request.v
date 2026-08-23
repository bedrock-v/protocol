module types

import protocol.serializer
import protocol.version.v428.enums as enums_428
import protocol.version.v407.types as types_407
import protocol.version.v431.types as types_431

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

pub struct LabTableCombineAction {
}

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

pub struct CraftNonImplementedAction {
}

pub struct CraftResultsDeprecatedAction {
pub mut:
	result_items  []types_431.ItemData
	times_crafted u8
}

pub type ItemStackRequestAction = AutoCraftRecipeAction
	| BeaconPaymentAction
	| ConsumeAction
	| CraftCreativeAction
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

pub fn (t ItemStackRequestAction) action_type() enums_428.ItemStackRequestActionType {
	return match t {
		TakeAction { .take }
		PlaceAction { .place }
		SwapAction { .swap }
		DropAction { .drop }
		DestroyAction { .destroy }
		ConsumeAction { .consume }
		CreateAction { .create }
		LabTableCombineAction { .lab_table_combine }
		BeaconPaymentAction { .beacon_payment }
		MineBlockAction { .mine_block }
		CraftRecipeAction { .craft_recipe }
		AutoCraftRecipeAction { .craft_recipe_auto }
		CraftCreativeAction { .craft_creative }
		CraftRecipeOptionalAction { .craft_recipe_optional }
		CraftNonImplementedAction { .craft_non_implemented_deprecated }
		CraftResultsDeprecatedAction { .craft_results_deprecated }
	}
}

pub fn (t ItemStackRequestAction) encode(mut w serializer.Writer) {
	w.u8(u8(t.action_type()))
	match t {
		TakeAction {
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		PlaceAction {
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		SwapAction {
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		DropAction {
			w.u8(t.count)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		DestroyAction {
			w.u8(t.count)
			t.source.encode(mut w)
		}
		ConsumeAction {
			w.u8(t.count)
			t.source.encode(mut w)
		}
		CreateAction {
			w.u8(t.slot)
		}
		LabTableCombineAction {}
		BeaconPaymentAction {
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		MineBlockAction {
			w.write_varint32(t.hotbar_slot)
			w.write_varint32(t.predicted_durability)
			w.write_varint32(t.stack_network_id)
		}
		CraftRecipeAction {
			w.write_varuint32(t.recipe_network_id)
		}
		AutoCraftRecipeAction {
			w.write_varuint32(t.recipe_network_id)
			w.u8(t.times_crafted)
		}
		CraftCreativeAction {
			w.write_varuint32(t.creative_item_network_id)
		}
		CraftRecipeOptionalAction {
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_string_index)
		}
		CraftNonImplementedAction {}
		CraftResultsDeprecatedAction {
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
		7 {
			return LabTableCombineAction{}
		}
		8 {
			return BeaconPaymentAction{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		9 {
			return MineBlockAction{
				hotbar_slot:          r.read_varint32()!
				predicted_durability: r.read_varint32()!
				stack_network_id:     r.read_varint32()!
			}
		}
		10 {
			return CraftRecipeAction{
				recipe_network_id: r.read_varuint32()!
			}
		}
		11 {
			return AutoCraftRecipeAction{
				recipe_network_id: r.read_varuint32()!
				times_crafted:     r.u8()!
			}
		}
		12 {
			return CraftCreativeAction{
				creative_item_network_id: r.read_varuint32()!
			}
		}
		13 {
			return CraftRecipeOptionalAction{
				recipe_network_id:     r.read_varuint32()!
				filtered_string_index: r.le_i32()!
			}
		}
		14 {
			return CraftNonImplementedAction{}
		}
		15 {
			count := r.read_count()!
			mut items := []types_431.ItemData{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				items << types_431.ItemData.decode_instance(mut r)!
			}
			return CraftResultsDeprecatedAction{
				result_items:  items
				times_crafted: r.u8()!
			}
		}
		else {
			return error('invalid item stack request action type ${action_type}')
		}
	}
}
