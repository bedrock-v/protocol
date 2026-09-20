module protocol

import protocol.enums
import protocol.packets
import protocol.types

// The unions below are declared here rather than aliased from the version that
// defines them.

pub struct TakeAction {
pub:
	amount      i8
	source      types.ItemStackRequestSlotInfo
	destination types.ItemStackRequestSlotInfo
}

pub struct PlaceAction {
pub:
	amount      i8
	source      types.ItemStackRequestSlotInfo
	destination types.ItemStackRequestSlotInfo
}

pub struct SwapAction {
pub:
	source      types.ItemStackRequestSlotInfo
	destination types.ItemStackRequestSlotInfo
}

pub struct DropAction {
pub:
	amount   i8
	source   types.ItemStackRequestSlotInfo
	randomly bool
}

pub struct DestroyAction {
pub:
	amount i8
	source types.ItemStackRequestSlotInfo
}

pub struct ConsumeAction {
pub:
	amount i8
	source types.ItemStackRequestSlotInfo
}

pub struct CraftCreativeAction {
pub:
	creative_item_network_id u32
}

pub struct CraftRecipeAction {
pub:
	recipe_network_id u32
	number_of_crafts  i8
}

pub struct AutoCraftRecipeAction {
pub:
	recipe_network_id u32
	number_of_crafts  i8
}

// OtherAction stands for every request action a server doesn't act on, a
// match over the union stays total without listing the crafting screens one by
// one.
pub struct OtherAction {}

pub type ItemStackAction = AutoCraftRecipeAction
	| ConsumeAction
	| CraftCreativeAction
	| CraftRecipeAction
	| DestroyAction
	| DropAction
	| OtherAction
	| PlaceAction
	| SwapAction
	| TakeAction

// item_stack_action reads one action of an item stack request.
pub fn item_stack_action(action types.ItemStackRequestActionType) ItemStackAction {
	return match action {
		types.ItemStackActionTake {
			ItemStackAction(TakeAction{
				amount:      action.amount
				source:      action.source
				destination: action.destination
			})
		}
		types.ItemStackActionPlace {
			ItemStackAction(PlaceAction{
				amount:      action.amount
				source:      action.source
				destination: action.destination
			})
		}
		types.ItemStackActionSwap {
			ItemStackAction(SwapAction{
				source:      action.source
				destination: action.destination
			})
		}
		types.ItemStackActionDrop {
			ItemStackAction(DropAction{
				amount:   action.amount
				source:   action.source
				randomly: action.randomly
			})
		}
		types.ItemStackActionDestroy {
			ItemStackAction(DestroyAction{
				amount: action.amount
				source: action.source
			})
		}
		types.ItemStackActionConsume {
			ItemStackAction(ConsumeAction{
				amount: action.amount
				source: action.source
			})
		}
		types.ItemStackActionCraftCreative {
			ItemStackAction(CraftCreativeAction{
				creative_item_network_id: action.creative_item_network_id
			})
		}
		types.ItemStackActionCraftRecipe {
			ItemStackAction(CraftRecipeAction{
				recipe_network_id: action.recipe_network_id
				number_of_crafts:  action.number_of_requested_crafts
			})
		}
		types.ItemStackActionCraftRecipeAuto {
			ItemStackAction(AutoCraftRecipeAction{
				recipe_network_id: action.recipe_network_id
				number_of_crafts:  action.number_of_requested_crafts
			})
		}
		else {
			ItemStackAction(OtherAction{})
		}
	}
}

// The narrowings below do the same job for the unions that are aliased rather
// than redeclared: the check has to name the defining type, which only this
// module can do.

pub fn data_item_float(item types.DataItemType) ?types.DataItemFloat {
	if item is types.DataItemFloat {
		return item
	}
	return none
}

pub fn data_item_int64(item types.DataItemType) ?types.DataItemInt64 {
	if item is types.DataItemInt64 {
		return item
	}
	return none
}

pub fn score_entry_change_fake_player(entry packets.ScorePacketEntry) ?packets.ScoreEntryChangeFakePlayer {
	if entry is packets.ScoreEntryChangeFakePlayer {
		return entry
	}
	return none
}

pub fn player_list_add(entry packets.PlayerListEntry) ?packets.PlayerListAdd {
	if entry is packets.PlayerListAdd {
		return entry
	}
	return none
}

pub fn text_chat(message enums.TextPacketType) ?enums.TextChat {
	if message is enums.TextChat {
		return message
	}
	return none
}

pub fn text_raw(message enums.TextPacketType) ?enums.TextRaw {
	if message is enums.TextRaw {
		return message
	}
	return none
}

pub fn text_translate(message enums.TextPacketType) ?enums.TextTranslate {
	if message is enums.TextTranslate {
		return message
	}
	return none
}

pub fn data_item_byte(item types.DataItemType) ?types.DataItemByte {
	if item is types.DataItemByte {
		return item
	}
	return none
}

pub fn data_item_string(item types.DataItemType) ?types.DataItemString {
	if item is types.DataItemString {
		return item
	}
	return none
}
