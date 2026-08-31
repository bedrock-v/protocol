module packets

import protocol.serializer
import protocol.version.v898.enums

pub struct TextPacket {
pub mut:
	localize         bool
	message_type     enums.TextPacketType = enums.TextRaw{}
	sender_xuid      string
	platform_id      string
	filtered_message ?string
}

pub fn (p &TextPacket) pid() u16 {
	return 9
}

pub fn (p &TextPacket) name() string {
	return 'TextPacket'
}

pub fn (p &TextPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.localize)
	p.message_type.encode(mut w)
	w.write_string(p.sender_xuid)
	w.write_string(p.platform_id)
	if v := p.filtered_message {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.localize = r.bool()!
	p.message_type = enums.TextPacketType.decode(mut r)!
	p.sender_xuid = r.read_string()!
	p.platform_id = r.read_string()!
	if r.bool()! {
		p.filtered_message = r.read_string()!
	}
}
