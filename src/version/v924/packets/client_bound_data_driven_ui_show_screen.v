module packets

import serializer

pub struct ClientBoundDataDrivenUIShowScreenPacket {
pub mut:
	screen_id string
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) pid() u16 {
	return 333
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) name() string {
	return 'ClientBoundDataDrivenUIShowScreenPacket'
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.screen_id)
}

pub fn (mut p ClientBoundDataDrivenUIShowScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.screen_id = r.read_string()!
}
