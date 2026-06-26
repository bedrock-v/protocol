module src

import src.serializer

pub struct PlayerVideoCapturePacket {
pub mut:
	recording   bool
	frame_rate  int
	file_prefix string
}

pub fn (p &PlayerVideoCapturePacket) pid() u16 {
	return player_video_capture_packet
}

pub fn (p &PlayerVideoCapturePacket) name() string {
	return 'PlayerVideoCapturePacket'
}

pub fn (p &PlayerVideoCapturePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerVideoCapturePacket) decode_payload(mut r serializer.Reader) ! {
	p.recording = r.bool()!
	if p.recording {
		p.frame_rate = int(r.le_u32()!)
		p.file_prefix = r.read_string()!
	}
}

pub fn (p &PlayerVideoCapturePacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.recording)
	if p.recording {
		w.le_u32(u32(p.frame_rate))
		w.write_string(p.file_prefix)
	}
}
