module protocol

import serializer

pub struct RefreshEntitlementsPacket {
}

pub fn (p &RefreshEntitlementsPacket) pid() u16 {
	return refresh_entitlements_packet
}

pub fn (p &RefreshEntitlementsPacket) name() string {
	return 'RefreshEntitlementsPacket'
}

pub fn (p &RefreshEntitlementsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RefreshEntitlementsPacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &RefreshEntitlementsPacket) encode_payload(mut w serializer.Writer) {
}
