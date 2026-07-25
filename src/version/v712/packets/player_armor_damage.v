module packets

import serializer

pub struct PlayerArmorDamagePacket {
pub mut:
	slot_bitset i8
	damage      [5]i32
}

pub fn (p &PlayerArmorDamagePacket) pid() u16 { return 149 }

pub fn (p &PlayerArmorDamagePacket) name() string { return 'PlayerArmorDamagePacket' }

pub fn (p &PlayerArmorDamagePacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerArmorDamagePacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.slot_bitset)
	for i in 0 .. 5 {
		if int(p.slot_bitset) & (1 << i) != 0 {
			w.write_varint32(p.damage[i])
		}
	}
}

pub fn (mut p PlayerArmorDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.slot_bitset = r.i8()!
	for i in 0 .. 5 {
		if int(p.slot_bitset) & (1 << i) != 0 {
			p.damage[i] = r.read_varint32()!
		}
	}
}
