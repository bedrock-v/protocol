module packets

import serializer

pub struct SetDifficultyPacket {
pub mut:
	difficulty i32
}

pub fn (p &SetDifficultyPacket) pid() u16 {
	return 0x38
}

pub fn (p &SetDifficultyPacket) name() string {
	return 'SetDifficultyPacket'
}

pub fn (p &SetDifficultyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetDifficultyPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.difficulty)
}

pub fn (mut p SetDifficultyPacket) decode_payload(mut r serializer.Reader) ! {
	p.difficulty = r.be_i32()!
}
