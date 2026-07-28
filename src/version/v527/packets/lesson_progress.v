module packets

import protocol.serializer

pub enum LessonAction as i32 {
	start    = 0
	complete = 1
	restart  = 2
}

pub struct LessonProgressPacket {
pub mut:
	action      LessonAction
	score       i32
	activity_id string
}

pub fn (p &LessonProgressPacket) pid() u16 {
	return 183
}

pub fn (p &LessonProgressPacket) name() string {
	return 'LessonProgressPacket'
}

pub fn (p &LessonProgressPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LessonProgressPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.action))
	w.write_varint32(p.score)
	w.write_string(p.activity_id)
}

pub fn (mut p LessonProgressPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { LessonAction(r.read_varint32()!) }
	p.score = r.read_varint32()!
	p.activity_id = r.read_string()!
}
