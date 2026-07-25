module packets

import serializer

pub enum VideoStreamAction as u8 {
	open  = 0
	close = 1
}

pub struct VideoStreamConnectPacket {
pub mut:
	address              string
	screenshot_frequency f32
	action               VideoStreamAction
}

pub fn (p &VideoStreamConnectPacket) pid() u16 {
	return 125
}

pub fn (p &VideoStreamConnectPacket) name() string {
	return 'VideoStreamConnectPacket'
}

pub fn (p &VideoStreamConnectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &VideoStreamConnectPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.address)
	w.le_f32(p.screenshot_frequency)
	w.u8(u8(p.action))
}

pub fn (mut p VideoStreamConnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.address = r.read_string()!
	p.screenshot_frequency = r.le_f32()!
	p.action = unsafe { VideoStreamAction(r.u8()!) }
}
