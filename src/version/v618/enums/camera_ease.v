module enums

import serializer

pub enum CameraEase as u8 {
	linear              = 0
	spring              = 1
	ease_in_sine        = 2
	ease_out_sine       = 3
	ease_in_out_sine    = 4
	ease_in_quad        = 5
	ease_out_quad       = 6
	ease_in_out_quad    = 7
	ease_in_cubic       = 8
	ease_out_cubic      = 9
	ease_in_out_cubic   = 10
	ease_in_quart       = 11
	ease_out_quart      = 12
	ease_in_out_quart   = 13
	ease_in_quint       = 14
	ease_out_quint      = 15
	ease_in_out_quint   = 16
	ease_in_expo        = 17
	ease_out_expo       = 18
	ease_in_out_expo    = 19
	ease_in_circ        = 20
	ease_out_circ       = 21
	ease_in_out_circ    = 22
	ease_in_back        = 23
	ease_out_back       = 24
	ease_in_out_back    = 25
	ease_in_elastic     = 26
	ease_out_elastic    = 27
	ease_in_out_elastic = 28
	ease_in_bounce      = 29
	ease_out_bounce     = 30
	ease_in_out_bounce  = 31
}

pub fn (e CameraEase) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn CameraEase.decode(mut r serializer.Reader) !CameraEase {
	return unsafe { CameraEase(r.u8()!) }
}
