module protocol

import serializer

pub struct LessonProgressPacket {
pub mut:
	action      int
	score       int
	activity_id string
}

pub fn (p &LessonProgressPacket) pid() u16 {
	return lesson_progress_packet
}

pub fn (p &LessonProgressPacket) name() string {
	return 'LessonProgressPacket'
}

pub fn (p &LessonProgressPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LessonProgressPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = int(r.read_varint32()!)
	p.score = int(r.read_varint32()!)
	p.activity_id = r.read_string()!
}

pub fn (p &LessonProgressPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.action))
	w.write_varint32(i32(p.score))
	w.write_string(p.activity_id)
}
