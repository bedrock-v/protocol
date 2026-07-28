module packets

import protocol.serializer

pub struct HurtArmorPacket {
pub mut:
	cause       i32
	damage      i32
	armor_slots u64
}

pub fn (p &HurtArmorPacket) pid() u16 {
	return 38
}

pub fn (p &HurtArmorPacket) name() string {
	return 'HurtArmorPacket'
}

pub fn (p &HurtArmorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &HurtArmorPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.cause)
	w.write_varint32(p.damage)
	w.write_varuint64(p.armor_slots)
}

pub fn (mut p HurtArmorPacket) decode_payload(mut r serializer.Reader) ! {
	p.cause = r.read_varint32()!
	p.damage = r.read_varint32()!
	p.armor_slots = r.read_varuint64()!
}
