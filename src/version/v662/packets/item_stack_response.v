module packets

import serializer
import version.v662.types

pub struct ItemStackResponsePacket {
pub mut:
	responses []types.ItemStackResponseInfo
}

pub fn (p &ItemStackResponsePacket) pid() u16 { return 148 }

pub fn (p &ItemStackResponsePacket) name() string { return 'ItemStackResponsePacket' }

pub fn (p &ItemStackResponsePacket) can_be_sent_before_login() bool { return false }

pub fn (p &ItemStackResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.responses.len))
	for e in p.responses {
		e.encode(mut w)
	}
}

pub fn (mut p ItemStackResponsePacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := int(r.read_varuint32()!)
		p.responses = []types.ItemStackResponseInfo{cap: count}
		for _ in 0 .. count {
			p.responses << types.ItemStackResponseInfo.decode(mut r)!
		}
	}
}
