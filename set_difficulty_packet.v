module protocol


pub struct SetDifficultyPacket {
pub mut:
	difficulty int
}

pub fn (p &SetDifficultyPacket) pid() u16 {
	return set_difficulty_packet
}

pub fn (p &SetDifficultyPacket) name() string {
	return 'SetDifficultyPacket'
}

pub fn (p &SetDifficultyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetDifficultyPacket) decode_payload(mut r Reader) ! {
	p.difficulty = int(r.read_varuint32()!)
}

pub fn (p &SetDifficultyPacket) encode_payload(mut w Writer) {
	w.write_varuint32(u32(p.difficulty))
}
