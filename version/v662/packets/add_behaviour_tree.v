module packets

import protocol.serializer

pub struct AddBehaviourTreePacket {
pub mut:
	json_behaviour_tree_structure string
}

pub fn (p &AddBehaviourTreePacket) pid() u16 {
	return 89
}

pub fn (p &AddBehaviourTreePacket) name() string {
	return 'AddBehaviourTreePacket'
}

pub fn (p &AddBehaviourTreePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddBehaviourTreePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.json_behaviour_tree_structure)
}

pub fn (mut p AddBehaviourTreePacket) decode_payload(mut r serializer.Reader) ! {
	p.json_behaviour_tree_structure = r.read_string()!
}
