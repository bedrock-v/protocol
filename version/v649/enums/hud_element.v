module enums

import protocol.serializer

pub enum HudElement as u32 {
	paper_doll      = 0
	armor           = 1
	tool_tips       = 2
	touch_controls  = 3
	crosshair       = 4
	hotbar          = 5
	health          = 6
	progress_bar    = 7
	food_bar        = 8
	air_bubbles_bar = 9
	vehicle_health  = 10
	effects_bar     = 11
	item_text_popup = 12
}

pub fn (e HudElement) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn HudElement.decode(mut r serializer.Reader) !HudElement {
	return unsafe { HudElement(r.read_varuint32()!) }
}
