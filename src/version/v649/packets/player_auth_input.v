module packets

import serializer
import version.v291.types as types_291
import version.v554.types as types_554
import version.v649.types
import version.v649.enums

pub struct PlayerAuthInputPacket {
pub mut:
	rotation                types_291.Vector3f
	position                types_291.Vector3f
	motion                  types_291.Vector2f
	input_data              u64
	input_mode              enums.InputMode
	play_mode               enums.ClientPlayMode
	input_interaction_model enums.InputInteractionModel
	vr_gaze_direction       types_291.Vector3f
	tick                    u64
	delta                   types_291.Vector3f
	item_use_transaction    types.ItemUseTransaction
	item_stack_request      types_554.ItemStackRequest
	player_actions          []types.PlayerBlockActionData
	predicted_vehicle       i64
	analog_move_vector      types_291.Vector2f
}

fn has_input_flag(flags u64, flag enums.PlayerAuthInputData) bool {
	return flags & (u64(1) << int(flag)) != 0
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
	w.le_f32(p.rotation.x)
	w.le_f32(p.rotation.y)
	p.position.encode(mut w)
	w.le_f32(p.motion.x)
	w.le_f32(p.motion.y)
	w.le_f32(p.rotation.z)
	w.write_varuint64(p.input_data)
	p.input_mode.encode(mut w)
	p.play_mode.encode(mut w)
	p.input_interaction_model.encode(mut w)
	if p.play_mode == .reality {
		p.vr_gaze_direction.encode(mut w)
	}
	w.write_varuint64(p.tick)
	p.delta.encode(mut w)
	if has_input_flag(p.input_data, .perform_item_interaction) {
		p.item_use_transaction.encode(mut w)
	}
	if has_input_flag(p.input_data, .perform_item_stack_request) {
		p.item_stack_request.encode(mut w)
	}
	if has_input_flag(p.input_data, .perform_block_actions) {
		w.write_varint32(i32(p.player_actions.len))
		for action in p.player_actions {
			action.encode(mut w)
		}
	}
	if has_input_flag(p.input_data, .in_client_predicted_in_vehicle) {
		w.write_varint64(p.predicted_vehicle)
	}
	p.analog_move_vector.encode(mut w)
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	rotation_x := r.le_f32()!
	rotation_y := r.le_f32()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector2f.decode(mut r)!
	rotation_z := r.le_f32()!
	p.rotation = types_291.Vector3f{
		x: rotation_x
		y: rotation_y
		z: rotation_z
	}
	p.input_data = r.read_varuint64()!
	p.input_mode = enums.InputMode.decode(mut r)!
	p.play_mode = enums.ClientPlayMode.decode(mut r)!
	p.input_interaction_model = enums.InputInteractionModel.decode(mut r)!
	if p.play_mode == .reality {
		p.vr_gaze_direction = types_291.Vector3f.decode(mut r)!
	}
	p.tick = r.read_varuint64()!
	p.delta = types_291.Vector3f.decode(mut r)!
	if has_input_flag(p.input_data, .perform_item_interaction) {
		p.item_use_transaction = types.ItemUseTransaction.decode(mut r)!
	}
	if has_input_flag(p.input_data, .perform_item_stack_request) {
		p.item_stack_request = types_554.ItemStackRequest.decode(mut r)!
	}
	if has_input_flag(p.input_data, .perform_block_actions) {
		action_count := int(r.read_varint32()!)
		p.player_actions = []types.PlayerBlockActionData{cap: action_count}
		for _ in 0 .. action_count {
			p.player_actions << types.PlayerBlockActionData.decode(mut r)!
		}
	}
	if has_input_flag(p.input_data, .in_client_predicted_in_vehicle) {
		p.predicted_vehicle = r.read_varint64()!
	}
	p.analog_move_vector = types_291.Vector2f.decode(mut r)!
}
