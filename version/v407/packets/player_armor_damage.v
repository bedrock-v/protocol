module packets

import protocol.serializer

pub const armor_damage_flag_helmet = u8(0x01)
pub const armor_damage_flag_chestplate = u8(0x02)
pub const armor_damage_flag_leggings = u8(0x04)
pub const armor_damage_flag_boots = u8(0x08)

pub struct PlayerArmorDamagePacket {
pub mut:
	flags             u8
	helmet_damage     i32
	chestplate_damage i32
	leggings_damage   i32
	boots_damage      i32
}

pub fn (p &PlayerArmorDamagePacket) pid() u16 {
	return 149
}

pub fn (p &PlayerArmorDamagePacket) name() string {
	return 'PlayerArmorDamagePacket'
}

pub fn (p &PlayerArmorDamagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerArmorDamagePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.flags)
	if p.flags & armor_damage_flag_helmet != 0 {
		w.write_varint32(p.helmet_damage)
	}
	if p.flags & armor_damage_flag_chestplate != 0 {
		w.write_varint32(p.chestplate_damage)
	}
	if p.flags & armor_damage_flag_leggings != 0 {
		w.write_varint32(p.leggings_damage)
	}
	if p.flags & armor_damage_flag_boots != 0 {
		w.write_varint32(p.boots_damage)
	}
}

pub fn (mut p PlayerArmorDamagePacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.u8()!
	if p.flags & armor_damage_flag_helmet != 0 {
		p.helmet_damage = r.read_varint32()!
	}
	if p.flags & armor_damage_flag_chestplate != 0 {
		p.chestplate_damage = r.read_varint32()!
	}
	if p.flags & armor_damage_flag_leggings != 0 {
		p.leggings_damage = r.read_varint32()!
	}
	if p.flags & armor_damage_flag_boots != 0 {
		p.boots_damage = r.read_varint32()!
	}
}
