module packets

import protocol.serializer

pub struct UpdateTradePacket {
pub mut:
	window_id    u8
	window_type  u8
	varint1      i32
	varint2      i32
	is_willing   bool
	trader_eid   i64
	player_eid   i64
	display_name string
	offers       []u8
}

pub fn (p &UpdateTradePacket) pid() u16 {
	return 80
}

pub fn (p &UpdateTradePacket) name() string {
	return 'UpdateTradePacket'
}

pub fn (p &UpdateTradePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateTradePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.u8(p.window_type)
	w.write_varint32(p.varint1)
	w.write_varint32(p.varint2)
	w.bool(p.is_willing)
	w.write_varint64(p.trader_eid)
	w.write_varint64(p.player_eid)
	w.write_string(p.display_name)
	w.write_raw(p.offers)
}

pub fn (mut p UpdateTradePacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.window_type = r.u8()!
	p.varint1 = r.read_varint32()!
	p.varint2 = r.read_varint32()!
	p.is_willing = r.bool()!
	p.trader_eid = r.read_varint64()!
	p.player_eid = r.read_varint64()!
	p.display_name = r.read_string()!
	p.offers = r.read_raw(r.remaining())!
}
