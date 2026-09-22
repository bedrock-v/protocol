module packets

import protocol.serializer

pub struct GuiDataPickItemPacket {
pub mut:
	item_name        string
	item_effect_name string
	slot             i32
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
	w.write_string(p.item_name)
	w.write_string(p.item_effect_name)
	w.le_i32(p.slot)
}

pub fn (mut p GuiDataPickItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_name = r.read_string()!
	p.item_effect_name = r.read_string()!
	p.slot = r.le_i32()!
}
