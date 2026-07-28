module packets

import protocol.serializer
import protocol.version.v662.types

pub struct OptionsEntry {
pub mut:
	cost           u32
	enchants       types.ItemEnchants
	enchant_name   string
	enchant_net_id u32
}

pub fn (e OptionsEntry) encode(mut w serializer.Writer) {
	w.write_varuint32(e.cost)
	e.enchants.encode(mut w)
	w.write_string(e.enchant_name)
	w.write_varuint32(e.enchant_net_id)
}

pub fn OptionsEntry.decode(mut r serializer.Reader) !OptionsEntry {
	return OptionsEntry{
		cost:           r.read_varuint32()!
		enchants:       types.ItemEnchants.decode(mut r)!
		enchant_name:   r.read_string()!
		enchant_net_id: r.read_varuint32()!
	}
}

pub struct PlayerEnchantOptionsPacket {
pub mut:
	options []OptionsEntry
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
	for e in p.options {
		e.encode(mut w)
	}
}

pub fn (mut p PlayerEnchantOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.options = []OptionsEntry{cap: count}
	for _ in 0 .. count {
		p.options << OptionsEntry.decode(mut r)!
	}
}
