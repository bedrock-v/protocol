module packets

import serializer
import nbt
import version.v291.enums

pub struct UpdateTradePacket {
pub mut:
	container_id            i8
	container_type          enums.ContainerType
	size                    i32
	trade_tier              i32
	trader_unique_entity_id i64
	player_unique_entity_id i64
	display_name            string
	new_trading_ui          bool
	using_economy_trade     bool
	offers                  nbt.RootTag
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
	w.i8(p.container_id)
	p.container_type.encode(mut w)
	w.write_varint32(p.size)
	w.write_varint32(p.trade_tier)
	w.write_varint64(p.trader_unique_entity_id)
	w.write_varint64(p.player_unique_entity_id)
	w.write_string(p.display_name)
	w.bool(p.new_trading_ui)
	w.bool(p.using_economy_trade)
	w.write_nbt_compound_root(p.offers)
}

pub fn (mut p UpdateTradePacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.i8()!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.size = r.read_varint32()!
	p.trade_tier = r.read_varint32()!
	p.trader_unique_entity_id = r.read_varint64()!
	p.player_unique_entity_id = r.read_varint64()!
	p.display_name = r.read_string()!
	p.new_trading_ui = r.bool()!
	p.using_economy_trade = r.bool()!
	p.offers = r.read_nbt_compound_root()!
}
