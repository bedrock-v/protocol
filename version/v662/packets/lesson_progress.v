module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct LessonProgressPacket {
pub mut:
	lesson_action enums.LessonAction
	score         i32
	activity_id   string
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
	p.lesson_action.encode(mut w)
	w.write_varint32(p.score)
	w.write_string(p.activity_id)
}

pub fn (mut p LessonProgressPacket) decode_payload(mut r serializer.Reader) ! {
	p.lesson_action = enums.LessonAction.decode(mut r)!
	p.score = r.read_varint32()!
	p.activity_id = r.read_string()!
}
