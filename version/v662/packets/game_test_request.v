module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct GameTestRequestPacket {
pub mut:
	max_tests_per_batch i32
	repeat_count        i32
	rotation            enums.Rotation
	stop_on_failure     bool
	test_pos            types.BlockPos
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
	p.rotation.encode(mut w)
	w.bool(p.stop_on_failure)
	p.test_pos.encode(mut w)
	w.write_varint32(p.tests_per_row)
	w.write_string(p.test_name)
}

pub fn (mut p GameTestRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.max_tests_per_batch = r.read_varint32()!
	p.repeat_count = r.read_varint32()!
	p.rotation = enums.Rotation.decode(mut r)!
	p.stop_on_failure = r.bool()!
	p.test_pos = types.BlockPos.decode(mut r)!
	p.tests_per_row = r.read_varint32()!
	p.test_name = r.read_string()!
}
