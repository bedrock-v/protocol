module packets

import protocol.serializer
import protocol.version.v465.types
import protocol.version.v291.types as types_291

pub enum PlayerListAction as u8 {
	add    = 0
	remove = 1
}

pub enum BuildPlatform as i32 {
	unknown       = 0
	google        = 1
	ios           = 2
	osx           = 3
	amazon        = 4
	gear_vr       = 5
	hololens      = 6
	uwp           = 7
	win32         = 8
	dedicated     = 9
	tv_os         = 10
	sony          = 11
	nx            = 12
	xbox          = 13
	windows_phone = 14
	linux         = 15
}

pub struct PlayerListEntry {
pub mut:
	uuid             types_291.Uuid
	entity_id        i64
	name             string
	xuid             string
	platform_chat_id string
	build_platform   BuildPlatform
	skin             types.SerializedSkin
	teacher          bool
	host             bool
	trusted_skin     bool
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
	if p.action == .add {
		for e in p.entries {
			e.uuid.encode(mut w)
			w.write_varint64(e.entity_id)
			w.write_string(e.name)
			w.write_string(e.xuid)
			w.write_string(e.platform_chat_id)
			w.le_i32(i32(e.build_platform))
			e.skin.encode(mut w)
			w.bool(e.teacher)
			w.bool(e.host)
		}
		for e in p.entries {
			w.bool(e.trusted_skin)
		}
	} else {
		for e in p.entries {
			e.uuid.encode(mut w)
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PlayerListAction(r.u8()!) }
	count := r.read_count()!
	p.entries = []PlayerListEntry{cap: serializer.prealloc(count)}
	if p.action == .add {
		for _ in 0 .. count {
			mut e := PlayerListEntry{
				uuid: types_291.Uuid.decode(mut r)!
			}
			e.entity_id = r.read_varint64()!
			e.name = r.read_string()!
			e.xuid = r.read_string()!
			e.platform_chat_id = r.read_string()!
			e.build_platform = unsafe { BuildPlatform(r.le_i32()!) }
			e.skin = types.SerializedSkin.decode(mut r)!
			e.teacher = r.bool()!
			e.host = r.bool()!
			p.entries << e
		}
		for i in 0 .. count {
			if r.remaining() <= 0 {
				break
			}
			p.entries[i].trusted_skin = r.bool()!
		}
	} else {
		for _ in 0 .. count {
			p.entries << PlayerListEntry{
				uuid: types_291.Uuid.decode(mut r)!
			}
		}
	}
}
