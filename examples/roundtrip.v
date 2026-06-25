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

	println('All round-trip tests passed.')
}
