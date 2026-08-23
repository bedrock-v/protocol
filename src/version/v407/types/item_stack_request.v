module types

import protocol.serializer
import protocol.version.v340.types as types_340
import protocol.version.v407.enums

pub struct ItemStackRequestSlotData {
pub mut:
	container        enums.ContainerSlotType
	slot             u8
	stack_network_id i32
}

pub fn (t ItemStackRequestSlotData) encode(mut w serializer.Writer) {
	t.container.encode(mut w)
	w.u8(t.slot)
	w.write_varint32(t.stack_network_id)
}

pub fn ItemStackRequestSlotData.decode(mut r serializer.Reader) !ItemStackRequestSlotData {
	return ItemStackRequestSlotData{
		container:        enums.ContainerSlotType.decode(mut r)!
		slot:             r.u8()!
		stack_network_id: r.read_varint32()!
	}
}

pub struct TakeAction {
pub mut:
	count       u8
	source      ItemStackRequestSlotData
	destination ItemStackRequestSlotData
}

pub struct PlaceAction {
pub mut:
	count       u8
	source      ItemStackRequestSlotData
	destination ItemStackRequestSlotData
}

pub struct SwapAction {
pub mut:
	source      ItemStackRequestSlotData
	destination ItemStackRequestSlotData
}

pub struct DropAction {
pub mut:
	count    u8
	source   ItemStackRequestSlotData
	randomly bool
}

pub struct DestroyAction {
pub mut:
	count  u8
	source ItemStackRequestSlotData
}

pub struct ConsumeAction {
pub mut:
	count  u8
	source ItemStackRequestSlotData
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

pub struct CraftNonImplementedAction {
}

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
	| CraftResultsDeprecatedAction
	| CreateAction
	| DestroyAction
	| DropAction
	| LabTableCombineAction
	| PlaceAction
	| SwapAction
	| TakeAction

pub fn (t ItemStackRequestAction) action_type() enums.ItemStackRequestActionType {
	return match t {
		TakeAction { enums.ItemStackRequestActionType.take }
		PlaceAction { enums.ItemStackRequestActionType.place }
		SwapAction { enums.ItemStackRequestActionType.swap }
		DropAction { enums.ItemStackRequestActionType.drop }
		DestroyAction { enums.ItemStackRequestActionType.destroy }
		ConsumeAction { enums.ItemStackRequestActionType.consume }
		CreateAction { enums.ItemStackRequestActionType.create }
		LabTableCombineAction { enums.ItemStackRequestActionType.lab_table_combine }
		BeaconPaymentAction { enums.ItemStackRequestActionType.beacon_payment }
		CraftRecipeAction { enums.ItemStackRequestActionType.craft_recipe }
		AutoCraftRecipeAction { enums.ItemStackRequestActionType.craft_recipe_auto }
		CraftCreativeAction { enums.ItemStackRequestActionType.craft_creative }
		CraftNonImplementedAction { enums.ItemStackRequestActionType.craft_non_implemented_deprecated }
		CraftResultsDeprecatedAction { enums.ItemStackRequestActionType.craft_results_deprecated }
	}
}

pub fn (t ItemStackRequestAction) encode(mut w serializer.Writer) {
	t.action_type().encode(mut w)
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
		CraftRecipeAction {
			w.write_varuint32(t.recipe_network_id)
		}
		AutoCraftRecipeAction {
			w.write_varuint32(t.recipe_network_id)
		}
		CraftCreativeAction {
			w.write_varuint32(t.creative_item_network_id)
		}
		CraftNonImplementedAction {}
		CraftResultsDeprecatedAction {
			w.write_varuint32(u32(t.result_items.len))
			for item in t.result_items {
				item.encode(mut w)
			}
			w.u8(t.times_crafted)
		}
	}
}

pub fn ItemStackRequestAction.decode(mut r serializer.Reader) !ItemStackRequestAction {
	raw := r.u8()!
	if raw > u8(enums.ItemStackRequestActionType.craft_results_deprecated) {
		return error('invalid item stack request action type ${raw}')
	}
	action_type := unsafe { enums.ItemStackRequestActionType(raw) }
	match action_type {
		.take {
			return TakeAction{
				count:       r.u8()!
				source:      ItemStackRequestSlotData.decode(mut r)!
				destination: ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.place {
			return PlaceAction{
				count:       r.u8()!
				source:      ItemStackRequestSlotData.decode(mut r)!
				destination: ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.swap {
			return SwapAction{
				source:      ItemStackRequestSlotData.decode(mut r)!
				destination: ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.drop {
			return DropAction{
				count:    r.u8()!
				source:   ItemStackRequestSlotData.decode(mut r)!
				randomly: r.bool()!
			}
		}
		.destroy {
			return DestroyAction{
				count:  r.u8()!
				source: ItemStackRequestSlotData.decode(mut r)!
			}
		}
		.consume {
			return ConsumeAction{
				count:  r.u8()!
				source: ItemStackRequestSlotData.decode(mut r)!
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
		.craft_non_implemented_deprecated {
			return CraftNonImplementedAction{}
		}
		.craft_results_deprecated {
			count := r.read_count()!
			mut items := []types_340.ItemData{cap: serializer.prealloc(count)}
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
	request_id i32
	actions    []ItemStackRequestAction
}

pub fn (t ItemStackRequest) encode(mut w serializer.Writer) {
	w.write_varint32(t.request_id)
	w.write_varuint32(u32(t.actions.len))
	for action in t.actions {
		action.encode(mut w)
	}
}

pub fn ItemStackRequest.decode(mut r serializer.Reader) !ItemStackRequest {
	mut t := ItemStackRequest{}
	t.request_id = r.read_varint32()!
	count := r.read_count()!
	t.actions = []ItemStackRequestAction{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.actions << ItemStackRequestAction.decode(mut r)!
	}
	return t
}
