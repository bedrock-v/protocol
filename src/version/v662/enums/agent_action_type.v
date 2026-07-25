module enums

import serializer

pub enum AgentActionType as i32 {
	attack              = 1
	collect             = 2
	destroy             = 3
	detect_redstone     = 4
	detect_obstacle     = 5
	drop                = 6
	drop_all            = 7
	inspect             = 8
	inspect_data        = 9
	inspect_item_count  = 10
	inspect_item_detail = 11
	inspect_item_space  = 12
	interact            = 13
	move                = 14
	place_block         = 15
	till                = 16
	transfer_item_to    = 17
	turn                = 18
}

pub fn (e AgentActionType) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn AgentActionType.decode(mut r serializer.Reader) !AgentActionType {
	return unsafe { AgentActionType(r.le_i32()!) }
}
