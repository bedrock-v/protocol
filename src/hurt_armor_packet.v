module src

import src.serializer

pub struct HurtArmorPacket {
pub mut:
	cause            int
	health           int
	armor_slot_flags u64
}

pub fn (p &HurtArmorPacket) pid() u16 {
	return hurt_armor_packet
}

pub fn (p &HurtArmorPacket) name() string {
	return 'HurtArmorPacket'
}

pub fn (p &HurtArmorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p HurtArmorPacket) decode_payload(mut r serializer.Reader) ! {
	p.cause = int(r.read_varint32()!)
	p.health = int(r.read_varint32()!)
	p.armor_slot_flags = r.read_varuint64()!
}

pub fn (p &HurtArmorPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.cause))
	w.write_varint32(i32(p.health))
	w.write_varuint64(p.armor_slot_flags)
}
