module packets

import serializer
import version.v2168.types

pub struct TransferPlayerPacket {
pub mut:
	server_address    string
	server_port       u16
	gatherings_config ?types.GatheringsConfig
}

pub fn (p &TransferPlayerPacket) pid() u16 { return 85 }

pub fn (p &TransferPlayerPacket) name() string { return 'TransferPlayerPacket' }

pub fn (p &TransferPlayerPacket) can_be_sent_before_login() bool { return false }

pub fn (p &TransferPlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.server_address)
	w.le_u16(p.server_port)
	if v := p.gatherings_config {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p TransferPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_address = r.read_string()!
	p.server_port = r.le_u16()!
	if r.bool()! {
		p.gatherings_config = types.GatheringsConfig.decode(mut r)!
	}
}
