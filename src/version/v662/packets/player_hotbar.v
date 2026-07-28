module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct PlayerHotbarPacket {
pub mut:
	selected_slot      u32
	container_id       enums.ContainerID
	should_select_slot bool
}

pub fn (p &PlayerHotbarPacket) pid() u16 {
	return 48
}

pub fn (p &PlayerHotbarPacket) name() string {
	return 'PlayerHotbarPacket'
}

pub fn (p &PlayerHotbarPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerHotbarPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.selected_slot)
	p.container_id.encode(mut w)
	w.bool(p.should_select_slot)
}

pub fn (mut p PlayerHotbarPacket) decode_payload(mut r serializer.Reader) ! {
	p.selected_slot = r.read_varuint32()!
	p.container_id = enums.ContainerID.decode(mut r)!
	p.should_select_slot = r.bool()!
}
