module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct UpdateTradePacket {
pub mut:
	container_id           enums.ContainerID
	container_type         enums.ContainerType
	size                   i32
	trade_tier             i32
	target_actor_id        types.ActorUniqueID
	last_trading_player_id types.ActorUniqueID
	display_name           string
	use_new_trade_ui       bool
	using_economy_trade    bool
	data_tags              nbt.RootTag
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
	p.container_id.encode(mut w)
	p.container_type.encode(mut w)
	w.write_varint32(p.size)
	w.write_varint32(p.trade_tier)
	p.target_actor_id.encode(mut w)
	p.last_trading_player_id.encode(mut w)
	w.write_string(p.display_name)
	w.bool(p.use_new_trade_ui)
	w.bool(p.using_economy_trade)
	w.write_nbt_compound_root(p.data_tags)
}

pub fn (mut p UpdateTradePacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.size = r.read_varint32()!
	p.trade_tier = r.read_varint32()!
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.last_trading_player_id = types.ActorUniqueID.decode(mut r)!
	p.display_name = r.read_string()!
	p.use_new_trade_ui = r.bool()!
	p.using_economy_trade = r.bool()!
	p.data_tags = r.read_nbt_compound_root()!
}
