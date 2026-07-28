module packets

import protocol.serializer
import nbt
import protocol.version.v291.enums

pub struct UpdateTradePacket {
pub mut:
	container_id            i8
	container_type          enums.ContainerType
	size                    i32
	using_economy_trade     bool
	trade_tier              i32
	recipe_added_on_update  bool
	trader_unique_entity_id i64
	player_unique_entity_id i64
	display_name            string
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
	w.write_varint32(if p.using_economy_trade { i32(40) } else { i32(0) })
	w.write_varint32(p.trade_tier)
	w.bool(p.recipe_added_on_update)
	w.write_varint64(p.trader_unique_entity_id)
	w.write_varint64(p.player_unique_entity_id)
	w.write_string(p.display_name)
	w.write_nbt_compound_root(p.offers)
}

pub fn (mut p UpdateTradePacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.i8()!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.size = r.read_varint32()!
	p.using_economy_trade = r.read_varint32()! >= 40
	p.trade_tier = r.read_varint32()!
	p.recipe_added_on_update = r.bool()!
	p.trader_unique_entity_id = r.read_varint64()!
	p.player_unique_entity_id = r.read_varint64()!
	p.display_name = r.read_string()!
	p.offers = r.read_nbt_compound_root()!
}
