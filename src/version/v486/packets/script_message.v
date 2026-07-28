module packets

import protocol.serializer

pub struct ScriptMessagePacket {
pub mut:
	channel string
	message string
}

pub fn (p &ScriptMessagePacket) pid() u16 {
	return 177
}

pub fn (p &ScriptMessagePacket) name() string {
	return 'ScriptMessagePacket'
}

pub fn (p &ScriptMessagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ScriptMessagePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.channel)
	w.write_string(p.message)
}

pub fn (mut p ScriptMessagePacket) decode_payload(mut r serializer.Reader) ! {
	p.channel = r.read_string()!
	p.message = r.read_string()!
}
