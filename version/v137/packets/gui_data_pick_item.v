module packets

import protocol.serializer

pub struct GuiDataPickItemPacket {
pub mut:
	hotbar_slot i32
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
	w.le_i32(p.hotbar_slot)
}

pub fn (mut p GuiDataPickItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.hotbar_slot = r.le_i32()!
}
