module packets

import serializer
import version.v662.types

pub enum EmoteFlags as i8 {
	server_side     = 0x0
	mute_emote_chat = 0x2
}

pub struct EmotePacket {
pub mut:
	actor_runtime_id types.ActorRuntimeID
	emote_id         string
	xuid             string
	platform_id      string
	flags            EmoteFlags
}

pub fn (p &EmotePacket) pid() u16 { return 138 }

pub fn (p &EmotePacket) name() string { return 'EmotePacket' }

pub fn (p &EmotePacket) can_be_sent_before_login() bool { return false }

pub fn (p &EmotePacket) encode_payload(mut w serializer.Writer) {
	p.actor_runtime_id.encode(mut w)
	w.write_string(p.emote_id)
	w.write_string(p.xuid)
	w.write_string(p.platform_id)
	w.i8(i8(p.flags))
}

pub fn (mut p EmotePacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.emote_id = r.read_string()!
	p.xuid = r.read_string()!
	p.platform_id = r.read_string()!
	p.flags = unsafe { EmoteFlags(r.i8()!) }
}
