module packets

import serializer

pub const emote_flag_server_side = u8(0x01)
pub const emote_flag_mute_emote_chat = u8(0x02)

pub struct EmotePacket {
pub mut:
	runtime_entity_id u64
	emote_id          string
	flags             u8
}

pub fn (p &EmotePacket) pid() u16 {
	return 138
}

pub fn (p &EmotePacket) name() string {
	return 'EmotePacket'
}

pub fn (p &EmotePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EmotePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	w.write_string(p.emote_id)
	w.u8(p.flags)
}

pub fn (mut p EmotePacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.emote_id = r.read_string()!
	p.flags = r.u8()!
}
