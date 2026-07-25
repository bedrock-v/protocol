module packets

import serializer

pub struct EnchantData {
pub mut:
	enchant_type u8
	level        u8
}

pub fn (t EnchantData) encode(mut w serializer.Writer) {
	w.u8(t.enchant_type)
	w.u8(t.level)
}

pub fn EnchantData.decode(mut r serializer.Reader) !EnchantData {
	return EnchantData{
		enchant_type: r.u8()!
		level:        r.u8()!
	}
}

pub struct EnchantOptionData {
pub mut:
	cost           u32
	primary_slot   i32
	enchants0      []EnchantData
	enchants1      []EnchantData
	enchants2      []EnchantData
	enchant_name   string
	enchant_net_id u32
}

fn write_enchants(mut w serializer.Writer, enchants []EnchantData) {
	w.write_varuint32(u32(enchants.len))
	for enchant in enchants {
		enchant.encode(mut w)
	}
}

fn read_enchants(mut r serializer.Reader) ![]EnchantData {
	count := int(r.read_varuint32()!)
	mut enchants := []EnchantData{cap: count}
	for _ in 0 .. count {
		enchants << EnchantData.decode(mut r)!
	}
	return enchants
}

pub fn (t EnchantOptionData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.cost)
	w.le_i32(t.primary_slot)
	write_enchants(mut w, t.enchants0)
	write_enchants(mut w, t.enchants1)
	write_enchants(mut w, t.enchants2)
	w.write_string(t.enchant_name)
	w.write_varuint32(t.enchant_net_id)
}

pub fn EnchantOptionData.decode(mut r serializer.Reader) !EnchantOptionData {
	return EnchantOptionData{
		cost:           r.read_varuint32()!
		primary_slot:   r.le_i32()!
		enchants0:      read_enchants(mut r)!
		enchants1:      read_enchants(mut r)!
		enchants2:      read_enchants(mut r)!
		enchant_name:   r.read_string()!
		enchant_net_id: r.read_varuint32()!
	}
}

pub struct PlayerEnchantOptionsPacket {
pub mut:
	options []EnchantOptionData
}

pub fn (p &PlayerEnchantOptionsPacket) pid() u16 {
	return 146
}

pub fn (p &PlayerEnchantOptionsPacket) name() string {
	return 'PlayerEnchantOptionsPacket'
}

pub fn (p &PlayerEnchantOptionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerEnchantOptionsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.options.len))
	for option in p.options {
		option.encode(mut w)
	}
}

pub fn (mut p PlayerEnchantOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.options = []EnchantOptionData{cap: count}
	for _ in 0 .. count {
		p.options << EnchantOptionData.decode(mut r)!
	}
}
