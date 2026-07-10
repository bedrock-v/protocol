module protocol


pub struct OpenSignPacket {
pub mut:
	block_position BlockPosition
	front          bool
}

pub fn (p &OpenSignPacket) pid() u16 {
	return open_sign_packet
}

pub fn (p &OpenSignPacket) name() string {
	return 'OpenSignPacket'
}

pub fn (p &OpenSignPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p OpenSignPacket) decode_payload(mut r Reader) ! {
	p.block_position = r.read_block_position()!
	p.front = r.bool()!
}

pub fn (p &OpenSignPacket) encode_payload(mut w Writer) {
	w.write_block_position(p.block_position)
	w.bool(p.front)
}
