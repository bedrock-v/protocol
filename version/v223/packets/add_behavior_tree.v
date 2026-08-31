module packets

import protocol.serializer

pub struct AddBehaviorTreePacket {
pub mut:
	unknown_string1 string
}

pub fn (p &AddBehaviorTreePacket) pid() u16 {
	return 89
}

pub fn (p &AddBehaviorTreePacket) name() string {
	return 'AddBehaviorTreePacket'
}

pub fn (p &AddBehaviorTreePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddBehaviorTreePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.unknown_string1)
}

pub fn (mut p AddBehaviorTreePacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown_string1 = r.read_string()!
}
