module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v471.enums

pub struct LevelEventGenericPacket {
pub mut:
	event_type enums.LevelEvent
	tag        nbt.RootTag
}

pub fn (p &LevelEventGenericPacket) pid() u16 {
	return 124
}

pub fn (p &LevelEventGenericPacket) name() string {
	return 'LevelEventGenericPacket'
}

pub fn (p &LevelEventGenericPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelEventGenericPacket) encode_payload(mut w serializer.Writer) {
	p.event_type.encode(mut w)
	w.write_nbt_compound_root(p.tag)
}

pub fn (mut p LevelEventGenericPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_type = enums.LevelEvent.decode(mut r)!
	p.tag = r.read_nbt_compound_root()!
}
