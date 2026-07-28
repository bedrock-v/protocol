module packets

import protocol.serializer

pub struct PlayerArmorDamageEntry {
pub mut:
	slot   i8
	damage i16
}

pub fn (t PlayerArmorDamageEntry) encode(mut w serializer.Writer) {
	w.i8(t.slot)
	w.le_i16(t.damage)
}

pub fn PlayerArmorDamageEntry.decode(mut r serializer.Reader) !PlayerArmorDamageEntry {
	return PlayerArmorDamageEntry{
		slot:   r.i8()!
		damage: r.le_i16()!
	}
}

pub struct PlayerArmorDamagePacket {
pub mut:
	list []PlayerArmorDamageEntry
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
	w.write_varuint32(u32(p.list.len))
	for e in p.list {
		e.encode(mut w)
	}
}

pub fn (mut p PlayerArmorDamagePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	mut list := []PlayerArmorDamageEntry{cap: count}
	for _ in 0 .. count {
		list << PlayerArmorDamageEntry.decode(mut r)!
	}
	p.list = list
}
