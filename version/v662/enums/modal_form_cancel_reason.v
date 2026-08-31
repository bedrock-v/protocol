module enums

import protocol.serializer

pub enum ModalFormCancelReason as i8 {
	user_closed = 0
	user_busy   = 1
}

pub fn (e ModalFormCancelReason) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ModalFormCancelReason.decode(mut r serializer.Reader) !ModalFormCancelReason {
	return unsafe { ModalFormCancelReason(r.i8()!) }
}
