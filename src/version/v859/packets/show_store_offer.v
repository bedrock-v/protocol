module packets

import serializer
import version.v662.types
import version.v662.enums

pub struct ShowStoreOfferPacket {
pub mut:
	product_id    types.Uuid
	redirect_type enums.ShowStoreOfferRedirectType
}

pub fn (p &ShowStoreOfferPacket) pid() u16 { return 91 }

pub fn (p &ShowStoreOfferPacket) name() string { return 'ShowStoreOfferPacket' }

pub fn (p &ShowStoreOfferPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ShowStoreOfferPacket) encode_payload(mut w serializer.Writer) {
	p.product_id.encode(mut w)
	p.redirect_type.encode(mut w)
}

pub fn (mut p ShowStoreOfferPacket) decode_payload(mut r serializer.Reader) ! {
	p.product_id = types.Uuid.decode(mut r)!
	p.redirect_type = enums.ShowStoreOfferRedirectType.decode(mut r)!
}
