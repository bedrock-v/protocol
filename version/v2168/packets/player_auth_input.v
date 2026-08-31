module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v2168.enums
import protocol.version.v662.types as types_662
import protocol.version.v662.enums as enums_662

pub enum ClientPlayMode as u32 {
	normal                 = 0
	teaser                 = 1
	screen                 = 2
	viewer                 = 3
	reality                = 4
	placement              = 5
	living_room            = 6
	exit_level             = 7
	exit_level_living_room = 8
	num_modes              = 9
}

pub fn (e ClientPlayMode) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ClientPlayMode.decode(mut r serializer.Reader) !ClientPlayMode {
	return unsafe { ClientPlayMode(r.read_varuint32()!) }
}

pub struct PerformItemStackRequestData {
pub mut:
	client_request_id        u32
	actions                  []types.ItemStackRequestActionType
	strings_to_filter        []string
	strings_to_filter_origin enums_662.TextProcessingEventOrigin
}

pub fn (e PerformItemStackRequestData) encode(mut w serializer.Writer) {
	w.write_varuint32(e.client_request_id)
	w.write_varuint32(u32(e.actions.len))
	for a in e.actions {
		a.encode(mut w)
	}
	w.write_varuint32(u32(e.strings_to_filter.len))
	for s in e.strings_to_filter {
		w.write_string(s)
	}
	e.strings_to_filter_origin.encode(mut w)
}

pub fn PerformItemStackRequestData.decode(mut r serializer.Reader) !PerformItemStackRequestData {
	mut e := PerformItemStackRequestData{}
	e.client_request_id = r.read_varuint32()!
	act_count := r.read_count()!
	e.actions = []types.ItemStackRequestActionType{cap: serializer.prealloc(act_count)}
	for _ in 0 .. act_count {
		e.actions << types.ItemStackRequestActionType.decode(mut r)!
	}
	str_count := r.read_count()!
	e.strings_to_filter = []string{cap: serializer.prealloc(str_count)}
	for _ in 0 .. str_count {
		e.strings_to_filter << r.read_string()!
	}
	e.strings_to_filter_origin = enums_662.TextProcessingEventOrigin.decode(mut r)!
	return e
}

pub struct PlayerAuthInputPacket {
pub mut:
	player_rotation          [2]f32
	player_position          [3]f32
	move_vector              [2]f32
	player_head_rotation     f32
	input_data               []enums.PlayerAuthInputData
	input_mode               enums_662.InputMode
	play_mode                ClientPlayMode
	new_interaction_model    enums.NewInteractionModel
	interact_rotation        [2]f32
	client_tick              u64
	pos_delta                [3]f32
	item_use_transaction     ?types.PackedItemUseLegacyInventoryTransaction
	item_stack_request       ?PerformItemStackRequestData
	player_block_actions     ?[]types.PlayerBlockActionData
	vehicle_rotation         ?[2]f32
	client_predicted_vehicle ?types_662.ActorUniqueID
	analog_move_vector       [2]f32
	camera_orientation       [3]f32
	raw_move_vector          [2]f32
}

pub fn (p &PlayerAuthInputPacket) pid() u16 {
	return 144
}

pub fn (p &PlayerAuthInputPacket) name() string {
	return 'PlayerAuthInputPacket'
}

pub fn (p &PlayerAuthInputPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerAuthInputPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.player_rotation[0])
	w.le_f32(p.player_rotation[1])
	w.le_f32(p.player_position[0])
	w.le_f32(p.player_position[1])
	w.le_f32(p.player_position[2])
	w.le_f32(p.move_vector[0])
	w.le_f32(p.move_vector[1])
	w.le_f32(p.player_head_rotation)
	w.bool(true)
	w.write_varuint32(u32(p.input_data.len))
	for e in p.input_data {
		e.encode(mut w)
	}
	p.input_mode.encode(mut w)
	p.play_mode.encode(mut w)
	p.new_interaction_model.encode(mut w)
	w.le_f32(p.interact_rotation[0])
	w.le_f32(p.interact_rotation[1])
	w.write_varuint64(p.client_tick)
	w.le_f32(p.pos_delta[0])
	w.le_f32(p.pos_delta[1])
	w.le_f32(p.pos_delta[2])
	w.bool(true)
	if v := p.item_use_transaction {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.bool(true)
	if v := p.item_stack_request {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.bool(true)
	if actions := p.player_block_actions {
		w.bool(true)
		w.write_varuint32(u32(actions.len))
		for e in actions {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	w.bool(true)
	if v := p.vehicle_rotation {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
	} else {
		w.bool(false)
	}
	w.bool(true)
	if v := p.client_predicted_vehicle {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.le_f32(p.analog_move_vector[0])
	w.le_f32(p.analog_move_vector[1])
	w.le_f32(p.camera_orientation[0])
	w.le_f32(p.camera_orientation[1])
	w.le_f32(p.camera_orientation[2])
	w.le_f32(p.raw_move_vector[0])
	w.le_f32(p.raw_move_vector[1])
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_rotation = [r.le_f32()!, r.le_f32()!]!
	p.player_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.move_vector = [r.le_f32()!, r.le_f32()!]!
	p.player_head_rotation = r.le_f32()!
	if r.bool()! {
		count := r.read_count()!
		p.input_data = []enums.PlayerAuthInputData{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.input_data << enums.PlayerAuthInputData.decode(mut r)!
		}
	} else {
		p.input_data = []enums.PlayerAuthInputData{}
	}
	p.input_mode = enums_662.InputMode.decode(mut r)!
	p.play_mode = ClientPlayMode.decode(mut r)!
	p.new_interaction_model = enums.NewInteractionModel.decode(mut r)!
	p.interact_rotation = [r.le_f32()!, r.le_f32()!]!
	p.client_tick = r.read_varuint64()!
	p.pos_delta = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	if r.bool()! {
		if r.bool()! {
			p.item_use_transaction = types.PackedItemUseLegacyInventoryTransaction.decode(mut r)!
		}
	} else {
		p.item_use_transaction = none
	}
	if r.bool()! {
		if r.bool()! {
			p.item_stack_request = PerformItemStackRequestData.decode(mut r)!
		}
	} else {
		p.item_stack_request = none
	}
	if r.bool()! {
		if r.bool()! {
			count := r.read_count()!
			mut actions := []types.PlayerBlockActionData{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				actions << types.PlayerBlockActionData.decode(mut r)!
			}
			p.player_block_actions = actions
		}
	} else {
		p.player_block_actions = none
	}
	if r.bool()! {
		if r.bool()! {
			p.vehicle_rotation = [r.le_f32()!, r.le_f32()!]!
		}
	} else {
		p.vehicle_rotation = none
	}
	if r.bool()! {
		if r.bool()! {
			p.client_predicted_vehicle = types_662.ActorUniqueID.decode(mut r)!
		}
	} else {
		p.client_predicted_vehicle = none
	}
	p.analog_move_vector = [r.le_f32()!, r.le_f32()!]!
	p.camera_orientation = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.raw_move_vector = [r.le_f32()!, r.le_f32()!]!
}
