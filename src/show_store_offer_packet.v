module protocol

import serializer
import types

pub struct ShowStoreOfferPacket {
pub mut:
	offer_id      types.UUID
	redirect_type int
}

pub fn (p &ShowStoreOfferPacket) pid() u16 {
	return show_store_offer_packet
}

pub fn (p &ShowStoreOfferPacket) name() string {
	return 'ShowStoreOfferPacket'
}

pub fn (p &ShowStoreOfferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ShowStoreOfferPacket) decode_payload(mut r serializer.Reader) ! {
	p.offer_id = r.read_uuid()!
	p.redirect_type = int(r.u8()!)
}

pub fn (p &ShowStoreOfferPacket) encode_payload(mut w serializer.Writer) {
	w.write_uuid(p.offer_id)
	w.u8(u8(p.redirect_type))
}
