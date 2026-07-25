module types

import serializer
import version.v388.types as types_388
import version.v419.types as types_419

pub struct PersonaPieceData {
pub mut:
	piece_id   string
	piece_type string
	pack_id    string
	is_default bool
	product_id string
}

pub struct PersonaPieceTintData {
pub mut:
	piece_type string
	colors     []string
}

pub struct SerializedSkin {
pub mut:
	skin_id                      string
	play_fab_id                  string
	skin_resource_patch          string
	skin_data                    types_388.ImageData
	animations                   []types_419.AnimationData
	cape_data                    types_388.ImageData
	geometry_data                string
	geometry_data_engine_version string
	animation_data               string
	cape_id                      string
	full_skin_id                 string
	arm_size                     string
	skin_color                   string
	persona_pieces               []PersonaPieceData
	tint_colors                  []PersonaPieceTintData
	premium                      bool
	persona                      bool
	cape_on_classic              bool
	primary_user                 bool
	overriding_player_appearance bool
}

pub fn (t SerializedSkin) encode(mut w serializer.Writer) {
	w.write_string(t.skin_id)
	w.write_string(t.play_fab_id)
	w.write_string(t.skin_resource_patch)
	t.skin_data.encode(mut w)
	w.le_i32(i32(t.animations.len))
	for animation in t.animations {
		animation.encode(mut w)
	}
	t.cape_data.encode(mut w)
	w.write_string(t.geometry_data)
	w.write_string(t.geometry_data_engine_version)
	w.write_string(t.animation_data)
	w.write_string(t.cape_id)
	w.write_string(t.full_skin_id)
	w.write_string(t.arm_size)
	w.write_string(t.skin_color)
	w.le_i32(i32(t.persona_pieces.len))
	for piece in t.persona_pieces {
		w.write_string(piece.piece_id)
		w.write_string(piece.piece_type)
		w.write_string(piece.pack_id)
		w.bool(piece.is_default)
		w.write_string(piece.product_id)
	}
	w.le_i32(i32(t.tint_colors.len))
	for tint in t.tint_colors {
		w.write_string(tint.piece_type)
		w.le_i32(i32(tint.colors.len))
		for color in tint.colors {
			w.write_string(color)
		}
	}
	w.bool(t.premium)
	w.bool(t.persona)
	w.bool(t.cape_on_classic)
	w.bool(t.primary_user)
	w.bool(t.overriding_player_appearance)
}

pub fn SerializedSkin.decode(mut r serializer.Reader) !SerializedSkin {
	mut t := SerializedSkin{}
	t.skin_id = r.read_string()!
	t.play_fab_id = r.read_string()!
	t.skin_resource_patch = r.read_string()!
	t.skin_data = types_388.ImageData.decode(mut r)!
	animation_count := int(r.le_i32()!)
	t.animations = []types_419.AnimationData{cap: animation_count}
	for _ in 0 .. animation_count {
		t.animations << types_419.AnimationData.decode(mut r)!
	}
	t.cape_data = types_388.ImageData.decode(mut r)!
	t.geometry_data = r.read_string()!
	t.geometry_data_engine_version = r.read_string()!
	t.animation_data = r.read_string()!
	t.cape_id = r.read_string()!
	t.full_skin_id = r.read_string()!
	t.arm_size = r.read_string()!
	t.skin_color = r.read_string()!
	piece_count := int(r.le_i32()!)
	t.persona_pieces = []PersonaPieceData{cap: piece_count}
	for _ in 0 .. piece_count {
		t.persona_pieces << PersonaPieceData{
			piece_id:   r.read_string()!
			piece_type: r.read_string()!
			pack_id:    r.read_string()!
			is_default: r.bool()!
			product_id: r.read_string()!
		}
	}
	tint_count := int(r.le_i32()!)
	t.tint_colors = []PersonaPieceTintData{cap: tint_count}
	for _ in 0 .. tint_count {
		mut tint := PersonaPieceTintData{
			piece_type: r.read_string()!
		}
		color_count := int(r.le_i32()!)
		tint.colors = []string{cap: color_count}
		for _ in 0 .. color_count {
			tint.colors << r.read_string()!
		}
		t.tint_colors << tint
	}
	t.premium = r.bool()!
	t.persona = r.bool()!
	t.cape_on_classic = r.bool()!
	t.primary_user = r.bool()!
	t.overriding_player_appearance = r.bool()!
	return t
}
