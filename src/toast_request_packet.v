module src

import src.serializer

pub struct ToastRequestPacket {
pub mut:
	title string
	body  string
}

pub fn (p &ToastRequestPacket) pid() u16 {
	return toast_request_packet
}

pub fn (p &ToastRequestPacket) name() string {
	return 'ToastRequestPacket'
}

pub fn (p &ToastRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ToastRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.title = r.read_string()!
	p.body = r.read_string()!
}

pub fn (p &ToastRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.title)
	w.write_string(p.body)
}
