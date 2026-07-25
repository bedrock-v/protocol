module packets

import serializer

pub struct ShowStoreOfferPacket {
pub mut:
	offer_id string
	show_all bool
}

pub fn (p &ShowStoreOfferPacket) pid() u16 {
	return 91
}

pub fn (p &ShowStoreOfferPacket) name() string {
	return 'ShowStoreOfferPacket'
}

pub fn (p &ShowStoreOfferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ShowStoreOfferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.offer_id)
	w.bool(p.show_all)
}

pub fn (mut p ShowStoreOfferPacket) decode_payload(mut r serializer.Reader) ! {
	p.offer_id = r.read_string()!
	p.show_all = r.bool()!
}
