module types

import serializer

pub struct CameraAimAssistItemSettings {
pub mut:
	item_id  string
	category string
}

pub fn (t CameraAimAssistItemSettings) encode(mut w serializer.Writer) {
	w.write_string(t.item_id)
	w.write_string(t.category)
}

pub fn CameraAimAssistItemSettings.decode(mut r serializer.Reader) !CameraAimAssistItemSettings {
	return CameraAimAssistItemSettings{
		item_id:  r.read_string()!
		category: r.read_string()!
	}
}
