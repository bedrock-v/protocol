module packets

import protocol.serializer
import protocol.version.v105.types

pub struct CraftingEventPacket {
pub mut:
	window_id u8
	type      i32
	id        types.EraBUuid
}

pub fn (p &CraftingEventPacket) pid() u16 {
	return 0x37
}

pub fn (p &CraftingEventPacket) name() string {
	return 'CraftingEventPacket'
}

pub fn (p &CraftingEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingEventPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.write_varint32(p.type)
	p.id.encode(mut w)
}

pub fn (mut p CraftingEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.type = r.read_varint32()!
	p.id = types.EraBUuid.decode(mut r)!
}
