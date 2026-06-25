module src

import src.serializer

pub struct EmotePacket {
pub mut:
	actor_runtime_id   u64
	emote_id           string
	emote_length_ticks int
	xbox_user_id       string
	platform_chat_id   string
	flags              int
}

pub fn (p &EmotePacket) pid() u16 {
	return emote_packet
}

pub fn (p &EmotePacket) name() string {
	return 'EmotePacket'
}

pub fn (p &EmotePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p EmotePacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.emote_id = r.read_string()!
	p.emote_length_ticks = int(r.read_varuint32()!)
	p.xbox_user_id = r.read_string()!
	p.platform_chat_id = r.read_string()!
	p.flags = int(r.u8()!)
}

pub fn (p &EmotePacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_string(p.emote_id)
	w.write_varuint32(u32(p.emote_length_ticks))
	w.write_string(p.xbox_user_id)
	w.write_string(p.platform_chat_id)
	w.u8(u8(p.flags))
}
