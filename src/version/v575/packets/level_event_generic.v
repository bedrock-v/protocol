module packets

import nbt
import protocol.serializer
import protocol.version.v575.enums

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
	enc := nbt.encode(nbt.RootTag{
		name: ''
		tag:  p.tag.tag
	})
	w.u8(enc[0])
	w.write_raw(enc[2..])
}

pub fn (mut p LevelEventGenericPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_type = enums.LevelEvent.decode(mut r)!
	id := r.u8()!
	mut data := []u8{cap: r.remaining() + 2}
	data << id
	data << 0
	data << r.data[r.offset..]
	res := nbt.decode(data)!
	r.offset += res.read - 2
	p.tag = res.root
}
