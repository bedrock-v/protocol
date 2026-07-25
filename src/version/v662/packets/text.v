module packets

import serializer
import version.v662.enums

pub struct TextPacket {
pub mut:
	message_type enums.TextPacketType = enums.TextRaw{}
	localize     bool
	sender_xuid  string
	platform_id  string
}

pub fn (p &TextPacket) pid() u16 { return 9 }

pub fn (p &TextPacket) name() string { return 'TextPacket' }

pub fn (p &TextPacket) can_be_sent_before_login() bool { return false }

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.message_type.id())
	w.bool(p.localize)
	p.message_type.encode_payload(mut w)
	w.write_string(p.sender_xuid)
	w.write_string(p.platform_id)
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	type_id := r.u8()!
	p.localize = r.bool()!
	p.message_type = enums.TextPacketType.decode_payload(type_id, mut r)!
	p.sender_xuid = r.read_string()!
	p.platform_id = r.read_string()!
}
