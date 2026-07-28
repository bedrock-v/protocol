module packets

import protocol.serializer

pub struct PlayerVideoCaptureStop {}

pub struct PlayerVideoCaptureStart {
pub mut:
	frame_rate  i32
	file_prefix string
}

pub struct PlayerVideoCaptureUnknown {}

pub type PlayerVideoCapturePacketAction = PlayerVideoCaptureStart
	| PlayerVideoCaptureStop
	| PlayerVideoCaptureUnknown

pub fn (t PlayerVideoCapturePacketAction) encode(mut w serializer.Writer) {
	match t {
		PlayerVideoCaptureStop {
			w.i8(0)
		}
		PlayerVideoCaptureStart {
			w.i8(1)
			w.le_i32(t.frame_rate)
			w.write_string(t.file_prefix)
		}
		PlayerVideoCaptureUnknown {
			w.i8(2)
		}
	}
}

pub fn PlayerVideoCapturePacketAction.decode(mut r serializer.Reader) !PlayerVideoCapturePacketAction {
	d := r.i8()!
	match d {
		0 { return PlayerVideoCaptureStop{} }
		1 { return PlayerVideoCaptureStart{
				frame_rate:  r.le_i32()!
				file_prefix: r.read_string()!
			} }
		2 { return PlayerVideoCaptureUnknown{} }
		else { return error('invalid PlayerVideoCapturePacketAction ${d}') }
	}
}

pub struct PlayerVideoCapturePacket {
pub mut:
	action PlayerVideoCapturePacketAction = PlayerVideoCaptureStop{}
}

pub fn (p &PlayerVideoCapturePacket) pid() u16 {
	return 324
}

pub fn (p &PlayerVideoCapturePacket) name() string {
	return 'PlayerVideoCapturePacket'
}

pub fn (p &PlayerVideoCapturePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerVideoCapturePacket) encode_payload(mut w serializer.Writer) {
	p.action.encode(mut w)
}

pub fn (mut p PlayerVideoCapturePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = PlayerVideoCapturePacketAction.decode(mut r)!
}
