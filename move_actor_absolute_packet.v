module protocol


pub const move_actor_flag_on_ground = int(1)

pub struct MoveActorAbsolutePacket {
pub mut:
	actor_runtime_id u64
	flags            int
	position         Vector3
	pitch            f32
	yaw              f32
	head_yaw         f32
}

pub fn (p &MoveActorAbsolutePacket) pid() u16 {
	return move_actor_absolute_packet
}

pub fn (p &MoveActorAbsolutePacket) name() string {
	return 'MoveActorAbsolutePacket'
}

pub fn (p &MoveActorAbsolutePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MoveActorAbsolutePacket) decode_payload(mut r Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.flags = int(r.u8()!)
	p.position = r.read_vector3()!
	p.pitch = r.read_rotation_byte()!
	p.yaw = r.read_rotation_byte()!
	p.head_yaw = r.read_rotation_byte()!
}

pub fn (p &MoveActorAbsolutePacket) encode_payload(mut w Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.u8(u8(p.flags))
	w.write_vector3(p.position)
	w.write_rotation_byte(p.pitch)
	w.write_rotation_byte(p.yaw)
	w.write_rotation_byte(p.head_yaw)
}
