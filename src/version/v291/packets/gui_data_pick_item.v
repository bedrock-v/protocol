module packets

import protocol.serializer

pub struct GuiDataPickItemPacket {
pub mut:
	description  string
	item_effects string
	hotbar_slot  i32
}

pub fn (p &GuiDataPickItemPacket) pid() u16 {
	return 54
}

pub fn (p &GuiDataPickItemPacket) name() string {
	return 'GuiDataPickItemPacket'
}

pub fn (p &GuiDataPickItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &GuiDataPickItemPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.description)
	w.write_string(p.item_effects)
	w.le_i32(p.hotbar_slot)
}

pub fn (mut p GuiDataPickItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.description = r.read_string()!
	p.item_effects = r.read_string()!
	p.hotbar_slot = r.le_i32()!
}
