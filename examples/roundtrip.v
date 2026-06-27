module main

import src as protocol
import src.serializer
import src.types
import nbt

fn roundtrip(p protocol.Packet, mut pool protocol.PacketPool) !protocol.Packet {
	encoded := protocol.encode_packet_to_bytes(p)
	mut r := serializer.new_reader(encoded)
	return pool.decode(mut r)!
}

fn main() {
	mut pool := protocol.new_packet_pool()
	println('Registered packet count: ${pool.factories.len}')

	req := &protocol.RequestNetworkSettingsPacket{
		protocol_version: protocol.current_protocol
	}
	println('RequestNetworkSettings encoded: ${protocol.encode_packet_to_bytes(req).hex()}')
	d1 := roundtrip(req, mut pool)!
	if d1 is protocol.RequestNetworkSettingsPacket {
		assert d1.protocol_version == protocol.current_protocol
		println('  -> protocol_version=${d1.protocol_version} OK')
	}

	mov := &protocol.MoveActorAbsolutePacket{
		actor_runtime_id: 123456
		flags:            1
		position:         types.Vector3{10.5, 64.0, -20.25}
		pitch:            45.0
		yaw:              90.0
		head_yaw:         180.0
	}
	d2 := roundtrip(mov, mut pool)!
	if d2 is protocol.MoveActorAbsolutePacket {
		assert d2.actor_runtime_id == 123456
		assert d2.position.x == 10.5
		println('  -> MoveActorAbsolute runtime=${d2.actor_runtime_id} pos=(${d2.position.x},${d2.position.y},${d2.position.z}) OK')
	}

	info := &protocol.ResourcePackDataInfoPacket{
		pack_id:              'abc-123'
		max_chunk_size:       1048576
		chunk_count:          7
		compressed_pack_size: 9000000
		sha256:               'deadbeef'
		is_premium:           false
		pack_type:            1
	}
	d3 := roundtrip(info, mut pool)!
	if d3 is protocol.ResourcePackDataInfoPacket {
		assert d3.pack_id == 'abc-123'
		assert d3.compressed_pack_size == 9000000
		println('  -> ResourcePackDataInfo pack=${d3.pack_id} size=${d3.compressed_pack_size} OK')
	}

	pick := &protocol.ActorPickRequestPacket{
		actor_unique_id: -42
		hotbar_slot:     3
		add_user_data:   true
	}
	d4 := roundtrip(pick, mut pool)!
	if d4 is protocol.ActorPickRequestPacket {
		assert d4.actor_unique_id == -42
		assert d4.add_user_data == true
		println('  -> ActorPickRequest uid=${d4.actor_unique_id} OK')
	}

	disc := &protocol.DisconnectPacket{
		reason:  0
		message: 'closed'
	}
	d5 := roundtrip(disc, mut pool)!
	if d5 is protocol.DisconnectPacket {
		assert d5.message or { '' } == 'closed'
		println('  -> Disconnect message=${d5.message or { '<none>' }} OK')
	}

	equip := &protocol.MobEquipmentPacket{
		actor_runtime_id: 777
		item: types.ItemStackWrapper{
			stack_id: 5
			item_stack: types.ItemStack{
				id:               280
				meta:             0
				count:            64
				block_runtime_id: 0
				raw_extra_data:   [u8(1), 2, 3]
			}
		}
		inventory_slot: 0
		hotbar_slot:    0
		window_id:      0
	}
	d6 := roundtrip(equip, mut pool)!
	if d6 is protocol.MobEquipmentPacket {
		assert d6.item.item_stack.id == 280
		assert d6.item.item_stack.count == 64
		assert d6.item.stack_id == 5
		assert d6.item.item_stack.raw_extra_data == [u8(1), 2, 3]
		println('  -> MobEquipment item id=${d6.item.item_stack.id} count=${d6.item.item_stack.count} netId=${d6.item.stack_id} OK')
	}

	content := &protocol.InventoryContentPacket{
		window_id: 0
		items: [
			types.ItemStackWrapper{
				item_stack: types.ItemStack{
					id: 0
				}
			},
			types.item_stack_wrapper_legacy(types.ItemStack{
				id:    5
				count: 1
			}),
		]
		container_name: types.FullContainerName{
			container_id: 0
		}
		storage: types.ItemStackWrapper{
			item_stack: types.ItemStack{
				id: 0
			}
		}
	}
	d7 := roundtrip(content, mut pool)!
	if d7 is protocol.InventoryContentPacket {
		assert d7.items.len == 2
		assert d7.items[0].item_stack.is_null()
		assert d7.items[1].item_stack.id == 5
		println('  -> InventoryContent items=${d7.items.len} (slot0 null, slot1 id=${d7.items[1].item_stack.id}) OK')
	}

	creative := &protocol.CreativeContentPacket{
		groups: [
			types.CreativeGroupEntry{
				category_id:   1
				category_name: 'construction'
				icon:          types.ItemStack{
					id: 5
				}
			},
		]
		items: [
			types.CreativeItemEntry{
				entry_id: 1
				item:     types.ItemStack{
					id:    5
					count: 1
				}
				group_id: 0
			},
			types.CreativeItemEntry{
				entry_id: 2
				item:     types.ItemStack{
					id:    280
					count: 1
				}
				group_id: 0
			},
		]
	}
	d8 := roundtrip(creative, mut pool)!
	if d8 is protocol.CreativeContentPacket {
		assert d8.groups.len == 1
		assert d8.items.len == 2
		assert d8.groups[0].category_name == 'construction'
		assert d8.items[1].item.id == 280
		println('  -> CreativeContent groups=${d8.groups.len} items=${d8.items.len} OK')
	}

	mut tile_nbt := nbt.new_compound()
	tile_nbt.set('id', nbt.Tag('Chest'))
	tile_nbt.set('x', nbt.Tag(i32(10)))
	tile_nbt.set('CustomName', nbt.Tag('Treasure'))
	bad := &protocol.BlockActorDataPacket{
		block_position: types.BlockPosition{10, 64, -3}
		nbt:            nbt.RootTag{
			name: ''
			tag:  nbt.Tag(tile_nbt)
		}
	}
	d9 := roundtrip(bad, mut pool)!
	if d9 is protocol.BlockActorDataPacket {
		assert d9.block_position.y == 64
		dc := d9.nbt.tag as nbt.Compound
		assert (dc.get('id') or { nbt.Tag('') } as string) == 'Chest'
		assert (dc.get('x') or { nbt.Tag(i32(0)) } as i32) == 10
		name := dc.get('CustomName') or { nbt.Tag('') } as string
		println('  -> BlockActorData pos.y=${d9.block_position.y} nbt.id=Chest name=${name} OK')
	}

	sad := &protocol.SetActorDataPacket{
		actor_runtime_id: 555
		metadata: [
			types.MetadataEntry{
				key:   0
				value: types.MetadataProperty(types.MetaLong{
					value: i64(0x1234)
				})
			},
			types.MetadataEntry{
				key:   3
				value: types.MetadataProperty(types.MetaFloat{
					value: f32(1.5)
				})
			},
			types.MetadataEntry{
				key:   16
				value: types.MetadataProperty(types.MetaString{
					value: 'Slime'
				})
			},
		]
		synced_properties: types.PropertySyncData{
			int_properties:   [types.IntProperty{
				key:   1
				value: -7
			}]
			float_properties: [types.FloatProperty{
				key:   2
				value: f32(3.25)
			}]
		}
		tick: 999
	}
	d10 := roundtrip(sad, mut pool)!
	if d10 is protocol.SetActorDataPacket {
		assert d10.metadata.len == 3
		assert d10.tick == 999
		assert (d10.metadata[2].value as types.MetaString).value == 'Slime'
		assert d10.synced_properties.int_properties[0].value == -7
		println('  -> SetActorData meta=${d10.metadata.len} prop.int0=${d10.synced_properties.int_properties[0].value} tick=${d10.tick} OK')
	}

	addactor := &protocol.AddActorPacket{
		actor_unique_id:  100
		actor_runtime_id: 200
		type:             'minecraft:zombie'
		position:         types.Vector3{1, 2, 3}
		motion:           types.Vector3{0, 0, 0}
		pitch:            10.0
		yaw:              20.0
		head_yaw:         20.0
		body_yaw:         20.0
		attributes: [
			types.ActorAttribute{
				id:      'minecraft:health'
				min:     0.0
				current: 20.0
				max:     20.0
			},
		]
		metadata: [
			types.MetadataEntry{
				key:   0
				value: types.MetadataProperty(types.MetaByte{
					value: i8(1)
				})
			},
		]
		links: [
			types.EntityLink{
				from_actor_unique_id: 1
				to_actor_unique_id:   2
				type:                 0
				immediate:            true
				caused_by_rider:      false
			},
		]
	}
	d11 := roundtrip(addactor, mut pool)!
	if d11 is protocol.AddActorPacket {
		assert d11.type == 'minecraft:zombie'
		assert d11.attributes.len == 1
		assert d11.attributes[0].current == 20.0
		assert d11.links.len == 1
		assert d11.links[0].immediate == true
		println('  -> AddActor type=${d11.type} attrs=${d11.attributes.len} links=${d11.links.len} OK')
	}

	mp := &protocol.MovePlayerPacket{
		actor_runtime_id: 5
		position:         types.Vector3{8, 70, -2}
		pitch:            0.0
		yaw:              90.0
		head_yaw:         90.0
		mode:             protocol.move_player_mode_teleport
		on_ground:        true
		teleport_cause:   3
		teleport_item:    7
		tick:             42
	}
	d12 := roundtrip(mp, mut pool)!
	if d12 is protocol.MovePlayerPacket {
		assert d12.mode == protocol.move_player_mode_teleport
		assert d12.teleport_cause == 3
		assert d12.teleport_item == 7
		assert d12.tick == 42
		println('  -> MovePlayer mode=teleport cause=${d12.teleport_cause} item=${d12.teleport_item} tick=${d12.tick} OK')
	}

	cd := &protocol.ChangeDimensionPacket{
		dimension:         1
		position:          types.Vector3{0, 100, 0}
		respawn:           false
		loading_screen_id: u32(123)
	}
	d13 := roundtrip(cd, mut pool)!
	if d13 is protocol.ChangeDimensionPacket {
		assert d13.dimension == 1
		assert (d13.loading_screen_id or { u32(0) }) == 123
		println('  -> ChangeDimension dim=${d13.dimension} screen=${d13.loading_screen_id or { u32(0) }} OK')
	}

	ncpu := &protocol.NetworkChunkPublisherUpdatePacket{
		block_position: types.BlockPosition{0, 64, 0}
		radius:         80
		saved_chunks: [
			types.ChunkPosition{1, 2},
			types.ChunkPosition{-3, 4},
		]
	}
	d14 := roundtrip(ncpu, mut pool)!
	if d14 is protocol.NetworkChunkPublisherUpdatePacket {
		assert d14.radius == 80
		assert d14.saved_chunks.len == 2
		assert d14.saved_chunks[1].x == -3
		println('  -> NetworkChunkPublisherUpdate radius=${d14.radius} chunks=${d14.saved_chunks.len} OK')
	}

	grc := &protocol.GameRulesChangedPacket{
		game_rules: [
			types.GameRule{
				name:                 'doDaylightCycle'
				is_player_modifiable: true
				value:                types.GameRuleValue(types.BoolRule{
					value: true
				})
			},
			types.GameRule{
				name:                 'randomTickSpeed'
				is_player_modifiable: true
				value:                types.GameRuleValue(types.IntRule{
					value: u32(3)
				})
			},
		]
	}
	d15 := roundtrip(grc, mut pool)!
	if d15 is protocol.GameRulesChangedPacket {
		assert d15.game_rules.len == 2
		assert (d15.game_rules[0].value as types.BoolRule).value == true
		assert (d15.game_rules[1].value as types.IntRule).value == 3
		println('  -> GameRulesChanged rules=${d15.game_rules.len} (${d15.game_rules[0].name}, ${d15.game_rules[1].name}) OK')
	}

	mfr := &protocol.ModalFormResponsePacket{
		form_id:       7
		form_data:     '{"button":1}'
		cancel_reason: none
	}
	d16 := roundtrip(mfr, mut pool)!
	if d16 is protocol.ModalFormResponsePacket {
		assert d16.form_id == 7
		assert (d16.form_data or { '' }) == '{"button":1}'
		assert d16.cancel_reason == none
		println('  -> ModalFormResponse formId=${d16.form_id} data=${d16.form_data or { '<none>' }} OK')
	}

	st := &protocol.SetTitlePacket{
		type:                2
		text:                'Welcome'
		fade_in_time:        10
		stay_time:           70
		fade_out_time:       20
		xuid:                ''
		platform_online_id:  ''
		filtered_title_text: ''
	}
	d17 := roundtrip(st, mut pool)!
	if d17 is protocol.SetTitlePacket {
		assert d17.text == 'Welcome'
		assert d17.stay_time == 70
		println('  -> SetTitle text=${d17.text} stay=${d17.stay_time} OK')
	}

	ps := &protocol.PlaySoundPacket{
		sound_name:          'random.pop'
		position:            types.BlockPosition{80, 512, -16}
		volume:              1.0
		pitch:               1.25
		server_sound_handle: u64(42)
	}
	d18 := roundtrip(ps, mut pool)!
	if d18 is protocol.PlaySoundPacket {
		assert d18.sound_name == 'random.pop'
		assert d18.position.y == 512
		assert (d18.server_sound_handle or { u64(0) }) == 42
		println('  -> PlaySound name=${d18.sound_name} handle=${d18.server_sound_handle or { u64(0) }} OK')
	}

	use := &protocol.UpdateSoftEnumPacket{
		enum_name: 'players'
		values:    ['alice', 'bob']
		type:      0
	}
	d19 := roundtrip(use, mut pool)!
	if d19 is protocol.UpdateSoftEnumPacket {
		assert d19.values.len == 2
		assert d19.values[1] == 'bob'
		println('  -> UpdateSoftEnum name=${d19.enum_name} values=${d19.values.len} OK')
	}

	mad := &protocol.MoveActorDeltaPacket{
		actor_runtime_id: 9
		flags:            protocol.move_actor_delta_flag_has_x | protocol.move_actor_delta_flag_has_z | protocol.move_actor_delta_flag_has_yaw
		x_pos:            12.5
		z_pos:            -8.25
		yaw:              90.0
	}
	d20 := roundtrip(mad, mut pool)!
	if d20 is protocol.MoveActorDeltaPacket {
		assert d20.x_pos == 12.5
		assert d20.z_pos == -8.25
		assert d20.y_pos == 0.0
		println('  -> MoveActorDelta x=${d20.x_pos} z=${d20.z_pos} (y unset=${d20.y_pos}) OK')
	}

	di := &protocol.DeathInfoPacket{
		message_translation_key: 'death.attack.player'
		message_parameters:      ['Steve', 'Zombie']
	}
	d21 := roundtrip(di, mut pool)!
	if d21 is protocol.DeathInfoPacket {
		assert d21.message_parameters.len == 2
		assert d21.message_parameters[0] == 'Steve'
		println('  -> DeathInfo key=${d21.message_translation_key} params=${d21.message_parameters.len} OK')
	}

	lse := &protocol.LevelSoundEventPacket{
		sound:           'mob.zombie.say'
		position:        types.Vector3{1, 2, 3}
		extra_data:      -1
		entity_type:     'minecraft:zombie'
		is_baby_mob:     false
		actor_unique_id: 77
		fire_position:   none
	}
	d22 := roundtrip(lse, mut pool)!
	if d22 is protocol.LevelSoundEventPacket {
		assert d22.sound == 'mob.zombie.say'
		assert d22.fire_position == none
		println('  -> LevelSoundEvent sound=${d22.sound} fire=<none> OK')
	}

	be := &protocol.BookEditPacket{
		inventory_slot: 0
		type:           protocol.book_edit_type_sign_book
		title:          'My Book'
		author:         'Steve'
		xuid:           '123'
	}
	d23 := roundtrip(be, mut pool)!
	if d23 is protocol.BookEditPacket {
		assert d23.type == protocol.book_edit_type_sign_book
		assert d23.title == 'My Book'
		assert d23.author == 'Steve'
		println('  -> BookEdit type=sign title=${d23.title} author=${d23.author} OK')
	}

	bo := &protocol.BossEventPacket{
		boss_actor_unique_id:   1000
		player_actor_unique_id: 2000
		event_type:             0
		title:                  'Ender Dragon'
		filtered_title:         'Ender Dragon'
		health_percent:         0.75
		color:                  2
		overlay:                0
	}
	d24 := roundtrip(bo, mut pool)!
	if d24 is protocol.BossEventPacket {
		assert d24.title == 'Ender Dragon'
		assert d24.health_percent == 0.75
		println('  -> BossEvent title=${d24.title} hp=${d24.health_percent} OK')
	}

	ccbs := &protocol.ClientCacheBlobStatusPacket{
		miss_hashes: [u64(0xAA), u64(0xBB)]
		hit_hashes:  [u64(0xCC)]
	}
	d25 := roundtrip(ccbs, mut pool)!
	if d25 is protocol.ClientCacheBlobStatusPacket {
		assert d25.miss_hashes.len == 2
		assert d25.hit_hashes.len == 1
		assert d25.hit_hashes[0] == 0xCC
		println('  -> ClientCacheBlobStatus miss=${d25.miss_hashes.len} hit=${d25.hit_hashes.len} OK')
	}

	ss := &protocol.SetScorePacket{
		type: protocol.set_score_type_change
		entries: [
			types.ScorePacketEntry{
				scoreboard_id:   1
				objective_name:  'kills'
				score:           42
				type:            types.score_entry_type_fake_player
				custom_name:     'Bot'
			},
			types.ScorePacketEntry{
				scoreboard_id:   2
				objective_name:  'kills'
				score:           7
				type:            types.score_entry_type_player
				actor_unique_id: 9001
			},
		]
	}
	d26 := roundtrip(ss, mut pool)!
	if d26 is protocol.SetScorePacket {
		assert d26.entries.len == 2
		assert (d26.entries[0].custom_name) == 'Bot'
		assert d26.entries[1].actor_unique_id == 9001
		println('  -> SetScore entries=${d26.entries.len} (fake=${d26.entries[0].custom_name}, player=${d26.entries[1].actor_unique_id}) OK')
	}

	cr := &protocol.CommandRequestPacket{
		command: '/say hi'
		origin_data: types.CommandOriginData{
			type:                   'player'
			uuid:                   types.uuid_from_bytes([u8(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
			request_id:             'req-1'
			player_actor_unique_id: 5
		}
		is_internal: false
		version:     '1'
	}
	d27 := roundtrip(cr, mut pool)!
	if d27 is protocol.CommandRequestPacket {
		assert d27.command == '/say hi'
		assert d27.origin_data.request_id == 'req-1'
		assert d27.origin_data.uuid.bytes[0] == 1
		println('  -> CommandRequest cmd=${d27.command} origin=${d27.origin_data.type}/${d27.origin_data.request_id} OK')
	}

	el := &protocol.EmoteListPacket{
		player_actor_runtime_id: 3
		emote_ids: [
			types.uuid_from_bytes([u8(16), 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]),
		]
	}
	d28 := roundtrip(el, mut pool)!
	if d28 is protocol.EmoteListPacket {
		assert d28.emote_ids.len == 1
		assert d28.emote_ids[0].bytes[0] == 16
		println('  -> EmoteList runtime=${d28.player_actor_runtime_id} emotes=${d28.emote_ids.len} OK')
	}

	cbu := &protocol.CommandBlockUpdatePacket{
		is_block:           true
		block_position:     types.BlockPosition{1, 2, 3}
		command_block_mode: 0
		is_redstone_mode:   true
		is_conditional:     false
		command:            '/time set day'
		last_output:        ''
		name:               'clock'
		filtered_name:      ''
		should_track_output: true
		tick_delay:         0
		execute_on_first_tick: true
	}
	d29 := roundtrip(cbu, mut pool)!
	if d29 is protocol.CommandBlockUpdatePacket {
		assert d29.is_block == true
		assert d29.command == '/time set day'
		assert d29.name == 'clock'
		println('  -> CommandBlockUpdate isBlock=${d29.is_block} cmd=${d29.command} OK')
	}

	uco := &protocol.UpdateClientOptionsPacket{
		graphics_mode:           2
		filter_profanity_change: none
	}
	d30 := roundtrip(uco, mut pool)!
	if d30 is protocol.UpdateClientOptionsPacket {
		assert (d30.graphics_mode or { -1 }) == 2
		assert d30.filter_profanity_change == none
		println('  -> UpdateClientOptions gfx=${d30.graphics_mode or { -1 }} filter=<none> OK')
	}

	sap := &protocol.SyncActorPropertyPacket{
		nbt: nbt.RootTag{
			name: ''
			tag:  nbt.Tag(nbt.Compound{
				values: {
					'speed': nbt.Tag(f32(0.25))
				}
			})
		}
	}
	d31 := roundtrip(sap, mut pool)!
	if d31 is protocol.SyncActorPropertyPacket {
		dc := d31.nbt.tag as nbt.Compound
		assert (dc.get('speed') or { nbt.Tag(f32(0)) } as f32) == 0.25
		println('  -> SyncActorProperty nbt.speed=${dc.get('speed') or { nbt.Tag(f32(0)) } as f32} OK')
	}

	pvw := &protocol.PacketViolationWarningPacket{
		type:      1
		severity:  2
		packet_id: 5
		message:   'bad packet'
	}
	d32 := roundtrip(pvw, mut pool)!
	if d32 is protocol.PacketViolationWarningPacket {
		assert d32.packet_id == 5
		assert d32.message == 'bad packet'
		println('  -> PacketViolationWarning pid=${d32.packet_id} msg=${d32.message} OK')
	}

	cmpp := &protocol.CorrectPlayerMovePredictionPacket{
		prediction_type:          1
		position:                 types.Vector3{1, 2, 3}
		delta:                    types.Vector3{0.1, 0.2, 0.3}
		vehicle_rotation:         types.Vector2{10, 20}
		vehicle_angular_velocity: none
		on_ground:                true
		tick:                     42
	}
	d33 := roundtrip(cmpp, mut pool)!
	if d33 is protocol.CorrectPlayerMovePredictionPacket {
		assert d33.position.x == 1
		assert d33.on_ground == true
		assert d33.tick == 42
		assert d33.vehicle_angular_velocity == none
		println('  -> CorrectPlayerMovePrediction tick=${d33.tick} ground=${d33.on_ground} OK')
	}

	pad := &protocol.PlayerArmorDamagePacket{
		pairs: [
			protocol.ArmorSlotAndDamagePair{
				slot:   1
				damage: 250
			},
		]
	}
	d34 := roundtrip(pad, mut pool)!
	if d34 is protocol.PlayerArmorDamagePacket {
		assert d34.pairs.len == 1
		assert d34.pairs[0].damage == 250
		println('  -> PlayerArmorDamage pairs=${d34.pairs.len} damage=${d34.pairs[0].damage} OK')
	}

	plp := &protocol.PlayerLocationPacket{
		type:            protocol.player_location_type_coordinates
		actor_unique_id: 99
		position:        types.Vector3{5, 6, 7}
	}
	d35 := roundtrip(plp, mut pool)!
	if d35 is protocol.PlayerLocationPacket {
		assert d35.actor_unique_id == 99
		assert d35.position.z == 7
		println('  -> PlayerLocation id=${d35.actor_unique_id} z=${d35.position.z} OK')
	}

	ur := &protocol.UnlockedRecipesPacket{
		type:    2
		recipes: ['minecraft:stick', 'minecraft:torch']
	}
	d36 := roundtrip(ur, mut pool)!
	if d36 is protocol.UnlockedRecipesPacket {
		assert d36.type == 2
		assert d36.recipes.len == 2
		assert d36.recipes[1] == 'minecraft:torch'
		println('  -> UnlockedRecipes type=${d36.type} recipes=${d36.recipes.len} OK')
	}

	fr := &protocol.FeatureRegistryPacket{
		entries: [
			protocol.FeatureRegistryEntry{
				name: 'overworld'
				json: '{}'
			},
		]
	}
	d37 := roundtrip(fr, mut pool)!
	if d37 is protocol.FeatureRegistryPacket {
		assert d37.entries.len == 1
		assert d37.entries[0].name == 'overworld'
		println('  -> FeatureRegistry entries=${d37.entries.len} name=${d37.entries[0].name} OK')
	}

	cds := &protocol.ClientboundDataDrivenUIShowScreenPacket{
		screen_id:        'shop'
		form_id:          7
		data_instance_id: none
	}
	d38 := roundtrip(cds, mut pool)!
	if d38 is protocol.ClientboundDataDrivenUIShowScreenPacket {
		assert d38.screen_id == 'shop'
		assert d38.form_id == 7
		assert d38.data_instance_id == none
		println('  -> ClientboundDataDrivenUIShowScreen screen=${d38.screen_id} form=${d38.form_id} OK')
	}

	puo := &protocol.PlayerUpdateEntityOverridesPacket{
		actor_runtime_id:   55
		property_index:     3
		update_type:        protocol.override_update_type_set_float
		float_override_value: 1.5
	}
	d39 := roundtrip(puo, mut pool)!
	if d39 is protocol.PlayerUpdateEntityOverridesPacket {
		assert d39.update_type == protocol.override_update_type_set_float
		assert d39.float_override_value == 1.5
		println('  -> PlayerUpdateEntityOverrides type=${d39.update_type} f=${d39.float_override_value} OK')
	}

	ptb := &protocol.PositionTrackingDBClientRequestPacket{
		action:      1
		tracking_id: 42
	}
	d40 := roundtrip(ptb, mut pool)!
	if d40 is protocol.PositionTrackingDBClientRequestPacket {
		assert d40.action == 1
		assert d40.tracking_id == 42
		println('  -> PositionTrackingDBClientRequest action=${d40.action} id=${d40.tracking_id} OK')
	}

	mlc := &protocol.MapCreateLockedCopyPacket{
		original_map_id: 100
		new_map_id:      200
	}
	d41 := roundtrip(mlc, mut pool)!
	if d41 is protocol.MapCreateLockedCopyPacket {
		assert d41.original_map_id == 100
		assert d41.new_map_id == 200
		println('  -> MapCreateLockedCopy orig=${d41.original_map_id} new=${d41.new_map_id} OK')
	}

	gtr := &protocol.GameTestResultsPacket{
		success:   true
		error:     ''
		test_name: 'spawn_test'
	}
	d42 := roundtrip(gtr, mut pool)!
	if d42 is protocol.GameTestResultsPacket {
		assert d42.success == true
		assert d42.test_name == 'spawn_test'
		println('  -> GameTestResults success=${d42.success} name=${d42.test_name} OK')
	}

	scr := &protocol.SubChunkRequestPacket{
		dimension: 0
		entries:   [
			protocol.SubChunkPositionOffset{
				x_offset: 1
				y_offset: -2
				z_offset: 3
			},
		]
		base_x: 16
		base_y: 0
		base_z: -16
	}
	d43 := roundtrip(scr, mut pool)!
	if d43 is protocol.SubChunkRequestPacket {
		assert d43.entries.len == 1
		assert d43.entries[0].y_offset == -2
		assert d43.base_z == -16
		println('  -> SubChunkRequest entries=${d43.entries.len} baseZ=${d43.base_z} OK')
	}

	ccmr := &protocol.ClientCacheMissResponsePacket{
		blobs: [
			protocol.ChunkCacheBlob{
				hash:    123456
				payload: 'blobdata'
			},
		]
	}
	d44 := roundtrip(ccmr, mut pool)!
	if d44 is protocol.ClientCacheMissResponsePacket {
		assert d44.blobs.len == 1
		assert d44.blobs[0].hash == 123456
		assert d44.blobs[0].payload == 'blobdata'
		println('  -> ClientCacheMissResponse blobs=${d44.blobs.len} hash=${d44.blobs[0].hash} OK')
	}

	ua := &protocol.UpdateAbilitiesPacket{
		data: protocol.AbilitiesData{
			target_actor_unique_id: 77
			player_permission:      2
			command_permission:     1
			layers:                 [
				protocol.AbilitiesLayer{
					layer_id:           1
					set_abilities:      0xff
					set_ability_values: 0x0f
					fly_speed:          0.05
					vertical_fly_speed: 0.0
					walk_speed:         0.1
				},
			]
		}
	}
	d45 := roundtrip(ua, mut pool)!
	if d45 is protocol.UpdateAbilitiesPacket {
		assert d45.data.target_actor_unique_id == 77
		assert d45.data.layers.len == 1
		assert d45.data.layers[0].set_abilities == 0xff
		assert d45.data.layers[0].walk_speed == 0.1
		println('  -> UpdateAbilities perm=${d45.data.player_permission} layers=${d45.data.layers.len} OK')
	}

	dd := &protocol.DimensionDataPacket{
		definitions: [
			protocol.DimensionDefinition{
				name:           'minecraft:overworld'
				max_height:     320
				min_height:     -64
				generator:      1
				dimension_type: 0
			},
		]
	}
	d46 := roundtrip(dd, mut pool)!
	if d46 is protocol.DimensionDataPacket {
		assert d46.definitions.len == 1
		assert d46.definitions[0].min_height == -64
		println('  -> DimensionData defs=${d46.definitions.len} minH=${d46.definitions[0].min_height} OK')
	}

	usb := &protocol.UpdateSubChunkBlocksPacket{
		base_block_position: types.BlockPosition{16, 0, 16}
		layer0_updates:      [
			protocol.UpdateSubChunkBlocksEntry{
				block_position:         types.BlockPosition{1, 2, 3}
				block_runtime_id:       55
				update_flags:           2
				synced_update_actor_id: 999
				synced_update_type:     1
			},
		]
		layer1_updates: []
	}
	d47 := roundtrip(usb, mut pool)!
	if d47 is protocol.UpdateSubChunkBlocksPacket {
		assert d47.layer0_updates.len == 1
		assert d47.layer0_updates[0].block_runtime_id == 55
		assert d47.layer1_updates.len == 0
		println('  -> UpdateSubChunkBlocks l0=${d47.layer0_updates.len} rid=${d47.layer0_updates[0].block_runtime_id} OK')
	}

	co := &protocol.CommandOutputPacket{
		origin_data: types.CommandOriginData{
			type:                   'player'
			uuid:                   types.uuid_from_bytes([u8(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
			request_id:             'req-9'
			player_actor_unique_id: 7
		}
		output_type:   'all'
		success_count: 3
		messages:      [
			protocol.CommandOutputMessage{
				message_id:  'commands.test'
				is_internal: false
				parameters:  ['a', 'b']
			},
		]
		data: none
	}
	d48 := roundtrip(co, mut pool)!
	if d48 is protocol.CommandOutputPacket {
		assert d48.success_count == 3
		assert d48.messages.len == 1
		assert d48.messages[0].parameters.len == 2
		assert d48.data == none
		println('  -> CommandOutput success=${d48.success_count} msgs=${d48.messages.len} OK')
	}

	lc := &protocol.LevelChunkPacket{
		chunk_position:  types.ChunkPosition{3, -4}
		dimension_id:    0
		request_type:    protocol.level_chunk_request_truncated
		sub_chunk_count: 5
		cache_enabled:   true
		used_blob_hashes: [u64(111), 222]
		extra_payload:   'chunkbytes'
	}
	d49 := roundtrip(lc, mut pool)!
	if d49 is protocol.LevelChunkPacket {
		assert d49.request_type == protocol.level_chunk_request_truncated
		assert d49.sub_chunk_count == 5
		assert d49.used_blob_hashes.len == 2
		assert d49.extra_payload == 'chunkbytes'
		println('  -> LevelChunk reqType=${d49.request_type} sub=${d49.sub_chunk_count} hashes=${d49.used_blob_hashes.len} OK')
	}

	js := &protocol.JigsawStructureDataPacket{
		nbt: nbt.RootTag{
			name: ''
			tag:  nbt.Tag(nbt.Compound{
				values: {
					'count': nbt.Tag(i32(3))
				}
			})
		}
	}
	d50 := roundtrip(js, mut pool)!
	if d50 is protocol.JigsawStructureDataPacket {
		jc := d50.nbt.tag as nbt.Compound
		cnt := (jc.get('count') or { nbt.Tag(i32(0)) }) as i32
		assert cnt == 3
		println('  -> JigsawStructureData nbt.count=${cnt} OK')
	}

	td := &protocol.TrimDataPacket{
		patterns: [
			protocol.TrimPattern{
				item_id:    'minecraft:coast_trim'
				pattern_id: 'coast'
			},
		]
		materials: [
			protocol.TrimMaterial{
				material_id: 'iron'
				color:       '#ffffff'
				item_id:     'minecraft:iron_ingot'
			},
		]
	}
	d51 := roundtrip(td, mut pool)!
	if d51 is protocol.TrimDataPacket {
		assert d51.patterns.len == 1
		assert d51.materials.len == 1
		assert d51.materials[0].item_id == 'minecraft:iron_ingot'
		println('  -> TrimData patterns=${d51.patterns.len} materials=${d51.materials.len} OK')
	}

	rps := &protocol.ResourcePackStackPacket{
		must_accept:         true
		resource_pack_stack: [
			protocol.ResourcePackStackEntry{
				pack_id:       'pack-1'
				version:       '1.0.0'
				sub_pack_name: ''
			},
		]
		base_game_version: '1.21.0'
		experiments:       types.Experiments{
			entries: [
				types.ExperimentEntry{
					name:    'gametest'
					enabled: true
				},
			]
			has_previously_used: false
		}
		use_vanilla_editor_packs: false
	}
	d52 := roundtrip(rps, mut pool)!
	if d52 is protocol.ResourcePackStackPacket {
		assert d52.must_accept == true
		assert d52.resource_pack_stack.len == 1
		assert d52.base_game_version == '1.21.0'
		assert d52.experiments.entries.len == 1
		assert d52.experiments.entries[0].name == 'gametest'
		println('  -> ResourcePackStack packs=${d52.resource_pack_stack.len} exp=${d52.experiments.entries.len} OK')
	}

	rpi := &protocol.ResourcePacksInfoPacket{
		must_accept:            false
		has_addons:             true
		has_scripts:            false
		world_template_id:      types.uuid_from_bytes([u8(9), 8, 7, 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6])
		world_template_version: '2.0'
		entries:                [
			protocol.ResourcePackInfoEntry{
				uuid:           types.uuid_from_bytes([u8(1), 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4])
				version:        '1.0'
				size_bytes:     123456789
				encryption_key: ''
				sub_pack_name:  ''
				content_id:     'cid'
				has_scripts:    false
				is_addon_pack:  true
				rtx_capable:    false
				cdn_url:        ''
			},
		]
	}
	d53 := roundtrip(rpi, mut pool)!
	if d53 is protocol.ResourcePacksInfoPacket {
		assert d53.has_addons == true
		assert d53.entries.len == 1
		assert d53.entries[0].size_bytes == 123456789
		assert d53.entries[0].content_id == 'cid'
		println('  -> ResourcePacksInfo entries=${d53.entries.len} size=${d53.entries[0].size_bytes} OK')
	}

	sbu := &protocol.StructureBlockUpdatePacket{
		block_position:        types.BlockPosition{1, 2, 3}
		structure_editor_data: types.StructureEditorData{
			structure_name:           'house'
			filtered_structure_name:  'house'
			structure_data_field:     ''
			include_players:          true
			show_bounding_box:        false
			structure_block_type:     2
			structure_settings:       types.StructureSettings{
				palette_name:              'default'
				dimensions:                types.BlockPosition{5, 5, 5}
				offset:                    types.BlockPosition{0, 1, 0}
				last_touched_by_player_id: 42
				rotation:                  1
				mirror:                    0
				animation_mode:            0
				animation_seconds:         0.0
				integrity_value:           1.0
				integrity_seed:            7
				pivot:                     types.Vector3{0, 0, 0}
			}
			structure_redstone_save_mode: 1
		}
		is_powered:  true
		waterlogged: false
	}
	d54 := roundtrip(sbu, mut pool)!
	if d54 is protocol.StructureBlockUpdatePacket {
		assert d54.is_powered == true
		assert d54.structure_editor_data.structure_name == 'house'
		assert d54.structure_editor_data.structure_settings.integrity_value == 1.0
		assert d54.structure_editor_data.structure_settings.last_touched_by_player_id == 42
		println('  -> StructureBlockUpdate name=${d54.structure_editor_data.structure_name} powered=${d54.is_powered} OK')
	}

	sc := &protocol.SubChunkPacket{
		cache_enabled: false
		dimension:     0
		base_x:        1
		base_y:        0
		base_z:        -1
		entries:       [
			protocol.SubChunkEntry{
				offset:                 protocol.SubChunkPositionOffset{0, 1, 0}
				request_result:         1
				terrain_data:           'blocks'
				height_map_type:        protocol.subchunk_heightmap_all_too_high
				height_map:             []
				render_height_map_type: protocol.subchunk_heightmap_no_data
				render_height_map:      []
			},
		]
	}
	d55 := roundtrip(sc, mut pool)!
	if d55 is protocol.SubChunkPacket {
		assert d55.entries.len == 1
		assert d55.entries[0].terrain_data == 'blocks'
		assert d55.entries[0].height_map_type == protocol.subchunk_heightmap_all_too_high
		assert d55.base_z == -1
		println('  -> SubChunk entries=${d55.entries.len} hmType=${d55.entries[0].height_map_type} OK')
	}

	peo := &protocol.PlayerEnchantOptionsPacket{
		options: [
			protocol.EnchantOption{
				cost:           5
				slot_flags:     3
				equip_enchants: [protocol.Enchant{
					id:    9
					level: 2
				}]
				held_enchants:  []
				self_enchants:  []
				name:           'Sharpness'
				option_id:      77
			},
		]
	}
	d56 := roundtrip(peo, mut pool)!
	if d56 is protocol.PlayerEnchantOptionsPacket {
		assert d56.options.len == 1
		assert d56.options[0].cost == 5
		assert d56.options[0].equip_enchants[0].id == 9
		assert d56.options[0].option_id == 77
		println('  -> PlayerEnchantOptions opts=${d56.options.len} cost=${d56.options[0].cost} OK')
	}

	lb := &protocol.LocatorBarPacket{
		waypoints: [
			protocol.LocatorBarWaypointPayload{
				group:    types.uuid_from_bytes([u8(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
				waypoint: protocol.LocatorBarWaypoint{
					update_flag:     7
					visible:         true
					world_position:  protocol.WorldPosition{
						position:  types.Vector3{1, 2, 3}
						dimension: 0
					}
					texture_path:    none
					icon_size:       none
					color:           0xff00ff00
					client_position_authority: none
					actor_unique_id: 55
				}
				action: 1
			},
		]
	}
	d57 := roundtrip(lb, mut pool)!
	if d57 is protocol.LocatorBarPacket {
		assert d57.waypoints.len == 1
		wp := d57.waypoints[0].waypoint
		assert (wp.visible or { false }) == true
		assert (wp.color or { 0 }) == 0xff00ff00
		assert wp.texture_path == none
		assert (wp.actor_unique_id or { 0 }) == 55
		println('  -> LocatorBar waypoints=${d57.waypoints.len} flag=${wp.update_flag} OK')
	}

	gop := &protocol.GraphicsOverrideParameterPacket{
		values: [
			protocol.ParameterKeyframeValue{
				time:  0.5
				value: types.Vector3{1, 0, 0}
			},
		]
		unknown_float:     none
		unknown_vector3:   types.Vector3{9, 8, 7}
		biome_identifier:  'minecraft:plains'
		player_identifier: none
		parameter_type:    2
		reset:             true
	}
	d58 := roundtrip(gop, mut pool)!
	if d58 is protocol.GraphicsOverrideParameterPacket {
		assert d58.values.len == 1
		assert d58.unknown_float == none
		assert (d58.unknown_vector3 or { types.Vector3{} }).x == 9
		assert d58.biome_identifier == 'minecraft:plains'
		assert d58.reset == true
		println('  -> GraphicsOverrideParameter values=${d58.values.len} biome=${d58.biome_identifier} OK')
	}

	cs := &protocol.CameraSplinePacket{
		splines: [
			protocol.CameraSplineDefinition{
				name:        'flythrough'
				instruction: protocol.CameraSplineInstruction{
					total_time:          5.0
					ease_type:           1
					curve:               [types.Vector3{0, 0, 0}, types.Vector3{1, 2, 3}]
					progress_key_frames: [protocol.CameraProgressOption{
						value:     0.5
						time:      1.0
						ease_type: 'linear'
					}]
					rotation_options: [protocol.CameraRotationOption{
						value: types.Vector3{0, 90, 0}
						time:  2.0
						ease:  'in_out'
					}]
					spline_identifier: 'spline-1'
					load_from_json:    false
				}
			},
		]
	}
	d59 := roundtrip(cs, mut pool)!
	if d59 is protocol.CameraSplinePacket {
		assert d59.splines.len == 1
		ins := d59.splines[0].instruction
		assert ins.curve.len == 2
		assert ins.progress_key_frames[0].ease_type == 'linear'
		assert ins.spline_identifier == 'spline-1'
		println('  -> CameraSpline splines=${d59.splines.len} curve=${ins.curve.len} OK')
	}

	cap := &protocol.CameraAimAssistActorPriorityPacket{
		priority_data: [
			protocol.CameraAimAssistActorPriorityData{
				preset_index:   1
				category_index: -2
				actor_index:    3
				priority:       100
			},
		]
	}
	d60 := roundtrip(cap, mut pool)!
	if d60 is protocol.CameraAimAssistActorPriorityPacket {
		assert d60.priority_data.len == 1
		assert d60.priority_data[0].category_index == -2
		assert d60.priority_data[0].priority == 100
		println('  -> CameraAimAssistActorPriority data=${d60.priority_data.len} OK')
	}

	ci := &protocol.CameraInstructionPacket{
		set: protocol.CameraSetInstruction{
			preset:                 4
			ease:                   protocol.CameraSetInstructionEase{
				type:     1
				duration: 0.5
			}
			camera_position:        types.Vector3{10, 20, 30}
			rotation:               none
			facing_position:        none
			view_offset:            none
			entity_offset:          none
			default:                none
			ignore_starting_values: true
		}
		clear:              none
		fade:               protocol.CameraFadeInstruction{
			time:  protocol.CameraFadeInstructionTime{
				fade_in:  1.0
				stay:     2.0
				fade_out: 1.0
			}
			color: none
		}
		target:             none
		remove_target:      true
		field_of_view:      none
		spline:             none
		attach_to_entity:   42
		detach_from_entity: none
	}
	d61 := roundtrip(ci, mut pool)!
	if d61 is protocol.CameraInstructionPacket {
		s := d61.set or { protocol.CameraSetInstruction{} }
		assert s.preset == 4
		assert (s.ease or { protocol.CameraSetInstructionEase{} }).duration == 0.5
		assert (s.camera_position or { types.Vector3{} }).x == 10
		assert s.rotation == none
		f := d61.fade or { protocol.CameraFadeInstruction{} }
		assert (f.time or { protocol.CameraFadeInstructionTime{} }).stay == 2.0
		assert f.color == none
		assert (d61.remove_target or { false }) == true
		assert (d61.attach_to_entity or { 0 }) == 42
		assert d61.detach_from_entity == none
		println('  -> CameraInstruction set.preset=${s.preset} attach=${d61.attach_to_entity or { 0 }} OK')
	}

	es := &protocol.EducationSettingsPacket{
		code_builder_default_uri:        'uri'
		code_builder_title:              'Builder'
		can_resize_code_builder:         true
		disable_legacy_title_bar:        false
		post_process_filter:             'filter'
		screenshot_border_resource_path: 'border'
		agent_capabilities:              protocol.EducationSettingsAgentCapabilities{
			can_modify_blocks: true
		}
		code_builder_override_uri: none
		has_quiz:                  true
		link_settings:             none
	}
	d62 := roundtrip(es, mut pool)!
	if d62 is protocol.EducationSettingsPacket {
		assert d62.code_builder_title == 'Builder'
		assert d62.has_quiz == true
		ecap := d62.agent_capabilities or { protocol.EducationSettingsAgentCapabilities{} }
		assert (ecap.can_modify_blocks or { false }) == true
		assert d62.link_settings == none
		println('  -> EducationSettings title=${d62.code_builder_title} quiz=${d62.has_quiz} OK')
	}

	psc := &protocol.ServerboundPackSettingChangePacket{
		pack_id:      types.uuid_from_bytes([u8(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
		setting_name: 'render_distance'
		setting_type: protocol.pack_setting_type_float
		float_value:  12.5
	}
	d63 := roundtrip(psc, mut pool)!
	if d63 is protocol.ServerboundPackSettingChangePacket {
		assert d63.setting_name == 'render_distance'
		assert d63.setting_type == protocol.pack_setting_type_float
		assert d63.float_value == 12.5
		println('  -> ServerboundPackSettingChange name=${d63.setting_name} val=${d63.float_value} OK')
	}

	ssi := &protocol.ServerStoreInfoPacket{
		config: protocol.ClientStoreEntrypointConfig{
			store_id:   'store-1'
			store_name: 'Marketplace'
		}
	}
	d64 := roundtrip(ssi, mut pool)!
	if d64 is protocol.ServerStoreInfoPacket {
		c := d64.config or { protocol.ClientStoreEntrypointConfig{} }
		assert c.store_name == 'Marketplace'
		println('  -> ServerStoreInfo store=${c.store_name} OK')
	}

	spi := &protocol.ServerPresenceInfoPacket{
		presence: protocol.PresenceInfo{
			experience_name:  none
			world_name:       'My World'
			rich_presence_id: 'rp-1'
		}
	}
	d65 := roundtrip(spi, mut pool)!
	if d65 is protocol.ServerPresenceInfoPacket {
		pinfo := d65.presence or { protocol.PresenceInfo{} }
		assert pinfo.experience_name == none
		assert (pinfo.world_name or { '' }) == 'My World'
		assert pinfo.rich_presence_id == 'rp-1'
		println('  -> ServerPresenceInfo world=${pinfo.world_name or { '' }} OK')
	}

	sample_skin := types.SkinData{
		skin_id:        'skin-1'
		resource_patch: '{}'
		skin_image:     types.SkinImage{
			width:  2
			height: 2
			data:   'abcd'
		}
		cape_image:        types.SkinImage{}
		persona_pieces:    [types.PersonaSkinPiece{
			piece_id:   'p1'
			piece_type: 'body'
			pack_id:    'pk'
			is_default: true
			product_id: ''
		}]
		piece_tint_colors: [types.PersonaPieceTintColor{
			piece_type: 'body'
			colors:     ['#fff', '#000']
		}]
		premium: true
	}
	psk := &protocol.PlayerSkinPacket{
		uuid:          types.uuid_from_bytes([u8(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
		skin:          sample_skin
		new_skin_name: 'new'
		old_skin_name: 'old'
		verified:      true
	}
	d66 := roundtrip(psk, mut pool)!
	if d66 is protocol.PlayerSkinPacket {
		assert d66.skin.skin_id == 'skin-1'
		assert d66.skin.skin_image.data == 'abcd'
		assert d66.skin.persona_pieces.len == 1
		assert d66.skin.piece_tint_colors[0].colors.len == 2
		assert d66.verified == true
		println('  -> PlayerSkin id=${d66.skin.skin_id} tints=${d66.skin.piece_tint_colors[0].colors.len} OK')
	}

	pl := &protocol.PlayerListPacket{
		type:    protocol.player_list_type_add
		entries: [
			protocol.PlayerListEntry{
				uuid:            types.uuid_from_bytes([u8(1), 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4])
				actor_unique_id: 50
				username:        'Steve'
				xbox_user_id:    'xuid'
				build_platform:  1
				skin:            sample_skin
				is_host:         true
				color:           0xffffffff
				verified:        true
			},
		]
	}
	d67 := roundtrip(pl, mut pool)!
	if d67 is protocol.PlayerListPacket {
		assert d67.type == protocol.player_list_type_add
		assert d67.entries.len == 1
		assert d67.entries[0].username == 'Steve'
		assert d67.entries[0].verified == true
		println('  -> PlayerList type=${d67.type} entries=${d67.entries.len} user=${d67.entries[0].username} OK')
	}

	ap := &protocol.AddPlayerPacket{
		uuid:             types.uuid_from_bytes([u8(9), 9, 9, 9, 8, 8, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6])
		username:         'Alex'
		actor_runtime_id: 321
		position:         types.Vector3{1, 2, 3}
		motion:           types.Vector3{0, 0, 0}
		item:             types.ItemStackWrapper{
			item_stack: types.ItemStack{
				id: 0
			}
		}
		game_mode: 1
		metadata:  []
		abilities: protocol.AbilitiesData{
			target_actor_unique_id: 321
			layers:                 []
		}
		links:          []
		device_id:      'dev'
		build_platform: 2
	}
	d68 := roundtrip(ap, mut pool)!
	if d68 is protocol.AddPlayerPacket {
		assert d68.username == 'Alex'
		assert d68.actor_runtime_id == 321
		assert d68.build_platform == 2
		println('  -> AddPlayer user=${d68.username} runtime=${d68.actor_runtime_id} OK')
	}

	cdr := &protocol.ClientboundDebugRendererPacket{
		type: 'add_marker'
		data: protocol.DebugMarkerData{
			text:            'here'
			position:        types.Vector3{1, 2, 3}
			color:           0xff00ff00
			duration_millis: 5000
		}
	}
	d69 := roundtrip(cdr, mut pool)!
	if d69 is protocol.ClientboundDebugRendererPacket {
		dm := d69.data or { protocol.DebugMarkerData{} }
		assert dm.text == 'here'
		assert dm.duration_millis == 5000
		println('  -> ClientboundDebugRenderer text=${dm.text} OK')
	}

	cmp := &protocol.ClientMovementPredictionSyncPacket{
		flags:              [u8(0x81), 0x02]
		scale:              1.0
		health:             20.0
		actor_unique_id:    7
		actor_flying_state: true
	}
	d70 := roundtrip(cmp, mut pool)!
	if d70 is protocol.ClientMovementPredictionSyncPacket {
		assert d70.flags == [u8(0x81), 0x02]
		assert d70.health == 20.0
		assert d70.actor_flying_state == true
		println('  -> ClientMovementPredictionSync flags=${d70.flags.len}B health=${d70.health} OK')
	}

	leg := &protocol.LevelEventGenericPacket{
		event_id:   42
		event_data: [u8(10), 0, 0]
	}
	d71 := roundtrip(leg, mut pool)!
	if d71 is protocol.LevelEventGenericPacket {
		assert d71.event_id == 42
		assert d71.event_data == [u8(10), 0, 0]
		println('  -> LevelEventGeneric id=${d71.event_id} data=${d71.event_data.len}B OK')
	}

	sd := &protocol.ServerboundDiagnosticsPacket{
		avg_fps:                60.0
		memory_category_values: [protocol.MemoryCategoryCounter{
			category: 1
			bytes:    4096
		}]
		entity_diagnostics: [protocol.EntityDiagnosticTimingInfo{
			display_name:     'zombie'
			entity:           'minecraft:zombie'
			time_in_ns:       1000
			percent_of_total: 50
		}]
		system_diagnostics: []
		whisker_scopes:     []
	}
	d72 := roundtrip(sd, mut pool)!
	if d72 is protocol.ServerboundDiagnosticsPacket {
		assert d72.avg_fps == 60.0
		assert d72.memory_category_values.len == 1
		assert d72.entity_diagnostics[0].entity == 'minecraft:zombie'
		println('  -> ServerboundDiagnostics fps=${d72.avg_fps} mem=${d72.memory_category_values.len} OK')
	}

	sds := &protocol.ServerboundDataStorePacket{
		update: protocol.DataStoreUpdate{
			name:              'inv'
			property:          'slot'
			path:              'a.b'
			value_type:        protocol.data_store_value_string
			string_value:      'gold'
			update_count:      3
			path_update_count: 1
		}
	}
	d73 := roundtrip(sds, mut pool)!
	if d73 is protocol.ServerboundDataStorePacket {
		assert d73.update.name == 'inv'
		assert d73.update.string_value == 'gold'
		assert d73.update.update_count == 3
		println('  -> ServerboundDataStore name=${d73.update.name} val=${d73.update.string_value} OK')
	}

	swc := &protocol.SyncWorldClocksPacket{
		payload_type: protocol.clock_payload_type_add_time_marker
		add_clock_id: 7
		add_time_markers: [protocol.TimeMarkerData{
			id:         11
			name:       'dawn'
			time:       100
			has_period: true
			period:     20
		}]
	}
	d74 := roundtrip(swc, mut pool)!
	if d74 is protocol.SyncWorldClocksPacket {
		assert d74.add_clock_id == 7
		assert d74.add_time_markers[0].name == 'dawn'
		assert d74.add_time_markers[0].period == 20
		println('  -> SyncWorldClocks clock=${d74.add_clock_id} marker=${d74.add_time_markers[0].name} OK')
	}

	cals := &protocol.ClientboundAttributeLayerSyncPacket{
		payload_type: protocol.attribute_layer_payload_update_environment
		layer_name:   'overworld'
		dimension_id: 0
		environment_attributes: [protocol.EnvironmentAttributeData{
			attribute_name:           'fog'
			attribute:                protocol.AttributeData{
				type_id:     protocol.attribute_data_type_float
				float_value: 1.5
			}
			current_transition_ticks: 5
			total_transition_ticks:   10
			ease_type:                'Linear'
			local_transition_ticks:   2
			noise_transition:         true
		}]
	}
	d75 := roundtrip(cals, mut pool)!
	if d75 is protocol.ClientboundAttributeLayerSyncPacket {
		assert d75.layer_name == 'overworld'
		assert d75.environment_attributes[0].attribute_name == 'fog'
		assert d75.environment_attributes[0].attribute.float_value == 1.5
		assert d75.environment_attributes[0].ease_type == 'Linear'
		println('  -> ClientboundAttributeLayerSync layer=${d75.layer_name} attr=${d75.environment_attributes[0].attribute_name} OK')
	}

	cdsp := &protocol.ClientboundDataStorePacket{
		updates: [
			protocol.DataStoreChangeEntry{
				change_type:         protocol.data_store_change_change
				change_name:         'inv'
				change_property:     'p'
				change_update_count: 4
				change_new_value:    protocol.DataStorePropertyValue{
					type_id:   protocol.data_store_property_map
					map_value: [protocol.DataStoreMapEntry{
						key:   'k'
						value: protocol.DataStorePropertyValue{
							type_id:      protocol.data_store_property_string
							string_value: 'v'
						}
					}]
				}
			},
			protocol.DataStoreChangeEntry{
				change_type:  protocol.data_store_change_removal
				removal_name: 'old'
			},
		]
	}
	d76 := roundtrip(cds, mut pool)!
	if d76 is protocol.ClientboundDataStorePacket {
		assert d76.updates.len == 2
		assert d76.updates[0].change_new_value.map_value[0].value.string_value == 'v'
		assert d76.updates[1].removal_name == 'old'
		println('  -> ClientboundDataStore entries=${d76.updates.len} mapval=${d76.updates[0].change_new_value.map_value[0].value.string_value} OK')
	}

	vs := &protocol.VoxelShapesPacket{
		shapes: [protocol.VoxelShape{
			cells:         protocol.VoxelCells{
				x_size:  2
				y_size:  2
				z_size:  2
				storage: [u8(1), 0, 1, 0]
			}
			x_coordinates: [f32(0.0), 1.0]
			y_coordinates: [f32(0.0), 1.0]
			z_coordinates: [f32(0.0), 1.0]
		}]
		name_map: [protocol.VoxelShapeNameEntry{
			name: 'stone'
			id:   5
		}]
		custom_shape_count: 1
	}
	d77 := roundtrip(vs, mut pool)!
	if d77 is protocol.VoxelShapesPacket {
		assert d77.shapes[0].cells.storage == [u8(1), 0, 1, 0]
		assert d77.name_map[0].name == 'stone'
		assert d77.custom_shape_count == 1
		println('  -> VoxelShapes shapes=${d77.shapes.len} name=${d77.name_map[0].name} OK')
	}

	pshp := &protocol.PrimitiveShapesPacket{
		shapes: [protocol.PacketShapeData{
			network_id:   99
			has_location: true
			location:     types.Vector3{
				x: 1.0
				y: 2.0
				z: 3.0
			}
			has_color:    true
			color:        0xff00ff00
			payload_type: protocol.primitive_shape_payload_text
			text:         'hello'
			use_rotation: true
			depth_test:   true
		}]
	}
	d78 := roundtrip(pshp, mut pool)!
	if d78 is protocol.PrimitiveShapesPacket {
		assert d78.shapes[0].network_id == 99
		assert d78.shapes[0].location.x == 1.0
		assert d78.shapes[0].text == 'hello'
		assert d78.shapes[0].color == 0xff00ff00
		println('  -> PrimitiveShapes net=${d78.shapes[0].network_id} text=${d78.shapes[0].text} OK')
	}

	println('All round-trip tests passed.')
}
