module packets

import protocol.serializer
import protocol.version.v712.types
import protocol.version.v662.types as types_662
import protocol.version.v662.enums

pub const input_flag_perform_item_interaction = u64(1) << 34

pub const input_flag_perform_block_actions = u64(1) << 35

pub const input_flag_perform_item_stack_request = u64(1) << 36

pub const input_flag_is_in_client_predicted_vehicle = u64(1) << 45

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

pub struct ActionsEntry {
pub mut:
	action_type types.ItemStackRequestActionType = types.ItemStackActionTake{}
	amount      i8
	source      types.ItemStackRequestSlotInfo
	destination types.ItemStackRequestSlotInfo
}

pub fn (t ActionsEntry) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	w.i8(t.amount)
	t.source.encode(mut w)
	t.destination.encode(mut w)
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
	for a in t.actions {
		a.encode(mut w)
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
	input_data               u64
	input_mode               enums.InputMode
	play_mode                ClientPlayMode
	new_interaction_model    enums.NewInteractionModel
	vr_gaze_direction        ?[3]f32
	client_tick              u64
	velocity                 [3]f32
	item_use_transaction     ?types.PackedItemUseLegacyInventoryTransaction
	item_stack_request       ?PerformItemStackRequestData
	player_block_actions     ?[]types_662.PlayerBlockActionData
	client_predicted_vehicle ?ClientPredictedVehicleData
	analog_move_vector       [2]f32
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
	w.write_varuint64(p.input_data)
	p.input_mode.encode(mut w)
	p.play_mode.encode(mut w)
	p.new_interaction_model.encode(mut w)
	if p.play_mode == .reality {
		gaze := p.vr_gaze_direction or { [3]f32{} }
		w.le_f32(gaze[0])
		w.le_f32(gaze[1])
		w.le_f32(gaze[2])
	}
	w.write_varuint64(p.client_tick)
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	if p.input_data & input_flag_perform_item_interaction != 0 {
		tx := p.item_use_transaction or { types.PackedItemUseLegacyInventoryTransaction{} }
		tx.encode(mut w)
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		req := p.item_stack_request or { PerformItemStackRequestData{} }
		req.encode(mut w)
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		actions := p.player_block_actions or { [] }
		w.write_varuint32(u32(actions.len))
		for a in actions {
			a.encode(mut w)
		}
	}
	if p.input_data & input_flag_is_in_client_predicted_vehicle != 0 {
		vehicle := p.client_predicted_vehicle or { ClientPredictedVehicleData{} }
		vehicle.encode(mut w)
	}
	w.le_f32(p.analog_move_vector[0])
	w.le_f32(p.analog_move_vector[1])
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_rotation = [r.le_f32()!, r.le_f32()!]!
	p.player_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.move_vector = [r.le_f32()!, r.le_f32()!]!
	p.player_head_rotation = r.le_f32()!
	p.input_data = r.read_varuint64()!
	p.input_mode = enums.InputMode.decode(mut r)!
	p.play_mode = ClientPlayMode.decode(mut r)!
	p.new_interaction_model = enums.NewInteractionModel.decode(mut r)!
	if p.play_mode == .reality {
		p.vr_gaze_direction = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
	p.client_tick = r.read_varuint64()!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_transaction = types.PackedItemUseLegacyInventoryTransaction.decode(mut r)!
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		p.item_stack_request = PerformItemStackRequestData.decode(mut r)!
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		count := int(r.read_varuint32()!)
		mut actions := []types_662.PlayerBlockActionData{cap: count}
		for _ in 0 .. count {
			actions << types_662.PlayerBlockActionData.decode(mut r)!
		}
		p.player_block_actions = actions
	}
	if p.input_data & input_flag_is_in_client_predicted_vehicle != 0 {
		p.client_predicted_vehicle = ClientPredictedVehicleData.decode(mut r)!
	}
	p.analog_move_vector = [r.le_f32()!, r.le_f32()!]!
}
