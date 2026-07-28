module packets

import protocol.serializer
import protocol.version.v630.enums

pub struct ShowStoreOfferPacket {
pub mut:
	offer_id      string
	redirect_type enums.StoreOfferRedirectType
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
	p.redirect_type.encode(mut w)
}

pub fn (mut p ShowStoreOfferPacket) decode_payload(mut r serializer.Reader) ! {
	p.offer_id = r.read_string()!
	p.redirect_type = enums.StoreOfferRedirectType.decode(mut r)!
}
