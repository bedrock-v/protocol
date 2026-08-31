module packets

import protocol.serializer
import protocol.version.v291.types

pub struct PlaySoundPacket {
pub mut:
	sound    string
	position types.Vector3f
	volume   f32
	pitch    f32
}

pub fn (p &PlaySoundPacket) pid() u16 {
	return 86
}

pub fn (p &PlaySoundPacket) name() string {
	return 'PlaySoundPacket'
}

pub fn (p &PlaySoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlaySoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound)
	block_position := types.BlockPosition{
		x: i32(p.position.x * 8)
		y: u32(i32(p.position.y * 8))
		z: i32(p.position.z * 8)
	}
	block_position.encode(mut w)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound = r.read_string()!
	block_position := types.BlockPosition.decode(mut r)!
	p.position = types.Vector3f{
		x: f32(block_position.x) / 8
		y: f32(i32(block_position.y)) / 8
		z: f32(block_position.z) / 8
	}
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
}
