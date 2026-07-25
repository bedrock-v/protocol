module packets

import serializer
import version.v662.types as types_662
import version.v662.enums
import version.v944.types

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

pub enum PlayerAuthInputFlag {
	ascend                           = 0
	descend                          = 1
	north_jump                       = 2
	jump_down                        = 3
	sprint_down                      = 4
	change_height                    = 5
	jumping                          = 6
	auto_jumping_in_water            = 7
	sneaking                         = 8
	sneak_down                       = 9
	up                               = 10
	down                             = 11
	left                             = 12
	right                            = 13
	up_left                          = 14
	up_right                         = 15
	want_up                          = 16
	want_down                        = 17
	want_down_slow                   = 18
	want_up_slow                     = 19
	sprinting                        = 20
	ascend_block                     = 21
	descend_block                    = 22
	sneak_toggle_down                = 23
	persist_sneak                    = 24
	start_sprinting                  = 25
	stop_sprinting                   = 26
	start_sneaking                   = 27
	stop_sneaking                    = 28
	start_swimming                   = 29
	stop_swimming                    = 30
	start_jumping                    = 31
	start_gliding                    = 32
	stop_gliding                     = 33
	perform_item_interaction         = 34
	perform_block_actions            = 35
	perform_item_stack_request       = 36
	handle_teleport                  = 37
	emoting                          = 38
	missed_swing                     = 39
	start_crawling                   = 40
	stop_crawling                    = 41
	start_flying                     = 42
	stop_flying                      = 43
	received_server_data             = 44
	is_in_client_predicted_vehicle   = 45
	paddle_left                      = 46
	paddle_right                     = 47
	block_breaking_delay_enabled     = 48
	horizontal_collision             = 49
	vertical_collision               = 50
	down_left                        = 51
	down_right                       = 52
	start_using_item                 = 53
	camera_relative_movement_enabled = 54
	rot_controlled_by_move_direction = 55
	start_spin_attack                = 56
	stop_spin_attack                 = 57
	hotbar_only_touch                = 58
	jump_released_raw                = 59
	jump_pressed_raw                 = 60
	jump_current_raw                 = 61
	sneak_released_raw               = 62
	sneak_pressed_raw                = 63
	sneak_current_raw                = 64
}

pub struct PlayerAuthInputData {
pub mut:
	lo u64
	hi u64
}

pub fn (d PlayerAuthInputData) has(f PlayerAuthInputFlag) bool {
	i := int(f)
	if i < 64 {
		return (d.lo >> u64(i)) & 1 == 1
	}
	return (d.hi >> u64(i - 64)) & 1 == 1
}

pub fn (d PlayerAuthInputData) encode(mut w serializer.Writer) {
	mut lo := d.lo
	mut hi := d.hi
	for {
		b := u8(lo & 0x7f)
		lo = (lo >> 7) | (hi << 57)
		hi = hi >> 7
		if lo == 0 && hi == 0 {
			w.u8(b)
			break
		}
		w.u8(b | 0x80)
	}
}

pub fn PlayerAuthInputData.decode(mut r serializer.Reader) !PlayerAuthInputData {
	mut lo := u64(0)
	mut hi := u64(0)
	mut shift := 0
	for {
		b := r.u8()!
		v := u64(b & 0x7f)
		if shift < 64 {
			lo |= v << u64(shift)
			if shift > 57 {
				hi |= v >> u64(64 - shift)
			}
		} else {
			hi |= v << u64(shift - 64)
		}
		if b & 0x80 == 0 {
			break
		}
		shift += 7
		if shift >= 128 {
			return error('varuint128 is too long')
		}
	}
	return PlayerAuthInputData{
		lo: lo
		hi: hi
	}
}

pub struct ActionsEntry {
pub mut:
	action_type types.ItemStackRequestActionType = types.ItemStackActionTake{}
	amount      i8
	source      types.ItemStackRequestSlotInfo
	destination types.ItemStackRequestSlotInfo
}

pub fn (e ActionsEntry) encode(mut w serializer.Writer) {
	e.action_type.encode(mut w)
	w.i8(e.amount)
	e.source.encode(mut w)
	e.destination.encode(mut w)
}

pub fn ActionsEntry.decode(mut r serializer.Reader) !ActionsEntry {
	return ActionsEntry{
		action_type: types.ItemStackRequestActionType.decode(mut r)!
		amount:      r.i8()!
		source:      types.ItemStackRequestSlotInfo.decode(mut r)!
		destination: types.ItemStackRequestSlotInfo.decode(mut r)!
	}
}

pub struct PerformItemStackRequestData {
pub mut:
	client_request_id        u32
	actions                  []ActionsEntry
	strings_to_filter        []string
	strings_to_filter_origin enums.TextProcessingEventOrigin
}

pub fn (t PerformItemStackRequestData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.client_request_id)
	w.write_varuint32(u32(t.actions.len))
	for e in t.actions {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.strings_to_filter.len))
	for s in t.strings_to_filter {
		w.write_string(s)
	}
	t.strings_to_filter_origin.encode(mut w)
}

pub fn PerformItemStackRequestData.decode(mut r serializer.Reader) !PerformItemStackRequestData {
	mut t := PerformItemStackRequestData{}
	t.client_request_id = r.read_varuint32()!
	act_count := int(r.read_varuint32()!)
	t.actions = []ActionsEntry{cap: act_count}
	for _ in 0 .. act_count {
		t.actions << ActionsEntry.decode(mut r)!
	}
	str_count := int(r.read_varuint32()!)
	t.strings_to_filter = []string{cap: str_count}
	for _ in 0 .. str_count {
		t.strings_to_filter << r.read_string()!
	}
	t.strings_to_filter_origin = enums.TextProcessingEventOrigin.decode(mut r)!
	return t
}

pub struct ClientPredictedVehicleData {
pub mut:
	vehicle_rotation         [2]f32
	client_predicted_vehicle types_662.ActorUniqueID
}

pub fn (t ClientPredictedVehicleData) encode(mut w serializer.Writer) {
	w.le_f32(t.vehicle_rotation[0])
	w.le_f32(t.vehicle_rotation[1])
	t.client_predicted_vehicle.encode(mut w)
}

pub fn ClientPredictedVehicleData.decode(mut r serializer.Reader) !ClientPredictedVehicleData {
	return ClientPredictedVehicleData{
		vehicle_rotation:         [r.le_f32()!, r.le_f32()!]!
		client_predicted_vehicle: types_662.ActorUniqueID.decode(mut r)!
	}
}

pub struct PlayerAuthInputPacket {
pub mut:
	player_rotation          [2]f32
	player_position          [3]f32
	move_vector              [2]f32
	player_head_rotation     f32
	input_data               PlayerAuthInputData
	input_mode               enums.InputMode
	play_mode                ClientPlayMode
	new_interaction_model    enums.NewInteractionModel
	interact_rotation        [2]f32
	client_tick              u64
	velocity                 [3]f32
	item_use_transaction     ?types.PackedItemUseLegacyInventoryTransaction
	item_stack_request       ?PerformItemStackRequestData
	player_block_actions     ?[]types_662.PlayerBlockActionData
	client_predicted_vehicle ?ClientPredictedVehicleData
	analog_move_vector       [2]f32
	camera_orientation       [3]f32
	raw_move_vector          [2]f32
}

pub fn (p &PlayerAuthInputPacket) pid() u16 { return 144 }

pub fn (p &PlayerAuthInputPacket) name() string { return 'PlayerAuthInputPacket' }

pub fn (p &PlayerAuthInputPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerAuthInputPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.player_rotation[0])
	w.le_f32(p.player_rotation[1])
	w.le_f32(p.player_position[0])
	w.le_f32(p.player_position[1])
	w.le_f32(p.player_position[2])
	w.le_f32(p.move_vector[0])
	w.le_f32(p.move_vector[1])
	w.le_f32(p.player_head_rotation)
	p.input_data.encode(mut w)
	p.input_mode.encode(mut w)
	p.play_mode.encode(mut w)
	p.new_interaction_model.encode(mut w)
	w.le_f32(p.interact_rotation[0])
	w.le_f32(p.interact_rotation[1])
	w.write_varuint64(p.client_tick)
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	if p.input_data.has(.perform_item_interaction) {
		tx := p.item_use_transaction or { types.PackedItemUseLegacyInventoryTransaction{} }
		tx.encode(mut w)
	}
	if p.input_data.has(.perform_item_stack_request) {
		request := p.item_stack_request or { PerformItemStackRequestData{} }
		request.encode(mut w)
	}
	if p.input_data.has(.perform_block_actions) {
		actions := p.player_block_actions or { []types_662.PlayerBlockActionData{} }
		w.write_varint32(i32(actions.len))
		for e in actions {
			e.encode(mut w)
		}
	}
	if p.input_data.has(.is_in_client_predicted_vehicle) {
		vehicle := p.client_predicted_vehicle or { ClientPredictedVehicleData{} }
		vehicle.encode(mut w)
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
	p.input_data = PlayerAuthInputData.decode(mut r)!
	p.input_mode = enums.InputMode.decode(mut r)!
	p.play_mode = ClientPlayMode.decode(mut r)!
	p.new_interaction_model = enums.NewInteractionModel.decode(mut r)!
	p.interact_rotation = [r.le_f32()!, r.le_f32()!]!
	p.client_tick = r.read_varuint64()!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	if p.input_data.has(.perform_item_interaction) {
		p.item_use_transaction = types.PackedItemUseLegacyInventoryTransaction.decode(mut r)!
	}
	if p.input_data.has(.perform_item_stack_request) {
		p.item_stack_request = PerformItemStackRequestData.decode(mut r)!
	}
	if p.input_data.has(.perform_block_actions) {
		count := int(r.read_varint32()!)
		mut actions := []types_662.PlayerBlockActionData{cap: count}
		for _ in 0 .. count {
			actions << types_662.PlayerBlockActionData.decode(mut r)!
		}
		p.player_block_actions = actions
	}
	if p.input_data.has(.is_in_client_predicted_vehicle) {
		p.client_predicted_vehicle = ClientPredictedVehicleData.decode(mut r)!
	}
	p.analog_move_vector = [r.le_f32()!, r.le_f32()!]!
	p.camera_orientation = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.raw_move_vector = [r.le_f32()!, r.le_f32()!]!
}
