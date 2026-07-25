module packets

import serializer

pub enum ServerBoundLoadingScreenPacketType as i32 {
	unknown              = 0
	start_loading_screen = 1
	end_loading_screen   = 2
}

pub struct ServerBoundLoadingScreenPacket {
pub mut:
	packet_type       ServerBoundLoadingScreenPacketType
	loading_screen_id ?i32
}

pub fn (p &ServerBoundLoadingScreenPacket) pid() u16 { return 312 }

pub fn (p &ServerBoundLoadingScreenPacket) name() string { return 'ServerBoundLoadingScreenPacket' }

pub fn (p &ServerBoundLoadingScreenPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerBoundLoadingScreenPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.packet_type))
	if v := p.loading_screen_id {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ServerBoundLoadingScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.packet_type = unsafe { ServerBoundLoadingScreenPacketType(r.read_varint32()!) }
	if r.bool()! {
		p.loading_screen_id = r.le_i32()!
	} else {
		p.loading_screen_id = none
	}
}
