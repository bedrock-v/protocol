module packets

import protocol.serializer
import protocol.version.v662.enums as enums_662
import protocol.version.v662.types as types_662
import protocol.version.v944.types as types_944
import protocol.version.v1001.types

pub const input_flag_perform_item_interaction = u64(1) << 34
pub const input_flag_perform_block_actions = u64(1) << 35
pub const input_flag_perform_item_stack_request = u64(1) << 36
pub const input_flag_is_in_client_predicted_vehicle = u64(1) << 45

pub struct PlayerAuthInputPacket {
pub mut:
	player_rotation          [2]f32
	player_position          [3]f32
	move_vector              [2]f32
	player_head_rotation     f32
	input_data               u64
	input_data_high          u64
	input_mode               enums_662.InputMode
	play_mode                ClientPlayMode
	new_interaction_model    enums_662.NewInteractionModel
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

pub fn (p &PlayerAuthInputPacket) pid() u16 {
	return 144
}

pub fn (p &PlayerAuthInputPacket) name() string {
	return 'PlayerAuthInputPacket'
}

pub fn (p &PlayerAuthInputPacket) can_be_sent_before_login() bool {
	return false
}

fn write_varuint128(mut w serializer.Writer, lo u64, hi u64) {
	mut l := lo
	mut h := hi
	for {
		b := u8(l & 0x7f)
		l = (l >> 7) | (h << 57)
		h = h >> 7
		if l == 0 && h == 0 {
			w.u8(b)
			return
		}
		w.u8(b | 0x80)
	}
}

fn read_varuint128(mut r serializer.Reader) !(u64, u64) {
	mut lo := u64(0)
	mut hi := u64(0)
	mut shift := u32(0)
	for {
		b := r.u8()!
		v := u64(b & 0x7f)
		if shift < 64 {
			lo |= v << shift
			if shift > 57 {
				hi |= v >> (64 - shift)
			}
		} else {
			hi |= v << (shift - 64)
		}
		if b & 0x80 == 0 {
			break
		}
		shift += 7
		if shift >= 128 {
			return error('varuint128 too long')
		}
	}
	return lo, hi
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
	write_varuint128(mut w, p.input_data, p.input_data_high)
	p.input_mode.encode(mut w)
	p.play_mode.encode(mut w)
	p.new_interaction_model.encode(mut w)
	w.le_f32(p.interact_rotation[0])
	w.le_f32(p.interact_rotation[1])
	w.write_varuint64(p.client_tick)
	w.le_f32(p.velocity[0])
	w.le_f32(p.velocity[1])
	w.le_f32(p.velocity[2])
	if p.input_data & input_flag_perform_item_interaction != 0 {
		if v := p.item_use_transaction {
			v.encode(mut w)
		}
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		if v := p.item_stack_request {
			v.encode(mut w)
		}
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		if v := p.player_block_actions {
			w.write_varint32(i32(v.len))
			for e in v {
				e.encode(mut w)
			}
		}
	}
	if p.input_data & input_flag_is_in_client_predicted_vehicle != 0 {
		if v := p.client_predicted_vehicle {
			v.encode(mut w)
		}
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
	p.input_data, p.input_data_high = read_varuint128(mut r)!
	p.input_mode = enums_662.InputMode.decode(mut r)!
	p.play_mode = ClientPlayMode.decode(mut r)!
	p.new_interaction_model = enums_662.NewInteractionModel.decode(mut r)!
	p.interact_rotation = [r.le_f32()!, r.le_f32()!]!
	p.client_tick = r.read_varuint64()!
	p.velocity = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_transaction = types.PackedItemUseLegacyInventoryTransaction.decode(mut r)!
	} else {
		p.item_use_transaction = none
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		p.item_stack_request = PerformItemStackRequestData.decode(mut r)!
	} else {
		p.item_stack_request = none
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		count := int(r.read_varint32()!)
		mut actions := []types_662.PlayerBlockActionData{cap: count}
		for _ in 0 .. count {
			actions << types_662.PlayerBlockActionData.decode(mut r)!
		}
		p.player_block_actions = actions
	} else {
		p.player_block_actions = none
	}
	if p.input_data & input_flag_is_in_client_predicted_vehicle != 0 {
		p.client_predicted_vehicle = ClientPredictedVehicleData.decode(mut r)!
	} else {
		p.client_predicted_vehicle = none
	}
	p.analog_move_vector = [r.le_f32()!, r.le_f32()!]!
	p.camera_orientation = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.raw_move_vector = [r.le_f32()!, r.le_f32()!]!
}

pub struct PerformItemStackRequestData {
pub mut:
	client_request_id        i32
	actions                  []types_944.ItemStackRequestActionType
	strings_to_filter        []string
	strings_to_filter_origin enums_662.TextProcessingEventOrigin
}

pub fn (t PerformItemStackRequestData) encode(mut w serializer.Writer) {
	w.write_varint32(t.client_request_id)
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
	t.client_request_id = r.read_varint32()!
	{
		count := int(r.read_varuint32()!)
		t.actions = []types_944.ItemStackRequestActionType{cap: count}
		for _ in 0 .. count {
			t.actions << types_944.ItemStackRequestActionType.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		t.strings_to_filter = []string{cap: count}
		for _ in 0 .. count {
			t.strings_to_filter << r.read_string()!
		}
	}
	t.strings_to_filter_origin = enums_662.TextProcessingEventOrigin.decode(mut r)!
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
