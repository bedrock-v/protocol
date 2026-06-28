module protocol

import serializer
import types

pub struct GameTestRequestPacket {
pub mut:
	max_tests_per_batch int
	repeat_count        int
	rotation            int
	stop_on_failure     bool
	test_position       types.BlockPosition
	tests_per_row       int
	test_name           string
}

pub fn (p &GameTestRequestPacket) pid() u16 {
	return game_test_request_packet
}

pub fn (p &GameTestRequestPacket) name() string {
	return 'GameTestRequestPacket'
}

pub fn (p &GameTestRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p GameTestRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.max_tests_per_batch = int(r.read_varint32()!)
	p.repeat_count = int(r.read_varint32()!)
	p.rotation = int(r.u8()!)
	p.stop_on_failure = r.bool()!
	p.test_position = r.read_block_position()!
	p.tests_per_row = int(r.read_varint32()!)
	p.test_name = r.read_string()!
}

pub fn (p &GameTestRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.max_tests_per_batch))
	w.write_varint32(i32(p.repeat_count))
	w.u8(u8(p.rotation))
	w.bool(p.stop_on_failure)
	w.write_block_position(p.test_position)
	w.write_varint32(i32(p.tests_per_row))
	w.write_string(p.test_name)
}
