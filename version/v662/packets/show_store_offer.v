module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct ShowStoreOfferPacket {
pub mut:
	product_id    string
	redirect_type enums.ShowStoreOfferRedirectType
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
	w.write_string(p.product_id)
	p.redirect_type.encode(mut w)
}

pub fn (mut p ShowStoreOfferPacket) decode_payload(mut r serializer.Reader) ! {
	p.product_id = r.read_string()!
	p.redirect_type = enums.ShowStoreOfferRedirectType.decode(mut r)!
}
