module enums

import serializer

pub enum HudElement as u32 {
	paper_doll     = 0
	armor          = 1
	tool_tips      = 2
	touch_controls = 3
	crosshair      = 4
	hot_bar        = 5
	health         = 6
	progress_bar   = 7
	hunger         = 8
	air_bubbles    = 9
	horse_health   = 10
	status_effects = 11
	item_text      = 12
	count          = 13
}

pub fn (e HudElement) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn HudElement.decode(mut r serializer.Reader) !HudElement {
	return unsafe { HudElement(r.read_varuint32()!) }
}
