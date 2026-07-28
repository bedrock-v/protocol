module types

import protocol.serializer
import protocol.version.v422.enums
import protocol.version.v340.types as types_340
import protocol.version.v407.types as types_407

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

pub struct CraftRecipeAction {
pub mut:
	recipe_network_id u32
}

pub struct AutoCraftRecipeAction {
pub mut:
	recipe_network_id u32
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

pub struct CraftNonImplementedAction {}

pub struct CraftResultsDeprecatedAction {
pub mut:
	result_items  []types_340.ItemData
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
	| PlaceAction
	| SwapAction
	| TakeAction

pub fn (t ItemStackRequestAction) encode(mut w serializer.Writer) {
	match t {
		TakeAction {
			enums.ItemStackRequestActionType.take.encode(mut w)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		PlaceAction {
			enums.ItemStackRequestActionType.place.encode(mut w)
			w.u8(t.count)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		SwapAction {
			enums.ItemStackRequestActionType.swap.encode(mut w)
			t.source.encode(mut w)
			t.destination.encode(mut w)
		}
		DropAction {
			enums.ItemStackRequestActionType.drop.encode(mut w)
			w.u8(t.count)
			t.source.encode(mut w)
			w.bool(t.randomly)
		}
		DestroyAction {
			enums.ItemStackRequestActionType.destroy.encode(mut w)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		ConsumeAction {
			enums.ItemStackRequestActionType.consume.encode(mut w)
			w.u8(t.count)
			t.source.encode(mut w)
		}
		CreateAction {
			enums.ItemStackRequestActionType.create.encode(mut w)
			w.u8(t.slot)
		}
		LabTableCombineAction {
			enums.ItemStackRequestActionType.lab_table_combine.encode(mut w)
		}
		BeaconPaymentAction {
			enums.ItemStackRequestActionType.beacon_payment.encode(mut w)
			w.write_varint32(t.primary_effect)
			w.write_varint32(t.secondary_effect)
		}
		CraftRecipeAction {
			enums.ItemStackRequestActionType.craft_recipe.encode(mut w)
			w.write_varuint32(t.recipe_network_id)
		}
		AutoCraftRecipeAction {
			enums.ItemStackRequestActionType.craft_recipe_auto.encode(mut w)
			w.write_varuint32(t.recipe_network_id)
		}
		CraftCreativeAction {
			enums.ItemStackRequestActionType.craft_creative.encode(mut w)
			w.write_varuint32(t.creative_item_network_id)
		}
		CraftRecipeOptionalAction {
			enums.ItemStackRequestActionType.craft_recipe_optional.encode(mut w)
			w.write_varuint32(t.recipe_network_id)
			w.le_i32(t.filtered_string_index)
		}
		CraftNonImplementedAction {
			enums.ItemStackRequestActionType.craft_non_implemented_deprecated.encode(mut w)
		}
		CraftResultsDeprecatedAction {
			enums.ItemStackRequestActionType.craft_results_deprecated.encode(mut w)
			w.write_varuint32(u32(t.result_items.len))
			for item in t.result_items {
				item.encode(mut w)
			}
			w.u8(t.times_crafted)
		}
	}
}

pub fn ItemStackRequestAction.decode(mut r serializer.Reader) !ItemStackRequestAction {
	action_type := enums.ItemStackRequestActionType.decode(mut r)!
	match action_type {
		.take {
			return TakeAction{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.place {
			return PlaceAction{
				count:       r.u8()!
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.swap {
			return SwapAction{
				source:      types_407.ItemStackRequestSlotData.decode(mut r)!
				destination: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.drop {
			return DropAction{
				count:    r.u8()!
				source:   types_407.ItemStackRequestSlotData.decode(mut r)!
				randomly: r.bool()!
			}
		}
		.destroy {
			return DestroyAction{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.consume {
			return ConsumeAction{
				count:  r.u8()!
				source: types_407.ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.create {
			return CreateAction{
				slot: r.u8()!
			}
		}
		.lab_table_combine {
			return LabTableCombineAction{}
		}
		.beacon_payment {
			return BeaconPaymentAction{
				primary_effect:   r.read_varint32()!
				secondary_effect: r.read_varint32()!
			}
		}
		.craft_recipe {
			return CraftRecipeAction{
				recipe_network_id: r.read_varuint32()!
			}
		}
		.craft_recipe_auto {
			return AutoCraftRecipeAction{
				recipe_network_id: r.read_varuint32()!
			}
		}
		.craft_creative {
			return CraftCreativeAction{
				creative_item_network_id: r.read_varuint32()!
			}
		}
		.craft_recipe_optional {
			return CraftRecipeOptionalAction{
				recipe_network_id:     r.read_varuint32()!
				filtered_string_index: r.le_i32()!
			}
		}
		.craft_non_implemented_deprecated {
			return CraftNonImplementedAction{}
		}
		.craft_results_deprecated {
			count := int(r.read_varuint32()!)
			mut items := []types_340.ItemData{cap: count}
			for _ in 0 .. count {
				items << types_340.ItemData.decode(mut r)!
			}
			return CraftResultsDeprecatedAction{
				result_items:  items
				times_crafted: r.u8()!
			}
		}
	}
}

pub struct ItemStackRequest {
pub mut:
	request_id     i32
	actions        []ItemStackRequestAction
	filter_strings []string
}

pub fn (t ItemStackRequest) encode(mut w serializer.Writer) {
	w.write_varint32(t.request_id)
	w.write_varuint32(u32(t.actions.len))
	for action in t.actions {
		action.encode(mut w)
	}
	w.write_varuint32(u32(t.filter_strings.len))
	for s in t.filter_strings {
		w.write_string(s)
	}
}

pub fn ItemStackRequest.decode(mut r serializer.Reader) !ItemStackRequest {
	mut t := ItemStackRequest{}
	t.request_id = r.read_varint32()!
	action_count := int(r.read_varuint32()!)
	t.actions = []ItemStackRequestAction{cap: action_count}
	for _ in 0 .. action_count {
		t.actions << ItemStackRequestAction.decode(mut r)!
	}
	filter_count := int(r.read_varuint32()!)
	t.filter_strings = []string{cap: filter_count}
	for _ in 0 .. filter_count {
		t.filter_strings << r.read_string()!
	}
	return t
}
