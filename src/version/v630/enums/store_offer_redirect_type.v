module enums

import serializer

pub enum StoreOfferRedirectType as u8 {
	marketplace             = 0
	dressing_room           = 1
	third_party_server_page = 2
}

pub fn (e StoreOfferRedirectType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn StoreOfferRedirectType.decode(mut r serializer.Reader) !StoreOfferRedirectType {
	return unsafe { StoreOfferRedirectType(r.u8()!) }
}
