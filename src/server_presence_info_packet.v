module src

import src.serializer

pub struct PresenceInfo {
pub mut:
	experience_name  ?string
	world_name       ?string
	rich_presence_id string
}

pub struct ServerPresenceInfoPacket {
pub mut:
	presence ?PresenceInfo
}

pub fn (p &ServerPresenceInfoPacket) pid() u16 {
	return server_presence_info_packet
}

pub fn (p &ServerPresenceInfoPacket) name() string {
	return 'ServerPresenceInfoPacket'
}

pub fn (p &ServerPresenceInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerPresenceInfoPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		mut info := PresenceInfo{}
		if r.bool()! {
			info.experience_name = r.read_string()!
		}
		if r.bool()! {
			info.world_name = r.read_string()!
		}
		info.rich_presence_id = r.read_string()!
		p.presence = info
	}
}

pub fn (p &ServerPresenceInfoPacket) encode_payload(mut w serializer.Writer) {
	if info := p.presence {
		w.bool(true)
		if en := info.experience_name {
			w.bool(true)
			w.write_string(en)
		} else {
			w.bool(false)
		}
		if wn := info.world_name {
			w.bool(true)
			w.write_string(wn)
		} else {
			w.bool(false)
		}
		w.write_string(info.rich_presence_id)
	} else {
		w.bool(false)
	}
}
