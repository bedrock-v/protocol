module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v575.types as types_575
import protocol.version.v431.types as types_431
import protocol.version.v554.types as types_554

pub const input_flag_perform_item_interaction = u64(1) << 34

pub const input_flag_perform_block_actions = u64(1) << 35

pub const input_flag_perform_item_stack_request = u64(1) << 36

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

pub fn (e ClientPlayMode) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ClientPlayMode.decode(mut r serializer.Reader) !ClientPlayMode {
	return unsafe { ClientPlayMode(r.read_varuint32()!) }
}

pub struct PlayerAuthInputPacket {
pub mut:
	rotation                types_291.Vector3f
	position                types_291.Vector3f
	motion                  types_291.Vector2f
	input_data              u64
	input_mode              u32
	play_mode               ClientPlayMode
	input_interaction_model u32
	vr_gaze_direction       types_291.Vector3f
	tick                    u64
	delta                   types_291.Vector3f
	item_use_transaction    ?types_431.ItemUseTransaction
	item_stack_request      ?types_554.ItemStackRequest
	player_actions          []types_575.PlayerBlockActionData
	analog_move_vector      types_291.Vector2f
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
	w.write_varuint32(p.input_mode)
	p.play_mode.encode(mut w)
	w.write_varuint32(p.input_interaction_model)
	if p.play_mode == .reality {
		p.vr_gaze_direction.encode(mut w)
	}
	w.write_varuint64(p.tick)
	p.delta.encode(mut w)
	if p.input_data & input_flag_perform_item_interaction != 0 {
		transaction := p.item_use_transaction or { types_431.ItemUseTransaction{} }
		transaction.encode(mut w)
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		request := p.item_stack_request or { types_554.ItemStackRequest{} }
		request.encode(mut w)
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		w.write_varint32(i32(p.player_actions.len))
		for action in p.player_actions {
			action.encode(mut w)
		}
	}
	w.le_f32(p.analog_move_vector.x)
	w.le_f32(p.analog_move_vector.y)
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
	p.play_mode = ClientPlayMode.decode(mut r)!
	p.input_interaction_model = r.read_varuint32()!
	if p.play_mode == .reality {
		p.vr_gaze_direction = types_291.Vector3f.decode(mut r)!
	}
	p.tick = r.read_varuint64()!
	p.delta = types_291.Vector3f.decode(mut r)!
	if p.input_data & input_flag_perform_item_interaction != 0 {
		p.item_use_transaction = types_431.ItemUseTransaction.decode(mut r)!
	}
	if p.input_data & input_flag_perform_item_stack_request != 0 {
		p.item_stack_request = types_554.ItemStackRequest.decode(mut r)!
	}
	if p.input_data & input_flag_perform_block_actions != 0 {
		count := int(r.read_varint32()!)
		p.player_actions = []types_575.PlayerBlockActionData{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.player_actions << types_575.PlayerBlockActionData.decode(mut r)!
		}
	}
	p.analog_move_vector = types_291.Vector2f.decode(mut r)!
}
