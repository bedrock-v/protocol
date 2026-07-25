module packets

import serializer

pub struct HurtArmorPacket {
pub mut:
	health u8
}

pub fn (p &HurtArmorPacket) pid() u16 {
	return 0x22
}

pub fn (p &HurtArmorPacket) name() string {
	return 'HurtArmorPacket'
}

pub fn (p &HurtArmorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &HurtArmorPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.health)
}

pub fn (mut p HurtArmorPacket) decode_payload(mut r serializer.Reader) ! {
	p.health = r.u8()!
}
