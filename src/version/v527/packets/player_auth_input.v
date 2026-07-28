module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v422.types as types_422
import protocol.version.v431.types as types_431

pub const input_flag_perform_item_interaction = u64(1) << 34
pub const input_flag_perform_block_actions = u64(1) << 35
pub const input_flag_perform_item_stack_request = u64(1) << 36

pub enum InputMode as u32 {
	undefined         = 0
	mouse             = 1
	touch             = 2
	gamepad           = 3
	motion_controller = 4
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
}

pub enum InputInteractionModel as u32 {
	touch     = 0
	crosshair = 1
	classic   = 2
}

pub struct LegacySetItemSlotData {
pub mut:
	container_id i8
	slots        []u8
}

pub fn (t LegacySetItemSlotData) encode(mut w serializer.Writer) {
	w.i8(t.container_id)
	w.write_string_bytes(t.slots)
}

pub fn LegacySetItemSlotData.decode(mut r serializer.Reader) !LegacySetItemSlotData {
	return LegacySetItemSlotData{
		container_id: r.i8()!
		slots:        r.read_string_bytes()!
	}
}

pub struct ItemUseTransaction {
pub mut:
	legacy_request_id i32
	legacy_slots      []LegacySetItemSlotData
	actions           []types_431.InventoryActionData
	action_type       u32
	block_position    types_291.BlockPosition
	block_face        i32
	hotbar_slot       i32
	item_in_hand      types_431.ItemData
	player_position   types_291.Vector3f
	click_position    types_291.Vector3f
	block_runtime_id  u32
}

pub fn (t ItemUseTransaction) encode(mut w serializer.Writer) {
	w.write_varint32(t.legacy_request_id)
	if t.legacy_request_id < -1 && t.legacy_request_id & 1 == 0 {
		w.write_varuint32(u32(t.legacy_slots.len))
		for slot in t.legacy_slots {
			slot.encode(mut w)
		}
	}
	w.write_varuint32(u32(t.actions.len))
	for action in t.actions {
		action.encode(mut w)
	}
	w.write_varuint32(t.action_type)
	t.block_position.encode(mut w)
	w.write_varint32(t.block_face)
	w.write_varint32(t.hotbar_slot)
	t.item_in_hand.encode(mut w)
	t.player_position.encode(mut w)
	t.click_position.encode(mut w)
	w.write_varuint32(t.block_runtime_id)
}

pub fn ItemUseTransaction.decode(mut r serializer.Reader) !ItemUseTransaction {
	mut t := ItemUseTransaction{}
	t.legacy_request_id = r.read_varint32()!
	if t.legacy_request_id < -1 && t.legacy_request_id & 1 == 0 {
		slot_count := int(r.read_varuint32()!)
		t.legacy_slots = []LegacySetItemSlotData{cap: slot_count}
		for _ in 0 .. slot_count {
			t.legacy_slots << LegacySetItemSlotData.decode(mut r)!
		}
	}
	action_count := int(r.read_varuint32()!)
	t.actions = []types_431.InventoryActionData{cap: action_count}
	for _ in 0 .. action_count {
		t.actions << types_431.InventoryActionData.decode(mut r)!
	}
	t.action_type = r.read_varuint32()!
	t.block_position = types_291.BlockPosition.decode(mut r)!
	t.block_face = r.read_varint32()!
	t.hotbar_slot = r.read_varint32()!
	t.item_in_hand = types_431.ItemData.decode(mut r)!
	t.player_position = types_291.Vector3f.decode(mut r)!
	t.click_position = types_291.Vector3f.decode(mut r)!
	t.block_runtime_id = r.read_varuint32()!
	return t
}

pub struct PlayerBlockActionData {
pub mut:
	action         PlayerActionType
	block_position types_291.Vector3i
	face           i32
}

pub fn (t PlayerBlockActionData) encode(mut w serializer.Writer) {
	w.write_varint32(i32(t.action))
	match t.action {
		.start_break, .abort_break, .continue_break, .block_predict_destroy,
		.block_continue_destroy {
			t.block_position.encode(mut w)
			w.write_varint32(t.face)
		}
		else {}
	}
}

pub fn PlayerBlockActionData.decode(mut r serializer.Reader) !PlayerBlockActionData {
	mut t := PlayerBlockActionData{}
	t.action = unsafe { PlayerActionType(r.read_varint32()!) }
	match t.action {
		.start_break, .abort_break, .continue_break, .block_predict_destroy,
		.block_continue_destroy {
			t.block_position = types_291.Vector3i.decode(mut r)!
			t.face = r.read_varint32()!
		}
		else {}
	}
	return t
}

pub struct PlayerAuthInputPacket {
pub mut:
	rotation                types_291.Vector3f
	position                types_291.Vector3f
	motion                  types_291.Vector2f
	input_data              u64
	input_mode              InputMode
	play_mode               ClientPlayMode
	input_interaction_model InputInteractionModel
	vr_gaze_direction       types_291.Vector3f
	tick                    u64
	delta                   types_291.Vector3f
	item_use_transaction    ItemUseTransaction
	item_stack_request      types_422.ItemStackRequest
	player_actions          []PlayerBlockActionData
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
	w.write_varuint32(u32(p.input_mode))
	w.write_varuint32(u32(p.play_mode))
	w.write_varuint32(u32(p.input_interaction_model))
	if p.play_mode == .reality {
		p.vr_gaze_direction.encode(mut w)
	}
	w.write_varuint64(p.tick)
	p.delta.encode(mut w)
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_transaction.encode(mut w)
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
	p.input_mode = unsafe { InputMode(r.read_varuint32()!) }
	p.play_mode = unsafe { ClientPlayMode(r.read_varuint32()!) }
	p.input_interaction_model = unsafe { InputInteractionModel(r.read_varuint32()!) }
	if p.play_mode == .reality {
		p.vr_gaze_direction = types_291.Vector3f.decode(mut r)!
	}
	p.tick = r.read_varuint64()!
	p.delta = types_291.Vector3f.decode(mut r)!
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_transaction = ItemUseTransaction.decode(mut r)!
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
