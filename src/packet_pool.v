module protocol

import serializer

pub struct PacketPool {
pub mut:
	factories map[u16]fn () Packet
}

pub fn new_empty_pool() PacketPool {
	return PacketPool{
		factories: map[u16]fn () Packet{}
	}
}

pub fn (mut p PacketPool) register(factory fn () Packet) {
	pkt := factory()
	p.factories[pkt.pid()] = factory
}

pub fn (p &PacketPool) get_packet_by_id(pid u16) ?Packet {
	factory := p.factories[pid] or { return none }
	return factory()
}

pub fn (p &PacketPool) decode(mut r serializer.Reader) !Packet {
	header := read_packet_header(mut r)!
	mut pkt := p.get_packet_by_id(header.pid) or {
		return error('unknown packet id 0x${header.pid:x}')
	}
	pkt.decode_payload(mut r)!
	return pkt
}

// decode_old dispatches on a single raw-byte packet id (old-era framing,
// MCPE 0.6-0.15 / proto 9..84).
pub fn (p &PacketPool) decode_old(mut r serializer.Reader) !Packet {
	pid := u16(r.u8()!)
	mut pkt := p.get_packet_by_id(pid) or {
		return error('unknown packet id 0x${pid:x}')
	}
	pkt.decode_payload(mut r)!
	return pkt
}

// decode_split dispatches on a varuint packet id followed by two sub-client id
// bytes (MCPE 1.2-1.5 / proto 130..274).
pub fn (p &PacketPool) decode_split(mut r serializer.Reader) !Packet {
	pid := u16(r.read_varuint32()!)
	r.u8()!
	r.u8()!
	mut pkt := p.get_packet_by_id(pid) or {
		return error('unknown packet id 0x${pid:x}')
	}
	pkt.decode_payload(mut r)!
	return pkt
}
