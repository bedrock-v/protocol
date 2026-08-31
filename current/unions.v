module current

import protocol.version.v924.enums as enums_924
import protocol.version.v2168.packets as packets_2168
import protocol.version.v2168.types as types_2168
import protocol.version.v2168.enums as enums_2168
import protocol.version.v2192.packets as packets_2192

// The unions below are declared here rather than aliased from the version that
// defines them. V only accepts the defining type in a match over a sum type, so
// an alias would leave a caller unable to take one apart the ordinary way.

pub struct BookEditReplacePage {
pub:
	page_index int
	text       string
	photo_name string
}

pub struct BookEditAddPage {
pub:
	page_index int
	text       string
	photo_name string
}

pub struct BookEditDeletePage {
pub:
	page_index int
}

pub struct BookEditSwapPages {
pub:
	page_index_a int
	page_index_b int
}

pub struct BookEditFinalize {
pub:
	title  string
	author string
	xuid   string
}

pub type BookEditAction = BookEditAddPage
	| BookEditDeletePage
	| BookEditFinalize
	| BookEditReplacePage
	| BookEditSwapPages

// book_edit_action reads the edit a BookEditPacket carries.
pub fn book_edit_action(action enums_924.BookEditAction) BookEditAction {
	return match action {
		enums_924.BookEditReplacePage {
			BookEditAction(BookEditReplacePage{
				page_index: int(action.page_index)
				text:       action.text
				photo_name: action.photo_name
			})
		}
		enums_924.BookEditAddPage {
			BookEditAction(BookEditAddPage{
				page_index: int(action.page_index)
				text:       action.text
				photo_name: action.photo_name
			})
		}
		enums_924.BookEditDeletePage {
			BookEditAction(BookEditDeletePage{
				page_index: int(action.page_index)
			})
		}
		enums_924.BookEditSwapPages {
			BookEditAction(BookEditSwapPages{
				page_index_a: int(action.page_index_a)
				page_index_b: int(action.page_index_b)
			})
		}
		enums_924.BookEditFinalize {
			BookEditAction(BookEditFinalize{
				title:  action.title
				author: action.author
				xuid:   action.xuid
			})
		}
	}
}

pub struct ResourcePackResponseCancel {}

pub struct ResourcePackResponseDownloading {
pub:
	downloading_packs []string
}

pub struct ResourcePackResponseDownloadingFinished {}

pub struct ResourcePackResponseStackFinished {}

pub type ResourcePackResponse = ResourcePackResponseCancel
	| ResourcePackResponseDownloading
	| ResourcePackResponseDownloadingFinished
	| ResourcePackResponseStackFinished

// resource_pack_response reads the answer a client gives to the pack list.
pub fn resource_pack_response(response packets_2168.ResourcePackClientResponse) ResourcePackResponse {
	return match response {
		packets_2168.ResourcePackResponseCancel {
			ResourcePackResponse(ResourcePackResponseCancel{})
		}
		packets_2168.ResourcePackResponseDownloading {
			ResourcePackResponse(ResourcePackResponseDownloading{
				downloading_packs: response.downloading_packs
			})
		}
		packets_2168.ResourcePackResponseDownloadingFinished {
			ResourcePackResponse(ResourcePackResponseDownloadingFinished{})
		}
		packets_2168.ResourcePackResponseStackFinished {
			ResourcePackResponse(ResourcePackResponseStackFinished{})
		}
	}
}

pub struct TakeAction {
pub:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct PlaceAction {
pub:
	amount      i8
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct SwapAction {
pub:
	source      ItemStackRequestSlotInfo
	destination ItemStackRequestSlotInfo
}

pub struct DropAction {
pub:
	amount   i8
	source   ItemStackRequestSlotInfo
	randomly bool
}

pub struct DestroyAction {
pub:
	amount i8
	source ItemStackRequestSlotInfo
}

pub struct ConsumeAction {
pub:
	amount i8
	source ItemStackRequestSlotInfo
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

// OtherAction stands for every request action a server does not act on, so a
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
pub fn item_stack_action(action types_2168.ItemStackRequestActionType) ItemStackAction {
	return match action {
		types_2168.ItemStackActionTake {
			ItemStackAction(TakeAction{
				amount:      action.amount
				source:      action.source
				destination: action.destination
			})
		}
		types_2168.ItemStackActionPlace {
			ItemStackAction(PlaceAction{
				amount:      action.amount
				source:      action.source
				destination: action.destination
			})
		}
		types_2168.ItemStackActionSwap {
			ItemStackAction(SwapAction{
				source:      action.source
				destination: action.destination
			})
		}
		types_2168.ItemStackActionDrop {
			ItemStackAction(DropAction{
				amount:   action.amount
				source:   action.source
				randomly: action.randomly
			})
		}
		types_2168.ItemStackActionDestroy {
			ItemStackAction(DestroyAction{
				amount: action.amount
				source: action.source
			})
		}
		types_2168.ItemStackActionConsume {
			ItemStackAction(ConsumeAction{
				amount: action.amount
				source: action.source
			})
		}
		types_2168.ItemStackActionCraftCreative {
			ItemStackAction(CraftCreativeAction{
				creative_item_network_id: action.creative_item_network_id
			})
		}
		types_2168.ItemStackActionCraftRecipe {
			ItemStackAction(CraftRecipeAction{
				recipe_network_id: action.recipe_network_id
				number_of_crafts:  action.number_of_requested_crafts
			})
		}
		types_2168.ItemStackActionCraftRecipeAuto {
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

pub fn data_item_float(item DataItemType) ?DataItemFloat {
	if item is enums_2168.DataItemFloat {
		return item
	}
	return none
}

pub fn data_item_int64(item DataItemType) ?DataItemInt64 {
	if item is enums_2168.DataItemInt64 {
		return item
	}
	return none
}

pub fn score_entry_change_fake_player(entry ScorePacketEntry) ?ScoreEntryChangeFakePlayer {
	if entry is packets_2168.ScoreEntryChangeFakePlayer {
		return entry
	}
	return none
}

pub fn player_list_add(entry PlayerListEntry) ?PlayerListAdd {
	if entry is packets_2192.PlayerListAdd {
		return entry
	}
	return none
}

pub fn text_chat(message TextPacketType) ?TextChat {
	if message is enums_924.TextChat {
		return message
	}
	return none
}

pub fn text_raw(message TextPacketType) ?TextRaw {
	if message is enums_924.TextRaw {
		return message
	}
	return none
}

pub fn text_translate(message TextPacketType) ?TextTranslate {
	if message is enums_924.TextTranslate {
		return message
	}
	return none
}

pub fn data_item_byte(item DataItemType) ?DataItemByte {
	if item is enums_2168.DataItemByte {
		return item
	}
	return none
}

pub fn data_item_string(item DataItemType) ?DataItemString {
	if item is enums_2168.DataItemString {
		return item
	}
	return none
}
