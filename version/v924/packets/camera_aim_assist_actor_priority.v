module packets

import protocol.serializer

pub struct CameraAimAssistActorPriorityData {
pub mut:
	preset_index   i32
	category_index i32
	actor_index    i32
	priority_value i32
}

pub fn (e CameraAimAssistActorPriorityData) encode(mut w serializer.Writer) {
	w.le_i32(e.preset_index)
	w.le_i32(e.category_index)
	w.le_i32(e.actor_index)
	w.le_i32(e.priority_value)
}

pub fn CameraAimAssistActorPriorityData.decode(mut r serializer.Reader) !CameraAimAssistActorPriorityData {
	return CameraAimAssistActorPriorityData{
		preset_index:   r.le_i32()!
		category_index: r.le_i32()!
		actor_index:    r.le_i32()!
		priority_value: r.le_i32()!
	}
}

pub struct CameraAimAssistActorPriorityPacket {
pub mut:
	priority_data []CameraAimAssistActorPriorityData
}

pub fn (p &CameraAimAssistActorPriorityPacket) pid() u16 {
	return 339
}

pub fn (p &CameraAimAssistActorPriorityPacket) name() string {
	return 'CameraAimAssistActorPriorityPacket'
}

pub fn (p &CameraAimAssistActorPriorityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraAimAssistActorPriorityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.priority_data.len))
	for d in p.priority_data {
		d.encode(mut w)
	}
}

pub fn (mut p CameraAimAssistActorPriorityPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.priority_data = []CameraAimAssistActorPriorityData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.priority_data << CameraAimAssistActorPriorityData.decode(mut r)!
	}
}
