module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v361.enums

pub struct LevelEventGenericPacket {
pub mut:
	event_type enums.LevelEvent
	tag        nbt.Tag = nbt.new_compound()
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
	encoded := nbt.encode(nbt.RootTag{
		name: ''
		tag:  p.tag
	})
	w.write_raw(encoded[2..])
}

pub fn (mut p LevelEventGenericPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_type = enums.LevelEvent.decode(mut r)!
	mut data := [u8(10), 0]
	data << r.read_raw(r.remaining())!
	res := nbt.decode(data)!
	p.tag = res.root.tag
}
