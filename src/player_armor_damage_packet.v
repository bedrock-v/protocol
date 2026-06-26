module src

import src.serializer

pub struct ArmorSlotAndDamagePair {
pub mut:
	slot   u8
	damage u16
}

pub struct PlayerArmorDamagePacket {
pub mut:
	pairs []ArmorSlotAndDamagePair
}

pub fn (p &PlayerArmorDamagePacket) pid() u16 {
	return player_armor_damage_packet
}

pub fn (p &PlayerArmorDamagePacket) name() string {
	return 'PlayerArmorDamagePacket'
}

pub fn (p &PlayerArmorDamagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerArmorDamagePacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.pairs = []ArmorSlotAndDamagePair{}
	for _ in 0 .. count {
		p.pairs << ArmorSlotAndDamagePair{
			slot:   r.u8()!
			damage: r.le_u16()!
		}
	}
}

pub fn (p &PlayerArmorDamagePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.pairs.len))
	for pair in p.pairs {
		w.u8(pair.slot)
		w.le_u16(pair.damage)
	}
}
