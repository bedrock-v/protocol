module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct GameTestRequestPacket {
pub mut:
	max_tests_per_batch i32
	repeat_count        i32
	rotation            i8
	stopping_on_failure bool
	test_pos            types_291.Vector3i
	tests_per_row       i32
	test_name           string
}

pub fn (p &GameTestRequestPacket) pid() u16 {
	return 194
}

pub fn (p &GameTestRequestPacket) name() string {
	return 'GameTestRequestPacket'
}

pub fn (p &GameTestRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &GameTestRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.max_tests_per_batch)
	w.write_varint32(p.repeat_count)
	w.i8(p.rotation)
	w.bool(p.stopping_on_failure)
	p.test_pos.encode(mut w)
	w.write_varint32(p.tests_per_row)
	w.write_string(p.test_name)
}

pub fn (mut p GameTestRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.max_tests_per_batch = r.read_varint32()!
	p.repeat_count = r.read_varint32()!
	p.rotation = r.i8()!
	p.stopping_on_failure = r.bool()!
	p.test_pos = types_291.Vector3i.decode(mut r)!
	p.tests_per_row = r.read_varint32()!
	p.test_name = r.read_string()!
}
