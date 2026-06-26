module types

pub struct SkinImage {
pub mut:
	width  u32
	height u32
	data   string
}

pub struct SkinAnimation {
pub mut:
	image           SkinImage
	type            u32
	frames          f32
	expression_type u32
}

pub struct PersonaSkinPiece {
pub mut:
	piece_id   string
	piece_type string
	pack_id    string
	is_default bool
	product_id string
}

pub struct PersonaPieceTintColor {
pub mut:
	piece_type string
	colors     []string
}

pub struct SkinData {
pub mut:
	skin_id               string
	play_fab_id           string
	resource_patch        string
	skin_image            SkinImage
	animations            []SkinAnimation
	cape_image            SkinImage
	geometry_data         string
	geometry_data_version string
	animation_data        string
	cape_id               string
	full_skin_id          string
	arm_size              string
	skin_color            string
	persona_pieces        []PersonaSkinPiece
	piece_tint_colors     []PersonaPieceTintColor
	premium               bool
	persona               bool
	cape_on_classic       bool
	is_primary_user       bool
	override              bool
}
