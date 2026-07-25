module packets

import serializer
import version.v291.types as types_291

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

pub struct PlayerAuthInputPacket {
pub mut:
	rotation          types_291.Vector3f
	position          types_291.Vector3f
	motion            types_291.Vector2f
	input_data        u64
	input_mode        InputMode
	play_mode         ClientPlayMode
	vr_gaze_direction types_291.Vector3f
	tick              u64
	delta             types_291.Vector3f
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
	w.write_varuint32(u32(p.input_mode))
	w.write_varuint32(u32(p.play_mode))
	if p.play_mode == .reality {
		p.vr_gaze_direction.encode(mut w)
	}
	w.write_varuint64(p.tick)
	p.delta.encode(mut w)
}

pub fn (mut p PlayerAuthInputPacket) decode_payload(mut r serializer.Reader) ! {
	p.rotation.x = r.le_f32()!
	p.rotation.y = r.le_f32()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.motion = types_291.Vector2f.decode(mut r)!
	p.rotation.z = r.le_f32()!
	p.input_data = r.read_varuint64()!
	p.input_mode = unsafe { InputMode(r.read_varuint32()!) }
	p.play_mode = unsafe { ClientPlayMode(r.read_varuint32()!) }
	if p.play_mode == .reality {
		p.vr_gaze_direction = types_291.Vector3f.decode(mut r)!
	}
	p.tick = r.read_varuint64()!
	p.delta = types_291.Vector3f.decode(mut r)!
}
