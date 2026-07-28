module packets

import protocol.serializer
import protocol.version.v2168.types

pub struct ClientBoundUpdateSoundDataPacket {
pub mut:
	server_sound_handle i64
	stop                ?types.SoundData
	set_volume          ?types.SoundData
	set_pitch           ?types.SoundData
	fade                ?types.SoundData
	seek_to             ?types.SoundData
	pause               ?types.SoundData
	resume              ?types.SoundData
}

pub fn (p &ClientBoundUpdateSoundDataPacket) pid() u16 {
	return 348
}

pub fn (p &ClientBoundUpdateSoundDataPacket) name() string {
	return 'ClientBoundUpdateSoundDataPacket'
}

pub fn (p &ClientBoundUpdateSoundDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundUpdateSoundDataPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.server_sound_handle)
	encode_opt_sound_data(mut w, p.stop)
	encode_opt_sound_data(mut w, p.set_volume)
	encode_opt_sound_data(mut w, p.set_pitch)
	encode_opt_sound_data(mut w, p.fade)
	encode_opt_sound_data(mut w, p.seek_to)
	encode_opt_sound_data(mut w, p.pause)
	encode_opt_sound_data(mut w, p.resume)
}

pub fn (mut p ClientBoundUpdateSoundDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_sound_handle = r.le_i64()!
	if r.bool()! {
		p.stop = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.set_volume = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.set_pitch = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.fade = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.seek_to = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.pause = types.SoundData.decode(mut r)!
	}
	if r.bool()! {
		p.resume = types.SoundData.decode(mut r)!
	}
}

fn encode_opt_sound_data(mut w serializer.Writer, v ?types.SoundData) {
	if val := v {
		w.bool(true)
		val.encode(mut w)
	} else {
		w.bool(false)
	}
}
