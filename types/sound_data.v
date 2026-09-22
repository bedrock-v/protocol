module types

import protocol.serializer

pub struct SoundDataStop {}

pub struct SoundDataSetVolume {
pub mut:
	volume f32
}

pub struct SoundDataSetPitch {
pub mut:
	pitch f32
}

pub struct SoundDataFade {
pub mut:
	duration      f32
	target_volume f32
}

pub struct SoundDataSeekTo {
pub mut:
	seconds f32
}

pub struct SoundDataPause {}

pub struct SoundDataResume {}

pub type SoundData = SoundDataFade
	| SoundDataPause
	| SoundDataResume
	| SoundDataSeekTo
	| SoundDataSetPitch
	| SoundDataSetVolume
	| SoundDataStop

pub fn (t SoundData) encode(mut w serializer.Writer) {
	match t {
		SoundDataStop {
			w.write_varuint32(0)
		}
		SoundDataSetVolume {
			w.write_varuint32(1)
			w.le_f32(t.volume)
		}
		SoundDataSetPitch {
			w.write_varuint32(2)
			w.le_f32(t.pitch)
		}
		SoundDataFade {
			w.write_varuint32(3)
			w.le_f32(t.duration)
			w.le_f32(t.target_volume)
		}
		SoundDataSeekTo {
			w.write_varuint32(4)
			w.le_f32(t.seconds)
		}
		SoundDataPause {
			w.write_varuint32(5)
		}
		SoundDataResume {
			w.write_varuint32(6)
		}
	}
}

pub fn SoundData.decode(mut r serializer.Reader) !SoundData {
	d := r.read_varuint32()!
	match d {
		0 {
			return SoundDataStop{}
		}
		1 {
			return SoundDataSetVolume{
				volume: r.le_f32()!
			}
		}
		2 {
			return SoundDataSetPitch{
				pitch: r.le_f32()!
			}
		}
		3 {
			return SoundDataFade{
				duration:      r.le_f32()!
				target_volume: r.le_f32()!
			}
		}
		4 {
			return SoundDataSeekTo{
				seconds: r.le_f32()!
			}
		}
		5 {
			return SoundDataPause{}
		}
		6 {
			return SoundDataResume{}
		}
		else {
			return error('invalid SoundData ${d}')
		}
	}
}
