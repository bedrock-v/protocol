module packets

import protocol.serializer

pub struct GameTestResultsPacket {
pub mut:
	successful bool
	error      string
	test_name  string
}

pub fn (p &GameTestResultsPacket) pid() u16 {
	return 195
}

pub fn (p &GameTestResultsPacket) name() string {
	return 'GameTestResultsPacket'
}

pub fn (p &GameTestResultsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &GameTestResultsPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.successful)
	w.write_string(p.error)
	w.write_string(p.test_name)
}

pub fn (mut p GameTestResultsPacket) decode_payload(mut r serializer.Reader) ! {
	p.successful = r.bool()!
	p.error = r.read_string()!
	p.test_name = r.read_string()!
}
