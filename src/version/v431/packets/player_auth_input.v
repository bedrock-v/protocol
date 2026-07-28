module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v422.types as types_422
import protocol.version.v431.types

const input_flag_perform_item_interaction = u64(1) << 34
const input_flag_perform_block_actions = u64(1) << 35
const input_flag_perform_item_stack_request = u64(1) << 36
const play_mode_reality = u32(4)

pub struct PlayerBlockActionData {
pub mut:
	action         i32
	block_position types_291.Vector3i
	face           i32
}

fn action_has_block_data(action i32) bool {
	return action in [i32(0), 1, 18, 26, 27]
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	w.write_varint32(t.action)
	if action_has_block_data(t.action) {
		t.block_position.encode(mut w)
		w.write_varint32(t.face)
	}
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	mut t := PlayerBlockActionData{}
	t.action = r.read_varint32()!
	if action_has_block_data(t.action) {
		t.block_position = types_291.Vector3i.decode(mut r)!
		t.face = r.read_varint32()!
	}
	return t
}

pub struct PlayerAuthInputPacket {
pub mut:
	rotation                   types_291.Vector3f
	position                   types_291.Vector3f
	motion                     types_291.Vector2f
	input_data                 u64
	input_mode                 u32
	play_mode                  u32
	vr_gaze_direction          types_291.Vector3f
	tick                       u64
	delta                      types_291.Vector3f
	item_use_legacy_request_id i32
	item_use_legacy_slots      []LegacySetItemSlotData
	item_use_actions           []types.InventoryActionData
	item_use                   types.ItemUseTransaction
	item_use_block_runtime_id  u32
	item_stack_request         types_422.ItemStackRequest
	player_actions             []PlayerBlockActionData
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
	p.motion.encode(mut w)
	w.le_f32(p.rotation.z)
	w.write_varuint64(p.input_data)
	w.write_varuint32(p.input_mode)
	w.write_varuint32(p.play_mode)
	if p.play_mode == play_mode_reality {
		p.vr_gaze_direction.encode(mut w)
	}
	w.write_varuint64(p.tick)
	p.delta.encode(mut w)
	if p.input_data & input_flag_perform_item_interaction != 0 {
		w.write_varint32(p.item_use_legacy_request_id)
		if p.item_use_legacy_request_id < -1 && (p.item_use_legacy_request_id & 1) == 0 {
			w.write_varuint32(u32(p.item_use_legacy_slots.len))
			for slot in p.item_use_legacy_slots {
				slot.encode(mut w)
			}
		}
		types.write_inventory_actions(mut w, p.item_use_actions)
		p.item_use.encode(mut w)
		w.write_varuint32(p.item_use_block_runtime_id)
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		p.item_stack_request.encode(mut w)
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		w.write_varint32(i32(p.player_actions.len))
		for action in p.player_actions {
			action.encode(mut w)
		}
	}
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	pitch := r.le_f32()!
	yaw := r.le_f32()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector2f.decode(mut r)!
	head_yaw := r.le_f32()!
	p.rotation = types_291.Vector3f{
		x: pitch
		y: yaw
		z: head_yaw
	}
	p.input_data = r.read_varuint64()!
	p.input_mode = r.read_varuint32()!
	p.play_mode = r.read_varuint32()!
	if p.play_mode == play_mode_reality {
		p.vr_gaze_direction = types_291.Vector3f.decode(mut r)!
	}
	p.tick = r.read_varuint64()!
	p.delta = types_291.Vector3f.decode(mut r)!
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_legacy_request_id = r.read_varint32()!
		if p.item_use_legacy_request_id < -1 && (p.item_use_legacy_request_id & 1) == 0 {
			slot_count := int(r.read_varuint32()!)
			p.item_use_legacy_slots = []LegacySetItemSlotData{cap: slot_count}
			for _ in 0 .. slot_count {
				p.item_use_legacy_slots << LegacySetItemSlotData.decode(mut r)!
			}
		}
		p.item_use_actions = types.read_inventory_actions(mut r)!
		p.item_use = types.ItemUseTransaction.decode(mut r)!
		p.item_use_block_runtime_id = r.read_varuint32()!
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		p.item_stack_request = types_422.ItemStackRequest.decode(mut r)!
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		action_count := int(r.read_varint32()!)
		p.player_actions = []PlayerBlockActionData{cap: action_count}
		for _ in 0 .. action_count {
			p.player_actions << PlayerBlockActionData.decode(mut r)!
		}
	}
}
