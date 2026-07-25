module types

import serializer

pub struct CameraAimAssistPriority {
pub mut:
	name     string
	priority i32
}

pub fn (t CameraAimAssistPriority) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_i32(t.priority)
}

pub fn CameraAimAssistPriority.decode(mut r serializer.Reader) !CameraAimAssistPriority {
	return CameraAimAssistPriority{
		name:     r.read_string()!
		priority: r.le_i32()!
	}
}
