module packets

import protocol.serializer

pub struct ScriptMessagePacket {
pub mut:
	message_id    string
	message_value string
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
	w.write_string(p.message_id)
	w.write_string(p.message_value)
}

pub fn (mut p ScriptMessagePacket) decode_payload(mut r serializer.Reader) ! {
	p.message_id = r.read_string()!
	p.message_value = r.read_string()!
}
