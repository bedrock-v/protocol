module packets

import protocol.serializer
import nbt
import protocol.version.v766.enums

pub struct LevelEventGenericPacket {
pub mut:
	event_id   enums.LevelEvent
	event_data nbt.RootTag
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
	p.event_id.encode(mut w)
	w.write_nbt_compound_root(p.event_data)
}

pub fn (mut p LevelEventGenericPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_id = enums.LevelEvent.decode(mut r)!
	p.event_data = r.read_nbt_compound_root()!
}
