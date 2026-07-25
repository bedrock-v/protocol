module packets

import serializer

pub enum SimpleEventType as u16 {
	@none                          = 0
	enable_commands                = 1
	disable_commands               = 2
	unlock_world_template_settings = 3
}

pub struct SimpleEventPacket {
pub mut:
	event SimpleEventType
}

pub fn (p &SimpleEventPacket) pid() u16 {
	return 64
}

pub fn (p &SimpleEventPacket) name() string {
	return 'SimpleEventPacket'
}

pub fn (p &SimpleEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SimpleEventPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(u16(p.event))
}

pub fn (mut p SimpleEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event = unsafe { SimpleEventType(r.le_u16()!) }
}
