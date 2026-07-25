module enums

import serializer

pub enum ShowStoreOfferRedirectType as i8 {
	marketplace_offer       = 0
	dressing_room_offer     = 1
	third_party_server_page = 2
}

pub fn (e ShowStoreOfferRedirectType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ShowStoreOfferRedirectType.decode(mut r serializer.Reader) !ShowStoreOfferRedirectType {
	return unsafe { ShowStoreOfferRedirectType(r.i8()!) }
}
