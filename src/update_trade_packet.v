module protocol

import serializer
import nbt

pub struct UpdateTradePacket {
pub mut:
	window_id              u8
	window_type            u8
	window_slot_count      int
	trade_tier             int
	trader_actor_unique_id i64
	player_actor_unique_id i64
	display_name           string
	is_v2_trading          bool
	is_economy_trading     bool
	offers                 nbt.RootTag
}

pub fn (p &UpdateTradePacket) pid() u16 {
	return update_trade_packet
}

pub fn (p &UpdateTradePacket) name() string {
	return 'UpdateTradePacket'
}

pub fn (p &UpdateTradePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateTradePacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.window_type = r.u8()!
	p.window_slot_count = r.read_varint32()!
	p.trade_tier = r.read_varint32()!
	p.trader_actor_unique_id = r.read_actor_unique_id()!
	p.player_actor_unique_id = r.read_actor_unique_id()!
	p.display_name = r.read_string()!
	p.is_v2_trading = r.bool()!
	p.is_economy_trading = r.bool()!
	p.offers = r.read_nbt_compound_root()!
}

pub fn (p &UpdateTradePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.u8(p.window_type)
	w.write_varint32(p.window_slot_count)
	w.write_varint32(p.trade_tier)
	w.write_actor_unique_id(p.trader_actor_unique_id)
	w.write_actor_unique_id(p.player_actor_unique_id)
	w.write_string(p.display_name)
	w.bool(p.is_v2_trading)
	w.bool(p.is_economy_trading)
	w.write_nbt_compound_root(p.offers)
}
