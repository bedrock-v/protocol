module src

import src.serializer

pub struct GuiDataPickItemPacket {
pub mut:
	item_description string
	item_effects     string
	hotbar_slot      int
}

pub fn (p &GuiDataPickItemPacket) pid() u16 {
	return gui_data_pick_item_packet
}

pub fn (p &GuiDataPickItemPacket) name() string {
	return 'GuiDataPickItemPacket'
}

pub fn (p &GuiDataPickItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p GuiDataPickItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_description = r.read_string()!
	p.item_effects = r.read_string()!
	p.hotbar_slot = int(r.le_i32()!)
}

pub fn (p &GuiDataPickItemPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.item_description)
	w.write_string(p.item_effects)
	w.le_i32(i32(p.hotbar_slot))
}
