module packets

import serializer
import version.v407.types

pub struct ItemStackRequestPacket {
pub mut:
	requests []types.ItemStackRequest
}

pub fn (p &ItemStackRequestPacket) pid() u16 {
	return 147
}

pub fn (p &ItemStackRequestPacket) name() string {
	return 'ItemStackRequestPacket'
}

pub fn (p &ItemStackRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemStackRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.requests.len))
	for request in p.requests {
		request.encode(mut w)
	}
}

pub fn (mut p ItemStackRequestPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.requests = []types.ItemStackRequest{cap: count}
	for _ in 0 .. count {
		p.requests << types.ItemStackRequest.decode(mut r)!
	}
}
