module src

import src.serializer

pub struct GameTestResultsPacket {
pub mut:
	success   bool
	error     string
	test_name string
}

pub fn (p &GameTestResultsPacket) pid() u16 {
	return game_test_results_packet
}

pub fn (p &GameTestResultsPacket) name() string {
	return 'GameTestResultsPacket'
}

pub fn (p &GameTestResultsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p GameTestResultsPacket) decode_payload(mut r serializer.Reader) ! {
	p.success = r.bool()!
	p.error = r.read_string()!
	p.test_name = r.read_string()!
}

pub fn (p &GameTestResultsPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.success)
	w.write_string(p.error)
	w.write_string(p.test_name)
}
