module protocol

import serializer

pub struct CameraAimAssistActorPriorityData {
pub mut:
	preset_index   i32
	category_index i32
	actor_index    i32
	priority       i32
}

pub struct CameraAimAssistActorPriorityPacket {
pub mut:
	priority_data []CameraAimAssistActorPriorityData
}

pub fn (p &CameraAimAssistActorPriorityPacket) pid() u16 {
	return camera_aim_assist_actor_priority_packet
}

pub fn (p &CameraAimAssistActorPriorityPacket) name() string {
	return 'CameraAimAssistActorPriorityPacket'
}

pub fn (p &CameraAimAssistActorPriorityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CameraAimAssistActorPriorityPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.priority_data = []CameraAimAssistActorPriorityData{}
	for _ in 0 .. count {
		p.priority_data << CameraAimAssistActorPriorityData{
			preset_index:   r.le_i32()!
			category_index: r.le_i32()!
			actor_index:    r.le_i32()!
			priority:       r.le_i32()!
		}
	}
}

pub fn (p &CameraAimAssistActorPriorityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.priority_data.len))
	for d in p.priority_data {
		w.le_i32(d.preset_index)
		w.le_i32(d.category_index)
		w.le_i32(d.actor_index)
		w.le_i32(d.priority)
	}
}
