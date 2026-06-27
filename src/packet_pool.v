module src

import src.serializer

pub struct PacketPool {
pub mut:
	factories map[u16]fn () Packet
}

pub fn new_packet_pool() PacketPool {
	mut p := PacketPool{
		factories: map[u16]fn () Packet{}
	}
	p.register(fn () Packet {
		return &LoginPacket{}
	})
	p.register(fn () Packet {
		return &PlayStatusPacket{}
	})
	p.register(fn () Packet {
		return &ServerToClientHandshakePacket{}
	})
	p.register(fn () Packet {
		return &ClientToServerHandshakePacket{}
	})
	p.register(fn () Packet {
		return &DisconnectPacket{}
	})
	p.register(fn () Packet {
		return &SetTimePacket{}
	})
	p.register(fn () Packet {
		return &TextPacket{}
	})
	p.register(fn () Packet {
		return &RequestNetworkSettingsPacket{}
	})
	p.register(fn () Packet {
		return &NetworkSettingsPacket{}
	})
	p.register(fn () Packet {
		return &RequestChunkRadiusPacket{}
	})
	p.register(fn () Packet {
		return &ChunkRadiusUpdatedPacket{}
	})
	p.register(fn () Packet {
		return &SetLocalPlayerAsInitializedPacket{}
	})
	p.register(fn () Packet {
		return &RespawnPacket{}
	})
	p.register(fn () Packet {
		return &AnimatePacket{}
	})
	p.register(fn () Packet {
		return &ContainerClosePacket{}
	})
	p.register(fn () Packet {
		return &ClientCacheStatusPacket{}
	})
	p.register(fn () Packet {
		return &SetDifficultyPacket{}
	})
	p.register(fn () Packet {
		return &NetworkStackLatencyPacket{}
	})
	p.register(fn () Packet {
		return &InteractPacket{}
	})
	p.register(fn () Packet {
		return &EmotePacket{}
	})
	p.register(fn () Packet {
		return &PlayerActionPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackClientResponsePacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackChunkRequestPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackDataInfoPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackChunkDataPacket{}
	})
	p.register(fn () Packet {
		return &RemoveActorPacket{}
	})
	p.register(fn () Packet {
		return &TakeItemActorPacket{}
	})
	p.register(fn () Packet {
		return &SetActorMotionPacket{}
	})
	p.register(fn () Packet {
		return &MoveActorAbsolutePacket{}
	})
	p.register(fn () Packet {
		return &SetHealthPacket{}
	})
	p.register(fn () Packet {
		return &SetSpawnPositionPacket{}
	})
	p.register(fn () Packet {
		return &ShowCreditsPacket{}
	})
	p.register(fn () Packet {
		return &BlockPickRequestPacket{}
	})
	p.register(fn () Packet {
		return &ActorPickRequestPacket{}
	})
	p.register(fn () Packet {
		return &SetPlayerGameTypePacket{}
	})
	p.register(fn () Packet {
		return &SpawnExperienceOrbPacket{}
	})
	p.register(fn () Packet {
		return &OnScreenTextureAnimationPacket{}
	})
	p.register(fn () Packet {
		return &SimpleEventPacket{}
	})
	p.register(fn () Packet {
		return &RefreshEntitlementsPacket{}
	})
	p.register(fn () Packet {
		return &TickingAreasLoadStatusPacket{}
	})
	p.register(fn () Packet {
		return &PlayerHotbarPacket{}
	})
	p.register(fn () Packet {
		return &GuiDataPickItemPacket{}
	})
	p.register(fn () Packet {
		return &HurtArmorPacket{}
	})
	p.register(fn () Packet {
		return &MobEquipmentPacket{}
	})
	p.register(fn () Packet {
		return &MobArmorEquipmentPacket{}
	})
	p.register(fn () Packet {
		return &InventorySlotPacket{}
	})
	p.register(fn () Packet {
		return &InventoryContentPacket{}
	})
	p.register(fn () Packet {
		return &ContainerOpenPacket{}
	})
	p.register(fn () Packet {
		return &ContainerSetDataPacket{}
	})
	p.register(fn () Packet {
		return &CreativeContentPacket{}
	})
	p.register(fn () Packet {
		return &BlockActorDataPacket{}
	})
	p.register(fn () Packet {
		return &ItemRegistryPacket{}
	})
	p.register(fn () Packet {
		return &UpdateEquipPacket{}
	})
	p.register(fn () Packet {
		return &SetActorDataPacket{}
	})
	p.register(fn () Packet {
		return &AddItemActorPacket{}
	})
	p.register(fn () Packet {
		return &MobEffectPacket{}
	})
	p.register(fn () Packet {
		return &MovePlayerPacket{}
	})
	p.register(fn () Packet {
		return &AddActorPacket{}
	})
	p.register(fn () Packet {
		return &UpdateAttributesPacket{}
	})
	p.register(fn () Packet {
		return &ChangeDimensionPacket{}
	})
	p.register(fn () Packet {
		return &SetCommandsEnabledPacket{}
	})
	p.register(fn () Packet {
		return &UpdateBlockPacket{}
	})
	p.register(fn () Packet {
		return &BlockEventPacket{}
	})
	p.register(fn () Packet {
		return &ActorEventPacket{}
	})
	p.register(fn () Packet {
		return &SetActorLinkPacket{}
	})
	p.register(fn () Packet {
		return &NetworkChunkPublisherUpdatePacket{}
	})
	p.register(fn () Packet {
		return &GameRulesChangedPacket{}
	})
	p.register(fn () Packet {
		return &SettingsCommandPacket{}
	})
	p.register(fn () Packet {
		return &UpdateSoftEnumPacket{}
	})
	p.register(fn () Packet {
		return &ModalFormRequestPacket{}
	})
	p.register(fn () Packet {
		return &ModalFormResponsePacket{}
	})
	p.register(fn () Packet {
		return &ServerSettingsRequestPacket{}
	})
	p.register(fn () Packet {
		return &ServerSettingsResponsePacket{}
	})
	p.register(fn () Packet {
		return &RemoveObjectivePacket{}
	})
	p.register(fn () Packet {
		return &ToastRequestPacket{}
	})
	p.register(fn () Packet {
		return &SetTitlePacket{}
	})
	p.register(fn () Packet {
		return &SetDisplayObjectivePacket{}
	})
	p.register(fn () Packet {
		return &NpcDialoguePacket{}
	})
	p.register(fn () Packet {
		return &LevelEventPacket{}
	})
	p.register(fn () Packet {
		return &StopSoundPacket{}
	})
	p.register(fn () Packet {
		return &PlaySoundPacket{}
	})
	p.register(fn () Packet {
		return &SpawnParticleEffectPacket{}
	})
	p.register(fn () Packet {
		return &PlayerFogPacket{}
	})
	p.register(fn () Packet {
		return &CameraShakePacket{}
	})
	p.register(fn () Packet {
		return &AddPaintingPacket{}
	})
	p.register(fn () Packet {
		return &TransferPacket{}
	})
	p.register(fn () Packet {
		return &OpenSignPacket{}
	})
	p.register(fn () Packet {
		return &AnvilDamagePacket{}
	})
	p.register(fn () Packet {
		return &PlayerStartItemCooldownPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundCloseFormPacket{}
	})
	p.register(fn () Packet {
		return &ScriptMessagePacket{}
	})
	p.register(fn () Packet {
		return &SimulationTypePacket{}
	})
	p.register(fn () Packet {
		return &DeathInfoPacket{}
	})
	p.register(fn () Packet {
		return &AwardAchievementPacket{}
	})
	p.register(fn () Packet {
		return &LevelSoundEventPacket{}
	})
	p.register(fn () Packet {
		return &AnimateEntityPacket{}
	})
	p.register(fn () Packet {
		return &MotionPredictionHintsPacket{}
	})
	p.register(fn () Packet {
		return &NpcRequestPacket{}
	})
	p.register(fn () Packet {
		return &CompletedUsingItemPacket{}
	})
	p.register(fn () Packet {
		return &MoveActorDeltaPacket{}
	})
	p.register(fn () Packet {
		return &SetLastHurtByPacket{}
	})
	p.register(fn () Packet {
		return &CurrentStructureFeaturePacket{}
	})
	p.register(fn () Packet {
		return &ServerboundLoadingScreenPacket{}
	})
	p.register(fn () Packet {
		return &PlayerToggleCrafterSlotRequestPacket{}
	})
	p.register(fn () Packet {
		return &SetDefaultGameTypePacket{}
	})
	p.register(fn () Packet {
		return &UpdatePlayerGameTypePacket{}
	})
	p.register(fn () Packet {
		return &CodeBuilderPacket{}
	})
	p.register(fn () Packet {
		return &LecternUpdatePacket{}
	})
	p.register(fn () Packet {
		return &PurchaseReceiptPacket{}
	})
	p.register(fn () Packet {
		return &ShowProfilePacket{}
	})
	p.register(fn () Packet {
		return &RequestPermissionsPacket{}
	})
	p.register(fn () Packet {
		return &ClientCacheBlobStatusPacket{}
	})
	p.register(fn () Packet {
		return &BossEventPacket{}
	})
	p.register(fn () Packet {
		return &UpdateBlockSyncedPacket{}
	})
	p.register(fn () Packet {
		return &BookEditPacket{}
	})
	p.register(fn () Packet {
		return &CommandRequestPacket{}
	})
	p.register(fn () Packet {
		return &SetScorePacket{}
	})
	p.register(fn () Packet {
		return &SetScoreboardIdentityPacket{}
	})
	p.register(fn () Packet {
		return &ShowStoreOfferPacket{}
	})
	p.register(fn () Packet {
		return &AgentAnimationPacket{}
	})
	p.register(fn () Packet {
		return &ServerPlayerPostMovePositionPacket{}
	})
	p.register(fn () Packet {
		return &UpdateClientInputLocksPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundControlSchemeSetPacket{}
	})
	p.register(fn () Packet {
		return &UpdateAdventureSettingsPacket{}
	})
	p.register(fn () Packet {
		return &MultiplayerSettingsPacket{}
	})
	p.register(fn () Packet {
		return &SetPlayerInventoryOptionsPacket{}
	})
	p.register(fn () Packet {
		return &EmoteListPacket{}
	})
	p.register(fn () Packet {
		return &SetHudPacket{}
	})
	p.register(fn () Packet {
		return &RequestAbilityPacket{}
	})
	p.register(fn () Packet {
		return &CodeBuilderSourcePacket{}
	})
	p.register(fn () Packet {
		return &GameTestRequestPacket{}
	})
	p.register(fn () Packet {
		return &LessonProgressPacket{}
	})
	p.register(fn () Packet {
		return &ServerStatsPacket{}
	})
	p.register(fn () Packet {
		return &PartyChangedPacket{}
	})
	p.register(fn () Packet {
		return &CommandBlockUpdatePacket{}
	})
	p.register(fn () Packet {
		return &AddBehaviorTreePacket{}
	})
	p.register(fn () Packet {
		return &RemoveVolumeEntityPacket{}
	})
	p.register(fn () Packet {
		return &SyncActorPropertyPacket{}
	})
	p.register(fn () Packet {
		return &ServerboundDataDrivenScreenClosedPacket{}
	})
	p.register(fn () Packet {
		return &PartyDestinationCookieResponsePacket{}
	})
	p.register(fn () Packet {
		return &SendPartyDestinationCookiePacket{}
	})
	p.register(fn () Packet {
		return &PlayerVideoCapturePacket{}
	})
	p.register(fn () Packet {
		return &UpdateClientOptionsPacket{}
	})
	p.register(fn () Packet {
		return &PacketViolationWarningPacket{}
	})
	p.register(fn () Packet {
		return &MovementEffectPacket{}
	})
	p.register(fn () Packet {
		return &LegacyTelemetryEventPacket{}
	})
	p.register(fn () Packet {
		return &CorrectPlayerMovePredictionPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundTextureShiftPacket{}
	})
	p.register(fn () Packet {
		return &ChangeMobPropertyPacket{}
	})
	p.register(fn () Packet {
		return &UpdateTradePacket{}
	})
	p.register(fn () Packet {
		return &PlayerArmorDamagePacket{}
	})
	p.register(fn () Packet {
		return &MapInfoRequestPacket{}
	})
	p.register(fn () Packet {
		return &CameraPacket{}
	})
	p.register(fn () Packet {
		return &PlayerLocationPacket{}
	})
	p.register(fn () Packet {
		return &AgentActionEventPacket{}
	})
	p.register(fn () Packet {
		return &CreatePhotoPacket{}
	})
	p.register(fn () Packet {
		return &ClientCameraAimAssistPacket{}
	})
	p.register(fn () Packet {
		return &AutomationClientConnectPacket{}
	})
	p.register(fn () Packet {
		return &UnlockedRecipesPacket{}
	})
	p.register(fn () Packet {
		return &EditorNetworkPacket{}
	})
	p.register(fn () Packet {
		return &EduUriResourcePacket{}
	})
	p.register(fn () Packet {
		return &FeatureRegistryPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundDataDrivenUIReloadPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundDataDrivenUICloseScreenPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundDataDrivenUIShowScreenPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePacksReadyForValidationPacket{}
	})
	p.register(fn () Packet {
		return &ContainerRegistryCleanupPacket{}
	})
	p.register(fn () Packet {
		return &PlayerUpdateEntityOverridesPacket{}
	})
	p.register(fn () Packet {
		return &DebugInfoPacket{}
	})
	p.register(fn () Packet {
		return &PositionTrackingDBClientRequestPacket{}
	})
	p.register(fn () Packet {
		return &PositionTrackingDBServerBroadcastPacket{}
	})
	p.register(fn () Packet {
		return &AddVolumeEntityPacket{}
	})
	p.register(fn () Packet {
		return &MapCreateLockedCopyPacket{}
	})
	p.register(fn () Packet {
		return &StructureTemplateDataResponsePacket{}
	})
	p.register(fn () Packet {
		return &SubChunkRequestPacket{}
	})
	p.register(fn () Packet {
		return &AvailableActorIdentifiersPacket{}
	})
	p.register(fn () Packet {
		return &GameTestResultsPacket{}
	})
	p.register(fn () Packet {
		return &LabTablePacket{}
	})
	p.register(fn () Packet {
		return &ClientboundUpdateSoundDataPacket{}
	})
	p.register(fn () Packet {
		return &PhotoTransferPacket{}
	})
	p.register(fn () Packet {
		return &SubClientLoginPacket{}
	})
	p.register(fn () Packet {
		return &CameraAimAssistPacket{}
	})
	p.register(fn () Packet {
		return &ClientCacheMissResponsePacket{}
	})
	p.register(fn () Packet {
		return &UpdateAbilitiesPacket{}
	})
	p.register(fn () Packet {
		return &JigsawStructureDataPacket{}
	})
	p.register(fn () Packet {
		return &DimensionDataPacket{}
	})
	p.register(fn () Packet {
		return &UpdateSubChunkBlocksPacket{}
	})
	p.register(fn () Packet {
		return &CommandOutputPacket{}
	})
	p.register(fn () Packet {
		return &LevelChunkPacket{}
	})
	p.register(fn () Packet {
		return &TrimDataPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePackStackPacket{}
	})
	p.register(fn () Packet {
		return &ResourcePacksInfoPacket{}
	})
	p.register(fn () Packet {
		return &StructureBlockUpdatePacket{}
	})
	p.register(fn () Packet {
		return &StructureTemplateDataRequestPacket{}
	})
	p.register(fn () Packet {
		return &SubChunkPacket{}
	})
	p.register(fn () Packet {
		return &PlayerEnchantOptionsPacket{}
	})
	p.register(fn () Packet {
		return &LocatorBarPacket{}
	})
	p.register(fn () Packet {
		return &GraphicsOverrideParameterPacket{}
	})
	p.register(fn () Packet {
		return &CameraSplinePacket{}
	})
	p.register(fn () Packet {
		return &CameraAimAssistActorPriorityPacket{}
	})
	p.register(fn () Packet {
		return &CameraInstructionPacket{}
	})
	p.register(fn () Packet {
		return &EducationSettingsPacket{}
	})
	p.register(fn () Packet {
		return &ServerboundPackSettingChangePacket{}
	})
	p.register(fn () Packet {
		return &ServerStoreInfoPacket{}
	})
	p.register(fn () Packet {
		return &ServerPresenceInfoPacket{}
	})
	p.register(fn () Packet {
		return &PlayerSkinPacket{}
	})
	p.register(fn () Packet {
		return &AddPlayerPacket{}
	})
	p.register(fn () Packet {
		return &PlayerListPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundDebugRendererPacket{}
	})
	p.register(fn () Packet {
		return &ClientMovementPredictionSyncPacket{}
	})
	p.register(fn () Packet {
		return &LevelEventGenericPacket{}
	})
	p.register(fn () Packet {
		return &ServerboundDiagnosticsPacket{}
	})
	p.register(fn () Packet {
		return &ServerboundDataStorePacket{}
	})
	p.register(fn () Packet {
		return &SyncWorldClocksPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundAttributeLayerSyncPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundDataStorePacket{}
	})
	p.register(fn () Packet {
		return &VoxelShapesPacket{}
	})
	p.register(fn () Packet {
		return &PrimitiveShapesPacket{}
	})
	p.register(fn () Packet {
		return &CameraAimAssistPresetsPacket{}
	})
	p.register(fn () Packet {
		return &CameraPresetsPacket{}
	})
	p.register(fn () Packet {
		return &ClientboundMapItemDataPacket{}
	})
	p.register(fn () Packet {
		return &BiomeDefinitionListPacket{}
	})
	return p
}

pub fn (mut p PacketPool) register(factory fn () Packet) {
	pkt := factory()
	p.factories[pkt.pid()] = factory
}

pub fn (p &PacketPool) get_packet_by_id(pid u16) ?Packet {
	factory := p.factories[pid] or { return none }
	return factory()
}

pub fn (p &PacketPool) decode(mut r serializer.Reader) !Packet {
	header := read_packet_header(mut r)!
	mut pkt := p.get_packet_by_id(header.pid) or {
		return error('unknown packet id 0x${header.pid:x}')
	}
	pkt.decode_payload(mut r)!
	return pkt
}
