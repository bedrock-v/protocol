module protocol

import serializer
import types

pub const player_action_start_break = 0
pub const player_action_abort_break = 1
pub const player_action_crack_break = 18
pub const player_action_predict_destroy_block = 26
pub const player_action_continue_destroy_block = 27

pub const input_flag_perform_item_interaction = 34
pub const input_flag_perform_block_actions = 35
pub const input_flag_perform_item_stack_request = 36
pub const input_flag_client_predicted_vehicle = 45

pub struct PlayerBlockAction {
pub mut:
	action         int
	block_position types.BlockPosition
	face           int
}

pub struct PlayerAuthInputPacket {
pub mut:
	pitch                    f32
	yaw                      f32
	position                 types.Vector3
	move_vector              types.Vector2
	head_yaw                 f32
	input_data               []u8
	input_mode               u32
	play_mode                u32
	interaction_model        u32
	interact_pitch           f32
	interact_yaw             f32
	tick                     u64
	delta                    types.Vector3
	item_interaction_data    UseItemTransactionData
	item_stack_request       ItemStackRequestEntry
	block_actions            []PlayerBlockAction
	vehicle_rotation         types.Vector2
	client_predicted_vehicle i64
	analogue_move_vector     types.Vector2
	camera_orientation       types.Vector3
	raw_move_vector          types.Vector2
}

pub fn (p &PlayerAuthInputPacket) pid() u16 {
	return player_auth_input_packet
}

pub fn (p &PlayerAuthInputPacket) name() string {
	return 'PlayerAuthInputPacket'
}

pub fn (p &PlayerAuthInputPacket) can_be_sent_before_login() bool {
	return false
}

fn read_input_bitset(mut r serializer.Reader) ![]u8 {
	mut b := []u8{}
	for {
		x := r.u8()!
		b << x
		if x & 0x80 == 0 {
			break
		}
	}
	return b
}

fn write_input_bitset(mut w serializer.Writer, b []u8) {
	if b.len == 0 {
		w.u8(0)
		return
	}
	for x in b {
		w.u8(x)
	}
}

fn input_bitset_test(b []u8, n int) bool {
	idx := n / 7
	pos := u8(n % 7)
	if idx >= b.len {
		return false
	}
	return b[idx] & (u8(1) << pos) != 0
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.position = r.read_vector3()!
	p.move_vector = r.read_vector2()!
	p.head_yaw = r.le_f32()!
	p.input_data = read_input_bitset(mut r)!
	p.input_mode = r.read_varuint32()!
	p.play_mode = r.read_varuint32()!
	p.interaction_model = r.read_varuint32()!
	p.interact_pitch = r.le_f32()!
	p.interact_yaw = r.le_f32()!
	p.tick = r.read_varuint64()!
	p.delta = r.read_vector3()!

	if input_bitset_test(p.input_data, input_flag_perform_item_interaction) {
		p.item_interaction_data = read_use_item_transaction_data(mut r)!
	}
	if input_bitset_test(p.input_data, input_flag_perform_item_stack_request) {
		p.item_stack_request = read_item_stack_request_entry(mut r)!
	}
	if input_bitset_test(p.input_data, input_flag_perform_block_actions) {
		count := r.read_varint32()!
		p.block_actions = []PlayerBlockAction{}
		for _ in 0 .. count {
			mut a := PlayerBlockAction{
				action: r.read_varint32()!
			}
			match a.action {
				player_action_start_break, player_action_abort_break, player_action_crack_break,
				player_action_predict_destroy_block, player_action_continue_destroy_block {
					a.block_position = r.read_block_position()!
					a.face = r.read_varint32()!
				}
				else {}
			}
			p.block_actions << a
		}
	}
	if input_bitset_test(p.input_data, input_flag_client_predicted_vehicle) {
		p.vehicle_rotation = r.read_vector2()!
		p.client_predicted_vehicle = r.read_varint64()!
	}

	p.analogue_move_vector = r.read_vector2()!
	p.camera_orientation = r.read_vector3()!
	p.raw_move_vector = r.read_vector2()!
}

pub fn (p &PlayerAuthInputPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.write_vector3(p.position)
	w.write_vector2(p.move_vector)
	w.le_f32(p.head_yaw)
	write_input_bitset(mut w, p.input_data)
	w.write_varuint32(p.input_mode)
	w.write_varuint32(p.play_mode)
	w.write_varuint32(p.interaction_model)
	w.le_f32(p.interact_pitch)
	w.le_f32(p.interact_yaw)
	w.write_varuint64(p.tick)
	w.write_vector3(p.delta)

	if input_bitset_test(p.input_data, input_flag_perform_item_interaction) {
		write_use_item_transaction_data(mut w, p.item_interaction_data)
	}
	if input_bitset_test(p.input_data, input_flag_perform_item_stack_request) {
		write_item_stack_request_entry(mut w, p.item_stack_request)
	}
	if input_bitset_test(p.input_data, input_flag_perform_block_actions) {
		w.write_varint32(p.block_actions.len)
		for a in p.block_actions {
			w.write_varint32(a.action)
			match a.action {
				player_action_start_break, player_action_abort_break, player_action_crack_break,
				player_action_predict_destroy_block, player_action_continue_destroy_block {
					w.write_block_position(a.block_position)
					w.write_varint32(a.face)
				}
				else {}
			}
		}
	}
	if input_bitset_test(p.input_data, input_flag_client_predicted_vehicle) {
		w.write_vector2(p.vehicle_rotation)
		w.write_varint64(p.client_predicted_vehicle)
	}

	w.write_vector2(p.analogue_move_vector)
	w.write_vector3(p.camera_orientation)
	w.write_vector2(p.raw_move_vector)
}
