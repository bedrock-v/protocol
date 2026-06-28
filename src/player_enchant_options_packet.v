module protocol

import serializer

pub struct Enchant {
pub mut:
	id    u32
	level u8
}

pub struct EnchantOption {
pub mut:
	cost            u32
	slot_flags      u32
	equip_enchants  []Enchant
	held_enchants   []Enchant
	self_enchants   []Enchant
	name            string
	option_id       u32
}

pub struct PlayerEnchantOptionsPacket {
pub mut:
	options []EnchantOption
}

pub fn (p &PlayerEnchantOptionsPacket) pid() u16 {
	return player_enchant_options_packet
}

pub fn (p &PlayerEnchantOptionsPacket) name() string {
	return 'PlayerEnchantOptionsPacket'
}

pub fn (p &PlayerEnchantOptionsPacket) can_be_sent_before_login() bool {
	return false
}

fn read_enchant_list(mut r serializer.Reader) ![]Enchant {
	count := r.read_varuint32()!
	mut list := []Enchant{}
	for _ in 0 .. count {
		list << Enchant{
			id:    r.read_varuint32()!
			level: r.u8()!
		}
	}
	return list
}

fn write_enchant_list(mut w serializer.Writer, list []Enchant) {
	w.write_varuint32(u32(list.len))
	for e in list {
		w.write_varuint32(e.id)
		w.u8(e.level)
	}
}

pub fn (mut p PlayerEnchantOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.options = []EnchantOption{}
	for _ in 0 .. count {
		mut opt := EnchantOption{
			cost:       u32(r.u8()!)
			slot_flags: r.le_u32()!
		}
		opt.equip_enchants = read_enchant_list(mut r)!
		opt.held_enchants = read_enchant_list(mut r)!
		opt.self_enchants = read_enchant_list(mut r)!
		opt.name = r.read_string()!
		opt.option_id = r.read_varuint32()!
		p.options << opt
	}
}

pub fn (p &PlayerEnchantOptionsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.options.len))
	for opt in p.options {
		w.u8(u8(opt.cost))
		w.le_u32(opt.slot_flags)
		write_enchant_list(mut w, opt.equip_enchants)
		write_enchant_list(mut w, opt.held_enchants)
		write_enchant_list(mut w, opt.self_enchants)
		w.write_string(opt.name)
		w.write_varuint32(opt.option_id)
	}
}
