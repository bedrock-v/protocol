module enums

import serializer

pub enum LessonAction as i32 {
	start    = 0
	complete = 1
	restart  = 2
}

pub fn (e LessonAction) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn LessonAction.decode(mut r serializer.Reader) !LessonAction {
	return unsafe { LessonAction(r.read_varint32()!) }
}
