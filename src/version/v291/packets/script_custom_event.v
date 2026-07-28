module packets

import protocol.serializer

pub struct ScriptCustomEventPacket {
pub mut:
	event_name string
	data       string
}

pub fn (p &ScriptCustomEventPacket) pid() u16 {
	return 117
}

pub fn (p &ScriptCustomEventPacket) name() string {
	return 'ScriptCustomEventPacket'
}

pub fn (p &ScriptCustomEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ScriptCustomEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.event_name)
	w.write_string(p.data)
}

pub fn (mut p ScriptCustomEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_name = r.read_string()!
	p.data = r.read_string()!
}
