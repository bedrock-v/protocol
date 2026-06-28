module protocol

import serializer

pub struct BiomeSurfaceMaterial {
pub mut:
	top_block        int
	mid_block        int
	sea_floor_block  int
	foundation_block int
	sea_block        int
	sea_floor_depth  int
}

pub struct FloatRange {
pub mut:
	min f32
	max f32
}

pub struct NoiseBlockSpecifier {
pub mut:
	noise     string
	threshold f32
	range     FloatRange
	block     u32
}

pub struct NoiseDescriptor {
pub mut:
	name         string
	first_octave int
	amplitudes   []f32
}

pub struct BiomeNoiseGradientSurface {
pub mut:
	non_replaceable_blocks []u32
	gradient_blocks        []NoiseBlockSpecifier
	noise                  NoiseDescriptor
}

pub struct BiomeMesaSurface {
pub mut:
	clay_material      u32
	hard_clay_material u32
	bryce_pillars      bool
	has_forest         bool
}

pub struct BiomeCappedSurface {
pub mut:
	floor_blocks         []int
	ceiling_blocks       []int
	has_sea_block        bool
	sea_block            u32
	has_foundation_block bool
	foundation_block     u32
	has_beach_block      bool
	beach_block          u32
}

pub struct BiomeSurfaceBuilder {
pub mut:
	has_surface_materials         bool
	surface_materials             BiomeSurfaceMaterial
	has_default_overworld_surface bool
	has_swamp_surface             bool
	has_frozen_ocean_surface      bool
	has_end_surface               bool
	has_mesa_surface              bool
	mesa_surface                  BiomeMesaSurface
	has_capped_surface            bool
	capped_surface                BiomeCappedSurface
	has_noise_gradient_surface    bool
	noise_gradient_surface        BiomeNoiseGradientSurface
}

pub struct BiomeWeight {
pub mut:
	biome  i16
	weight u32
}

pub struct BiomeTemperatureWeight {
pub mut:
	temperature int
	weight      u32
}

pub struct BiomeConditionalTransformation {
pub mut:
	weighted_biomes        []BiomeWeight
	condition_json         i16
	min_passing_neighbours u32
}

pub struct BiomeOverworldRules {
pub mut:
	hills_transformations          []BiomeWeight
	mutate_transformations         []BiomeWeight
	river_transformations          []BiomeWeight
	shore_transformations          []BiomeWeight
	pre_hills_edge_transformations []BiomeConditionalTransformation
	post_shore_edge_transformations []BiomeConditionalTransformation
	climate_transformations        []BiomeTemperatureWeight
}

pub struct BiomeMultiNoiseRules {
pub mut:
	temperature f32
	humidity    f32
	altitude    f32
	weirdness   f32
	weight      f32
}

pub struct BiomeReplacementData {
pub mut:
	biome                 i16
	dimension             i16
	target_biomes         []i16
	amount                f32
	noise_frequency_scale f32
	replacement_index     u32
}

pub struct BiomeCoordinate {
pub mut:
	min_value_type int
	min_value      i16
	max_value_type int
	max_value      i16
	grid_offset    u32
	grid_step_size u32
	distribution   int
}

pub struct BiomeScatterParameter {
pub mut:
	coordinates        []BiomeCoordinate
	evaluation_order   int
	chance_percent_type int
	chance_percent     i16
	chance_numerator   int
	chance_denominator int
	iterations_type    int
	iterations         i16
}

pub struct BiomeConsolidatedFeature {
pub mut:
	scatter          BiomeScatterParameter
	feature          i16
	identifier       i16
	pass             i16
	can_use_internal bool
}

pub struct BiomeElementData {
pub mut:
	noise_frequency_scale f32
	noise_lower_bound     f32
	noise_upper_bound     f32
	height_min_type       int
	height_min            i16
	height_max_type       int
	height_max            i16
	adjusted_materials    BiomeSurfaceMaterial
}

pub struct BiomeMountainParameters {
pub mut:
	steep_block       int
	north_slopes      bool
	south_slopes      bool
	west_slopes       bool
	east_slopes       bool
	top_slide_enabled bool
}

pub struct BiomeClimate {
pub mut:
	temperature           f32
	downfall              f32
	snow_accumulation_min f32
	snow_accumulation_max f32
}

pub struct BiomeChunkGeneration {
pub mut:
	has_climate                  bool
	climate                      BiomeClimate
	has_consolidated_features    bool
	consolidated_features        []BiomeConsolidatedFeature
	has_mountain_parameters      bool
	mountain_parameters          BiomeMountainParameters
	has_surface_material_adjustments bool
	surface_material_adjustments []BiomeElementData
	has_overworld_rules          bool
	overworld_rules              BiomeOverworldRules
	has_multi_noise_rules        bool
	multi_noise_rules            BiomeMultiNoiseRules
	has_legacy_rules             bool
	legacy_rules                 []BiomeConditionalTransformation
	has_replacements_data        bool
	replacements_data            []BiomeReplacementData
	has_village_type             bool
	village_type                 u8
	has_surface_builder          bool
	surface_builder              BiomeSurfaceBuilder
	has_subsurface_builder       bool
	subsurface_builder           BiomeSurfaceBuilder
}

pub struct BiomeDefinition {
pub mut:
	name_index        i16
	biome_id          i16
	temperature       f32
	downfall          f32
	foliage_snow      f32
	depth             f32
	scale             f32
	map_water_colour  int
	rain              bool
	has_tags          bool
	tags              []u16
	has_chunk_generation bool
	chunk_generation  BiomeChunkGeneration
}

pub struct BiomeDefinitionListPacket {
pub mut:
	biome_definitions []BiomeDefinition
	string_list       []string
}

pub fn (p &BiomeDefinitionListPacket) pid() u16 {
	return biome_definition_list_packet
}

pub fn (p &BiomeDefinitionListPacket) name() string {
	return 'BiomeDefinitionListPacket'
}

pub fn (p &BiomeDefinitionListPacket) can_be_sent_before_login() bool {
	return false
}

fn read_biome_surface_material(mut r serializer.Reader) !BiomeSurfaceMaterial {
	return BiomeSurfaceMaterial{
		top_block:        r.le_i32()!
		mid_block:        r.le_i32()!
		sea_floor_block:  r.le_i32()!
		foundation_block: r.le_i32()!
		sea_block:        r.le_i32()!
		sea_floor_depth:  r.le_i32()!
	}
}

fn write_biome_surface_material(mut w serializer.Writer, m BiomeSurfaceMaterial) {
	w.le_i32(m.top_block)
	w.le_i32(m.mid_block)
	w.le_i32(m.sea_floor_block)
	w.le_i32(m.foundation_block)
	w.le_i32(m.sea_block)
	w.le_i32(m.sea_floor_depth)
}

fn read_noise_descriptor(mut r serializer.Reader) !NoiseDescriptor {
	mut n := NoiseDescriptor{
		name:         r.read_string()!
		first_octave: r.le_i32()!
	}
	count := r.read_varuint32()!
	n.amplitudes = []f32{}
	for _ in 0 .. count {
		n.amplitudes << r.le_f32()!
	}
	return n
}

fn write_noise_descriptor(mut w serializer.Writer, n NoiseDescriptor) {
	w.write_string(n.name)
	w.le_i32(n.first_octave)
	w.write_varuint32(u32(n.amplitudes.len))
	for a in n.amplitudes {
		w.le_f32(a)
	}
}

fn read_noise_block_specifier(mut r serializer.Reader) !NoiseBlockSpecifier {
	mut s := NoiseBlockSpecifier{
		noise:     r.read_string()!
		threshold: r.le_f32()!
	}
	s.range = FloatRange{
		min: r.le_f32()!
		max: r.le_f32()!
	}
	s.block = r.le_u32()!
	return s
}

fn write_noise_block_specifier(mut w serializer.Writer, s NoiseBlockSpecifier) {
	w.write_string(s.noise)
	w.le_f32(s.threshold)
	w.le_f32(s.range.min)
	w.le_f32(s.range.max)
	w.le_u32(s.block)
}

fn read_noise_gradient_surface(mut r serializer.Reader) !BiomeNoiseGradientSurface {
	mut g := BiomeNoiseGradientSurface{}
	nr_count := r.read_varuint32()!
	g.non_replaceable_blocks = []u32{}
	for _ in 0 .. nr_count {
		g.non_replaceable_blocks << r.le_u32()!
	}
	gb_count := r.read_varuint32()!
	g.gradient_blocks = []NoiseBlockSpecifier{}
	for _ in 0 .. gb_count {
		g.gradient_blocks << read_noise_block_specifier(mut r)!
	}
	g.noise = read_noise_descriptor(mut r)!
	return g
}

fn write_noise_gradient_surface(mut w serializer.Writer, g BiomeNoiseGradientSurface) {
	w.write_varuint32(u32(g.non_replaceable_blocks.len))
	for b in g.non_replaceable_blocks {
		w.le_u32(b)
	}
	w.write_varuint32(u32(g.gradient_blocks.len))
	for s in g.gradient_blocks {
		write_noise_block_specifier(mut w, s)
	}
	write_noise_descriptor(mut w, g.noise)
}

fn read_mesa_surface(mut r serializer.Reader) !BiomeMesaSurface {
	return BiomeMesaSurface{
		clay_material:      r.le_u32()!
		hard_clay_material: r.le_u32()!
		bryce_pillars:      r.bool()!
		has_forest:         r.bool()!
	}
}

fn write_mesa_surface(mut w serializer.Writer, m BiomeMesaSurface) {
	w.le_u32(m.clay_material)
	w.le_u32(m.hard_clay_material)
	w.bool(m.bryce_pillars)
	w.bool(m.has_forest)
}

fn read_capped_surface(mut r serializer.Reader) !BiomeCappedSurface {
	mut c := BiomeCappedSurface{}
	floor_count := r.read_varuint32()!
	c.floor_blocks = []int{}
	for _ in 0 .. floor_count {
		c.floor_blocks << r.le_i32()!
	}
	ceil_count := r.read_varuint32()!
	c.ceiling_blocks = []int{}
	for _ in 0 .. ceil_count {
		c.ceiling_blocks << r.le_i32()!
	}
	if r.bool()! {
		c.has_sea_block = true
		c.sea_block = r.le_u32()!
	}
	if r.bool()! {
		c.has_foundation_block = true
		c.foundation_block = r.le_u32()!
	}
	if r.bool()! {
		c.has_beach_block = true
		c.beach_block = r.le_u32()!
	}
	return c
}

fn write_capped_surface(mut w serializer.Writer, c BiomeCappedSurface) {
	w.write_varuint32(u32(c.floor_blocks.len))
	for b in c.floor_blocks {
		w.le_i32(b)
	}
	w.write_varuint32(u32(c.ceiling_blocks.len))
	for b in c.ceiling_blocks {
		w.le_i32(b)
	}
	if c.has_sea_block {
		w.bool(true)
		w.le_u32(c.sea_block)
	} else {
		w.bool(false)
	}
	if c.has_foundation_block {
		w.bool(true)
		w.le_u32(c.foundation_block)
	} else {
		w.bool(false)
	}
	if c.has_beach_block {
		w.bool(true)
		w.le_u32(c.beach_block)
	} else {
		w.bool(false)
	}
}

fn read_surface_builder(mut r serializer.Reader) !BiomeSurfaceBuilder {
	mut b := BiomeSurfaceBuilder{}
	if r.bool()! {
		b.has_surface_materials = true
		b.surface_materials = read_biome_surface_material(mut r)!
	}
	b.has_default_overworld_surface = r.bool()!
	b.has_swamp_surface = r.bool()!
	b.has_frozen_ocean_surface = r.bool()!
	b.has_end_surface = r.bool()!
	if r.bool()! {
		b.has_mesa_surface = true
		b.mesa_surface = read_mesa_surface(mut r)!
	}
	if r.bool()! {
		b.has_capped_surface = true
		b.capped_surface = read_capped_surface(mut r)!
	}
	if r.bool()! {
		b.has_noise_gradient_surface = true
		b.noise_gradient_surface = read_noise_gradient_surface(mut r)!
	}
	return b
}

fn write_surface_builder(mut w serializer.Writer, b BiomeSurfaceBuilder) {
	if b.has_surface_materials {
		w.bool(true)
		write_biome_surface_material(mut w, b.surface_materials)
	} else {
		w.bool(false)
	}
	w.bool(b.has_default_overworld_surface)
	w.bool(b.has_swamp_surface)
	w.bool(b.has_frozen_ocean_surface)
	w.bool(b.has_end_surface)
	if b.has_mesa_surface {
		w.bool(true)
		write_mesa_surface(mut w, b.mesa_surface)
	} else {
		w.bool(false)
	}
	if b.has_capped_surface {
		w.bool(true)
		write_capped_surface(mut w, b.capped_surface)
	} else {
		w.bool(false)
	}
	if b.has_noise_gradient_surface {
		w.bool(true)
		write_noise_gradient_surface(mut w, b.noise_gradient_surface)
	} else {
		w.bool(false)
	}
}

fn read_biome_weight_list(mut r serializer.Reader) ![]BiomeWeight {
	count := r.read_varuint32()!
	mut out := []BiomeWeight{}
	for _ in 0 .. count {
		out << BiomeWeight{
			biome:  r.le_i16()!
			weight: r.le_u32()!
		}
	}
	return out
}

fn write_biome_weight_list(mut w serializer.Writer, list []BiomeWeight) {
	w.write_varuint32(u32(list.len))
	for e in list {
		w.le_i16(e.biome)
		w.le_u32(e.weight)
	}
}

fn read_conditional_transformation_list(mut r serializer.Reader) ![]BiomeConditionalTransformation {
	count := r.read_varuint32()!
	mut out := []BiomeConditionalTransformation{}
	for _ in 0 .. count {
		mut c := BiomeConditionalTransformation{
			weighted_biomes: read_biome_weight_list(mut r)!
		}
		c.condition_json = r.le_i16()!
		c.min_passing_neighbours = r.le_u32()!
		out << c
	}
	return out
}

fn write_conditional_transformation_list(mut w serializer.Writer, list []BiomeConditionalTransformation) {
	w.write_varuint32(u32(list.len))
	for c in list {
		write_biome_weight_list(mut w, c.weighted_biomes)
		w.le_i16(c.condition_json)
		w.le_u32(c.min_passing_neighbours)
	}
}

fn read_overworld_rules(mut r serializer.Reader) !BiomeOverworldRules {
	mut o := BiomeOverworldRules{
		hills_transformations:           read_biome_weight_list(mut r)!
		mutate_transformations:          read_biome_weight_list(mut r)!
		river_transformations:           read_biome_weight_list(mut r)!
		shore_transformations:           read_biome_weight_list(mut r)!
		pre_hills_edge_transformations:  read_conditional_transformation_list(mut r)!
		post_shore_edge_transformations: read_conditional_transformation_list(mut r)!
	}
	ct_count := r.read_varuint32()!
	o.climate_transformations = []BiomeTemperatureWeight{}
	for _ in 0 .. ct_count {
		o.climate_transformations << BiomeTemperatureWeight{
			temperature: r.read_varint32()!
			weight:      r.le_u32()!
		}
	}
	return o
}

fn write_overworld_rules(mut w serializer.Writer, o BiomeOverworldRules) {
	write_biome_weight_list(mut w, o.hills_transformations)
	write_biome_weight_list(mut w, o.mutate_transformations)
	write_biome_weight_list(mut w, o.river_transformations)
	write_biome_weight_list(mut w, o.shore_transformations)
	write_conditional_transformation_list(mut w, o.pre_hills_edge_transformations)
	write_conditional_transformation_list(mut w, o.post_shore_edge_transformations)
	w.write_varuint32(u32(o.climate_transformations.len))
	for c in o.climate_transformations {
		w.write_varint32(c.temperature)
		w.le_u32(c.weight)
	}
}

fn read_replacement_data_list(mut r serializer.Reader) ![]BiomeReplacementData {
	count := r.read_varuint32()!
	mut out := []BiomeReplacementData{}
	for _ in 0 .. count {
		mut d := BiomeReplacementData{
			biome:     r.le_i16()!
			dimension: r.le_i16()!
		}
		tb_count := r.read_varuint32()!
		d.target_biomes = []i16{}
		for _ in 0 .. tb_count {
			d.target_biomes << r.le_i16()!
		}
		d.amount = r.le_f32()!
		d.noise_frequency_scale = r.le_f32()!
		d.replacement_index = r.le_u32()!
		out << d
	}
	return out
}

fn write_replacement_data_list(mut w serializer.Writer, list []BiomeReplacementData) {
	w.write_varuint32(u32(list.len))
	for d in list {
		w.le_i16(d.biome)
		w.le_i16(d.dimension)
		w.write_varuint32(u32(d.target_biomes.len))
		for t in d.target_biomes {
			w.le_i16(t)
		}
		w.le_f32(d.amount)
		w.le_f32(d.noise_frequency_scale)
		w.le_u32(d.replacement_index)
	}
}

fn read_biome_coordinate(mut r serializer.Reader) !BiomeCoordinate {
	return BiomeCoordinate{
		min_value_type: r.read_varint32()!
		min_value:      r.le_i16()!
		max_value_type: r.read_varint32()!
		max_value:      r.le_i16()!
		grid_offset:    r.le_u32()!
		grid_step_size: r.le_u32()!
		distribution:   r.read_varint32()!
	}
}

fn write_biome_coordinate(mut w serializer.Writer, c BiomeCoordinate) {
	w.write_varint32(c.min_value_type)
	w.le_i16(c.min_value)
	w.write_varint32(c.max_value_type)
	w.le_i16(c.max_value)
	w.le_u32(c.grid_offset)
	w.le_u32(c.grid_step_size)
	w.write_varint32(c.distribution)
}

fn read_scatter_parameter(mut r serializer.Reader) !BiomeScatterParameter {
	mut s := BiomeScatterParameter{}
	coord_count := r.read_varuint32()!
	s.coordinates = []BiomeCoordinate{}
	for _ in 0 .. coord_count {
		s.coordinates << read_biome_coordinate(mut r)!
	}
	s.evaluation_order = r.read_varint32()!
	s.chance_percent_type = r.read_varint32()!
	s.chance_percent = r.le_i16()!
	s.chance_numerator = r.le_i32()!
	s.chance_denominator = r.le_i32()!
	s.iterations_type = r.read_varint32()!
	s.iterations = r.le_i16()!
	return s
}

fn write_scatter_parameter(mut w serializer.Writer, s BiomeScatterParameter) {
	w.write_varuint32(u32(s.coordinates.len))
	for c in s.coordinates {
		write_biome_coordinate(mut w, c)
	}
	w.write_varint32(s.evaluation_order)
	w.write_varint32(s.chance_percent_type)
	w.le_i16(s.chance_percent)
	w.le_i32(s.chance_numerator)
	w.le_i32(s.chance_denominator)
	w.write_varint32(s.iterations_type)
	w.le_i16(s.iterations)
}

fn read_consolidated_feature_list(mut r serializer.Reader) ![]BiomeConsolidatedFeature {
	count := r.read_varuint32()!
	mut out := []BiomeConsolidatedFeature{}
	for _ in 0 .. count {
		mut f := BiomeConsolidatedFeature{
			scatter: read_scatter_parameter(mut r)!
		}
		f.feature = r.le_i16()!
		f.identifier = r.le_i16()!
		f.pass = r.le_i16()!
		f.can_use_internal = r.bool()!
		out << f
	}
	return out
}

fn write_consolidated_feature_list(mut w serializer.Writer, list []BiomeConsolidatedFeature) {
	w.write_varuint32(u32(list.len))
	for f in list {
		write_scatter_parameter(mut w, f.scatter)
		w.le_i16(f.feature)
		w.le_i16(f.identifier)
		w.le_i16(f.pass)
		w.bool(f.can_use_internal)
	}
}

fn read_element_data_list(mut r serializer.Reader) ![]BiomeElementData {
	count := r.read_varuint32()!
	mut out := []BiomeElementData{}
	for _ in 0 .. count {
		mut e := BiomeElementData{
			noise_frequency_scale: r.le_f32()!
			noise_lower_bound:     r.le_f32()!
			noise_upper_bound:     r.le_f32()!
			height_min_type:       r.read_varint32()!
			height_min:            r.le_i16()!
			height_max_type:       r.read_varint32()!
			height_max:            r.le_i16()!
		}
		e.adjusted_materials = read_biome_surface_material(mut r)!
		out << e
	}
	return out
}

fn write_element_data_list(mut w serializer.Writer, list []BiomeElementData) {
	w.write_varuint32(u32(list.len))
	for e in list {
		w.le_f32(e.noise_frequency_scale)
		w.le_f32(e.noise_lower_bound)
		w.le_f32(e.noise_upper_bound)
		w.write_varint32(e.height_min_type)
		w.le_i16(e.height_min)
		w.write_varint32(e.height_max_type)
		w.le_i16(e.height_max)
		write_biome_surface_material(mut w, e.adjusted_materials)
	}
}

fn read_chunk_generation(mut r serializer.Reader) !BiomeChunkGeneration {
	mut g := BiomeChunkGeneration{}
	if r.bool()! {
		g.has_climate = true
		g.climate = BiomeClimate{
			temperature:           r.le_f32()!
			downfall:              r.le_f32()!
			snow_accumulation_min: r.le_f32()!
			snow_accumulation_max: r.le_f32()!
		}
	}
	if r.bool()! {
		g.has_consolidated_features = true
		g.consolidated_features = read_consolidated_feature_list(mut r)!
	}
	if r.bool()! {
		g.has_mountain_parameters = true
		g.mountain_parameters = BiomeMountainParameters{
			steep_block:       r.le_i32()!
			north_slopes:      r.bool()!
			south_slopes:      r.bool()!
			west_slopes:       r.bool()!
			east_slopes:       r.bool()!
			top_slide_enabled: r.bool()!
		}
	}
	if r.bool()! {
		g.has_surface_material_adjustments = true
		g.surface_material_adjustments = read_element_data_list(mut r)!
	}
	if r.bool()! {
		g.has_overworld_rules = true
		g.overworld_rules = read_overworld_rules(mut r)!
	}
	if r.bool()! {
		g.has_multi_noise_rules = true
		g.multi_noise_rules = BiomeMultiNoiseRules{
			temperature: r.le_f32()!
			humidity:    r.le_f32()!
			altitude:    r.le_f32()!
			weirdness:   r.le_f32()!
			weight:      r.le_f32()!
		}
	}
	if r.bool()! {
		g.has_legacy_rules = true
		g.legacy_rules = read_conditional_transformation_list(mut r)!
	}
	if r.bool()! {
		g.has_replacements_data = true
		g.replacements_data = read_replacement_data_list(mut r)!
	}
	if r.bool()! {
		g.has_village_type = true
		g.village_type = r.u8()!
	}
	if r.bool()! {
		g.has_surface_builder = true
		g.surface_builder = read_surface_builder(mut r)!
	}
	if r.bool()! {
		g.has_subsurface_builder = true
		g.subsurface_builder = read_surface_builder(mut r)!
	}
	return g
}

fn write_chunk_generation(mut w serializer.Writer, g BiomeChunkGeneration) {
	if g.has_climate {
		w.bool(true)
		w.le_f32(g.climate.temperature)
		w.le_f32(g.climate.downfall)
		w.le_f32(g.climate.snow_accumulation_min)
		w.le_f32(g.climate.snow_accumulation_max)
	} else {
		w.bool(false)
	}
	if g.has_consolidated_features {
		w.bool(true)
		write_consolidated_feature_list(mut w, g.consolidated_features)
	} else {
		w.bool(false)
	}
	if g.has_mountain_parameters {
		w.bool(true)
		w.le_i32(g.mountain_parameters.steep_block)
		w.bool(g.mountain_parameters.north_slopes)
		w.bool(g.mountain_parameters.south_slopes)
		w.bool(g.mountain_parameters.west_slopes)
		w.bool(g.mountain_parameters.east_slopes)
		w.bool(g.mountain_parameters.top_slide_enabled)
	} else {
		w.bool(false)
	}
	if g.has_surface_material_adjustments {
		w.bool(true)
		write_element_data_list(mut w, g.surface_material_adjustments)
	} else {
		w.bool(false)
	}
	if g.has_overworld_rules {
		w.bool(true)
		write_overworld_rules(mut w, g.overworld_rules)
	} else {
		w.bool(false)
	}
	if g.has_multi_noise_rules {
		w.bool(true)
		w.le_f32(g.multi_noise_rules.temperature)
		w.le_f32(g.multi_noise_rules.humidity)
		w.le_f32(g.multi_noise_rules.altitude)
		w.le_f32(g.multi_noise_rules.weirdness)
		w.le_f32(g.multi_noise_rules.weight)
	} else {
		w.bool(false)
	}
	if g.has_legacy_rules {
		w.bool(true)
		write_conditional_transformation_list(mut w, g.legacy_rules)
	} else {
		w.bool(false)
	}
	if g.has_replacements_data {
		w.bool(true)
		write_replacement_data_list(mut w, g.replacements_data)
	} else {
		w.bool(false)
	}
	if g.has_village_type {
		w.bool(true)
		w.u8(g.village_type)
	} else {
		w.bool(false)
	}
	if g.has_surface_builder {
		w.bool(true)
		write_surface_builder(mut w, g.surface_builder)
	} else {
		w.bool(false)
	}
	if g.has_subsurface_builder {
		w.bool(true)
		write_surface_builder(mut w, g.subsurface_builder)
	} else {
		w.bool(false)
	}
}

fn read_biome_definition(mut r serializer.Reader) !BiomeDefinition {
	mut d := BiomeDefinition{
		name_index:       r.le_i16()!
		biome_id:         r.le_i16()!
		temperature:      r.le_f32()!
		downfall:         r.le_f32()!
		foliage_snow:     r.le_f32()!
		depth:            r.le_f32()!
		scale:            r.le_f32()!
		map_water_colour: r.le_i32()!
		rain:             r.bool()!
	}
	if r.bool()! {
		d.has_tags = true
		tag_count := r.read_varuint32()!
		d.tags = []u16{}
		for _ in 0 .. tag_count {
			d.tags << r.le_u16()!
		}
	}
	if r.bool()! {
		d.has_chunk_generation = true
		d.chunk_generation = read_chunk_generation(mut r)!
	}
	return d
}

fn write_biome_definition(mut w serializer.Writer, d BiomeDefinition) {
	w.le_i16(d.name_index)
	w.le_i16(d.biome_id)
	w.le_f32(d.temperature)
	w.le_f32(d.downfall)
	w.le_f32(d.foliage_snow)
	w.le_f32(d.depth)
	w.le_f32(d.scale)
	w.le_i32(d.map_water_colour)
	w.bool(d.rain)
	if d.has_tags {
		w.bool(true)
		w.write_varuint32(u32(d.tags.len))
		for t in d.tags {
			w.le_u16(t)
		}
	} else {
		w.bool(false)
	}
	if d.has_chunk_generation {
		w.bool(true)
		write_chunk_generation(mut w, d.chunk_generation)
	} else {
		w.bool(false)
	}
}

pub fn (mut p BiomeDefinitionListPacket) decode_payload(mut r serializer.Reader) ! {
	def_count := r.read_varuint32()!
	p.biome_definitions = []BiomeDefinition{}
	for _ in 0 .. def_count {
		p.biome_definitions << read_biome_definition(mut r)!
	}
	str_count := r.read_varuint32()!
	p.string_list = []string{}
	for _ in 0 .. str_count {
		p.string_list << r.read_string()!
	}
}

pub fn (p &BiomeDefinitionListPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.biome_definitions.len))
	for d in p.biome_definitions {
		write_biome_definition(mut w, d)
	}
	w.write_varuint32(u32(p.string_list.len))
	for s in p.string_list {
		w.write_string(s)
	}
}
