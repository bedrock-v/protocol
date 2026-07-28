module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v388.types

pub enum PlayerListAction as u8 {
	add    = 0
	remove = 1
}

pub struct PlayerListEntry {
pub mut:
	uuid             types_291.Uuid
	entity_id        i64
	name             string
	xuid             string
	platform_chat_id string
	build_platform   i32
	skin             types.SerializedSkin
	teacher          bool
	host             bool
}

pub struct PlayerListPacket {
pub mut:
	action  PlayerListAction
	entries []PlayerListEntry
}

pub fn (p &PlayerListPacket) pid() u16 {
	return 63
}

pub fn (p &PlayerListPacket) name() string {
	return 'PlayerListPacket'
}

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		e.uuid.encode(mut w)
		if p.action == .add {
			w.write_varint64(e.entity_id)
			w.write_string(e.name)
			w.write_string(e.xuid)
			w.write_string(e.platform_chat_id)
			w.le_i32(e.build_platform)
			e.skin.encode(mut w)
			w.bool(e.teacher)
			w.bool(e.host)
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PlayerListAction(r.u8()!) }
	count := int(r.read_varuint32()!)
	p.entries = []PlayerListEntry{cap: count}
	for _ in 0 .. count {
		mut e := PlayerListEntry{
			uuid: types_291.Uuid.decode(mut r)!
		}
		if p.action == .add {
			e.entity_id = r.read_varint64()!
			e.name = r.read_string()!
			e.xuid = r.read_string()!
			e.platform_chat_id = r.read_string()!
			e.build_platform = r.le_i32()!
			e.skin = types.SerializedSkin.decode(mut r)!
			e.teacher = r.bool()!
			e.host = r.bool()!
		}
		p.entries << e
	}
}
