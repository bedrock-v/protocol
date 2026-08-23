module current

import protocol.version.v1001.enums as enums_1001
import protocol.version.v2168.enums as enums_2168
import protocol.version.v2192.enums as enums_2192
import protocol.version.v662.enums as enums_662
import protocol.version.v776.enums as enums_776
import protocol.version.v898.enums as enums_898
import protocol.version.v924.enums as enums_924
import protocol.version.v944.enums as enums_944
import protocol.version.v975.enums as enums_975
import protocol.version.v1001.packets as packets_1001
import protocol.version.v2168.packets as packets_2168
import protocol.version.v2192.packets as packets_2192
import protocol.version.v662.packets as packets_662
import protocol.version.v685.packets as packets_685
import protocol.version.v712.packets as packets_712
import protocol.version.v729.packets as packets_729
import protocol.version.v776.packets as packets_776
import protocol.version.v898.packets as packets_898
import protocol.version.v924.packets as packets_924
import protocol.version.v944.packets as packets_944
import protocol.version.v975.packets as packets_975
import protocol.version.v1001.types as types_1001
import protocol.version.v2168.types as types_2168
import protocol.version.v2192.types as types_2192
import protocol.version.v662.types as types_662
import protocol.version.v712.types as types_712
import protocol.version.v776.types as types_776
import protocol.version.v800.types as types_800
import protocol.version.v818.types as types_818
import protocol.version.v898.types as types_898
import protocol.version.v944.types as types_944

// Packets.
pub type ActorEventPacket = packets_975.ActorEventPacket
pub type AddActorPacket = packets_2168.AddActorPacket
pub type AddItemActorPacket = packets_2168.AddItemActorPacket
pub type AddPlayerListEntry = packets_2192.AddPlayerListEntry
pub type AddPlayerPacket = packets_2168.AddPlayerPacket
pub type AnimatePacket = packets_898.AnimatePacket
pub type AnimatePacketAction = packets_898.AnimatePacketAction
pub type AttributeData = packets_729.AttributeData
pub type AttributeEntry = packets_2168.AttributeEntry
pub type AttributeModifier = packets_729.AttributeModifier
pub type AvailableActorIdentifiersPacket = packets_662.AvailableActorIdentifiersPacket
pub type AvailableCommandsPacket = packets_898.AvailableCommandsPacket
pub type BiomeDefinitionListPacket = packets_1001.BiomeDefinitionListPacket
pub type BiomeEntry = packets_1001.BiomeEntry
pub type BlockActorDataPacket = packets_944.BlockActorDataPacket
pub type BlockPickRequestPacket = packets_662.BlockPickRequestPacket
pub type BlockProperty = packets_2168.BlockProperty
pub type BookEditPacket = packets_924.BookEditPacket
pub type BossEventPacket = packets_2192.BossEventPacket
pub type BossEventUpdateType = packets_2192.BossEventUpdateType
pub type ChangeDimensionPacket = packets_712.ChangeDimensionPacket
pub type ChunkRadiusUpdatedPacket = packets_662.ChunkRadiusUpdatedPacket
pub type ClientToServerHandshakePacket = packets_662.ClientToServerHandshakePacket
pub type CommandPermissionLevelString = packets_898.CommandPermissionLevelString
pub type CommandRequestPacket = packets_898.CommandRequestPacket
pub type CommandsEntry = packets_898.CommandsEntry
pub type ContainerClosePacket = packets_685.ContainerClosePacket
pub type ContainerOpenPacket = packets_944.ContainerOpenPacket
pub type CreativeContentPacket = packets_2168.CreativeContentPacket
pub type CreativeItemCategory = packets_2168.CreativeItemCategory
pub type CreativeItemData = packets_2168.CreativeItemData
pub type CreativeItemGroup = packets_2168.CreativeItemGroup
pub type DisconnectMessage = packets_2192.DisconnectMessage
pub type DisconnectPacket = packets_2192.DisconnectPacket
pub type EnumDataEntry = packets_898.EnumDataEntry
pub type HeightMapDataType = packets_2192.HeightMapDataType
pub type InteractPacket = packets_898.InteractPacket
pub type InteractPacketAction = packets_898.InteractPacketAction
pub type InventoryContentPacket = packets_2168.InventoryContentPacket
pub type InventorySlotPacket = packets_2168.InventorySlotPacket
pub type InventoryTransactionPacket = packets_2192.InventoryTransactionPacket
pub type ItemComponentPacket = packets_776.ItemComponentPacket
pub type ItemStackRequestPacket = packets_2168.ItemStackRequestPacket
pub type ItemStackResponsePacket = packets_2192.ItemStackResponsePacket
pub type ItemsEntry = packets_776.ItemsEntry
pub type JigsawStructureDataPacket = packets_712.JigsawStructureDataPacket
pub type LevelChunkPacket = packets_2168.LevelChunkPacket
pub type LevelEventPacket = packets_662.LevelEventPacket
pub type LevelSoundEventPacket = packets_1001.LevelSoundEventPacket
pub type LoginPacket = packets_662.LoginPacket
pub type MobEffectEvent = packets_898.MobEffectEvent
pub type MobEffectPacket = packets_898.MobEffectPacket
pub type MobEquipmentPacket = packets_2168.MobEquipmentPacket
pub type ModalFormRequestPacket = packets_662.ModalFormRequestPacket
pub type ModalFormResponsePacket = packets_662.ModalFormResponsePacket
pub type MoveActorAbsolutePacket = packets_662.MoveActorAbsolutePacket
pub type MovePlayerPacket = packets_2168.MovePlayerPacket
pub type NetworkChunkPublisherUpdatePacket = packets_662.NetworkChunkPublisherUpdatePacket
pub type NetworkSettingsPacket = packets_662.NetworkSettingsPacket
pub type OpenSignPacket = packets_944.OpenSignPacket
pub type OverloadsEntry = packets_898.OverloadsEntry
pub type PackEntry = packets_898.PackEntry
pub type ParameterDataEntry = packets_898.ParameterDataEntry
pub type PlayStatusPacket = packets_662.PlayStatusPacket
pub type PlayerActionPacket = packets_944.PlayerActionPacket
pub type PlayerAuthInputPacket = packets_2192.PlayerAuthInputPacket
pub type PlayerHotbarPacket = packets_662.PlayerHotbarPacket
pub type PlayerListAdd = packets_2192.PlayerListAdd
pub type PlayerListEntry = packets_2192.PlayerListEntry
pub type PlayerListPacket = packets_2192.PlayerListPacket
pub type PlayerListRemove = packets_2192.PlayerListRemove
pub type RemoveActorPacket = packets_662.RemoveActorPacket
pub type RemoveObjectivePacket = packets_662.RemoveObjectivePacket
pub type RequestChunkRadiusPacket = packets_662.RequestChunkRadiusPacket
pub type RequestNetworkSettingsPacket = packets_662.RequestNetworkSettingsPacket
pub type RequestsEntry = packets_2168.RequestsEntry
pub type ResourcePackChunkDataPacket = packets_662.ResourcePackChunkDataPacket
pub type ResourcePackChunkRequestPacket = packets_662.ResourcePackChunkRequestPacket
pub type ResourcePackClientResponsePacket = packets_2168.ResourcePackClientResponsePacket
pub type ResourcePackDataInfoPacket = packets_662.ResourcePackDataInfoPacket
pub type ResourcePackEntry = packets_2168.ResourcePackEntry
pub type ResourcePackStackPacket = packets_898.ResourcePackStackPacket
pub type ResourcePacksInfoPacket = packets_2168.ResourcePacksInfoPacket
pub type RespawnPacket = packets_662.RespawnPacket
pub type ScoreEntryChangeFakePlayer = packets_2168.ScoreEntryChangeFakePlayer
pub type ScorePacketEntry = packets_2168.ScorePacketEntry
pub type ServerToClientHandshakePacket = packets_662.ServerToClientHandshakePacket
pub type SetActorDataPacket = packets_2168.SetActorDataPacket
pub type SetActorMotionPacket = packets_662.SetActorMotionPacket
pub type SetDifficultyPacket = packets_662.SetDifficultyPacket
pub type SetDisplayObjectivePacket = packets_662.SetDisplayObjectivePacket
pub type SetLocalPlayerAsInitializedPacket = packets_662.SetLocalPlayerAsInitializedPacket
pub type SetPlayerGameTypePacket = packets_662.SetPlayerGameTypePacket
pub type SetScorePacket = packets_2168.SetScorePacket
pub type SetTimePacket = packets_662.SetTimePacket
pub type SetTitlePacket = packets_712.SetTitlePacket
pub type SetTitleType = packets_712.SetTitleType
pub type StartGamePacket = packets_2168.StartGamePacket
pub type StopSoundPacket = packets_712.StopSoundPacket
pub type SubChunkDataEntry = packets_2192.SubChunkDataEntry
pub type SubChunkPacket = packets_2192.SubChunkPacket
pub type SubChunkRequestPacket = packets_1001.SubChunkRequestPacket
pub type TakeItemActorPacket = packets_662.TakeItemActorPacket
pub type TextPacket = packets_924.TextPacket
pub type UpdateAbilitiesPacket = packets_776.UpdateAbilitiesPacket
pub type UpdateAdventureSettingsPacket = packets_662.UpdateAdventureSettingsPacket
pub type UpdateAttributesPacket = packets_729.UpdateAttributesPacket
pub type UpdateBlockPacket = packets_944.UpdateBlockPacket
pub type VoxelCells = packets_2168.VoxelCells
pub type VoxelShape = packets_2168.VoxelShape
pub type VoxelShapeNameEntry = packets_2168.VoxelShapeNameEntry
pub type VoxelShapesPacket = packets_2168.VoxelShapesPacket

// Payload types.
pub type ActorLink = types_712.ActorLink
pub type ActorRuntimeID = types_662.ActorRuntimeID
pub type ActorUniqueID = types_662.ActorUniqueID
pub type AdventureSettings = types_662.AdventureSettings
pub type BaseGameVersion = types_662.BaseGameVersion
pub type BiomeDefinition = types_1001.BiomeDefinition
pub type BlockPos = types_662.BlockPos
pub type ChunkPos = types_662.ChunkPos
pub type Color = types_800.Color
pub type CommandOriginData = types_898.CommandOriginData
pub type DataItem = types_2168.DataItem
pub type EduSharedUriResource = types_662.EduSharedUriResource
pub type Experiments = types_662.Experiments
pub type FullContainerName = types_944.FullContainerName
pub type GameRuleLegacyData = types_2168.GameRuleLegacyData
pub type ItemStackActionConsume = types_2168.ItemStackActionConsume
pub type ItemStackActionCraftCreative = types_2168.ItemStackActionCraftCreative
pub type ItemStackActionDestroy = types_2168.ItemStackActionDestroy
pub type ItemStackActionDrop = types_2168.ItemStackActionDrop
pub type ItemStackActionPlace = types_2168.ItemStackActionPlace
pub type ItemStackActionSwap = types_2168.ItemStackActionSwap
pub type ItemStackActionTake = types_2168.ItemStackActionTake
pub type ItemStackRequestActionType = types_2168.ItemStackRequestActionType
pub type ItemStackRequestSlotInfo = types_2168.ItemStackRequestSlotInfo
pub type UseItemTransactionData = types_2192.UseItemTransactionData
pub type ItemStackResponseContainerInfo = types_2192.ItemStackResponseContainerInfo
pub type ItemStackResponseInfo = types_2192.ItemStackResponseInfo
pub type ItemStackResponseSlotInfo = types_2192.ItemStackResponseSlotInfo
pub type LevelSettings = types_2168.LevelSettings
pub type MoveActorAbsoluteData = types_662.MoveActorAbsoluteData
pub type MovePlayerTeleportData = types_2168.MovePlayerTeleportData
pub type NetworkBlockPosition = types_944.NetworkBlockPosition
pub type NetworkItemInstanceDescriptor = types_2168.NetworkItemInstanceDescriptor
pub type NetworkItemStackDescriptor = types_2168.NetworkItemStackDescriptor
pub type NetworkItemStackDescriptorV2 = types_2168.NetworkItemStackDescriptorV2
pub type NetworkPermissions = types_662.NetworkPermissions
pub type PackedItemUseLegacyInventoryTransaction = types_2192.PackedItemUseLegacyInventoryTransaction
pub type PersonaPiecesEntry = types_2192.PersonaPiecesEntry
pub type PieceTintColorsEntry = types_2192.PieceTintColorsEntry
pub type PlayerBlockActionData = types_2168.PlayerBlockActionData
pub type PropertySyncData = types_662.PropertySyncData
pub type RedactableString = types_2168.RedactableString
pub type ScoreboardId = types_662.ScoreboardId
pub type SerializedAbilitiesData = types_776.SerializedAbilitiesData
pub type SerializedAbilitiesLayer = types_776.SerializedAbilitiesLayer
pub type SerializedLayer = types_776.SerializedLayer
pub type SerializedSkin = types_2192.SerializedSkin
pub type SerializedSkinAnimationFrame = types_2192.SerializedSkinAnimationFrame
pub type SpawnSettings = types_662.SpawnSettings
pub type SubChunkPos = types_2168.SubChunkPos
pub type SyncedPlayerMovementSettings = types_818.SyncedPlayerMovementSettings
pub type Uuid = types_662.Uuid

// Enums.
pub type AbilitiesIndex = enums_662.AbilitiesIndex
pub type ActorEvent = enums_975.ActorEvent
pub type ArmSizeType = enums_2192.ArmSizeType
pub type BuildPlatform = enums_662.BuildPlatform
pub type ChatRestrictionLevel = enums_662.ChatRestrictionLevel
pub type CommandOriginType = enums_898.CommandOriginType
pub type CommandPermissionLevel = enums_662.CommandPermissionLevel
pub type ConnectionFailReason = enums_1001.ConnectionFailReason
pub type ContainerEnumName = enums_944.ContainerEnumName
pub type ContainerID = enums_662.ContainerID
pub type ContainerType = enums_662.ContainerType
pub type DataItemByte = enums_2168.DataItemByte
pub type DataItemFloat = enums_2168.DataItemFloat
pub type DataItemInt = enums_2168.DataItemInt
pub type DataItemInt64 = enums_2168.DataItemInt64
pub type DataItemShort = enums_2168.DataItemShort
pub type DataItemString = enums_2168.DataItemString
pub type DataItemType = enums_2168.DataItemType
pub type Difficulty = enums_662.Difficulty
pub type EditorWorldType = enums_662.EditorWorldType
pub type EducationEditionOffer = enums_662.EducationEditionOffer
pub type GamePublishSetting = enums_662.GamePublishSetting
pub type GameType = enums_662.GameType
pub type GeneratorType = enums_662.GeneratorType
pub type ItemStackNetResult = enums_2168.ItemStackNetResult
pub type ItemUseInventoryTransactionType = enums_662.ItemUseInventoryTransactionType
pub type ItemVersion = enums_776.ItemVersion
pub type ObjectiveSortOrder = enums_662.ObjectiveSortOrder
pub type PackType = enums_662.PackType
pub type PacketCompressionAlgorithm = enums_662.PacketCompressionAlgorithm
pub type PlayStatus = enums_662.PlayStatus
pub type PlayerActionType = enums_662.PlayerActionType
pub type PlayerAuthInputData = enums_2168.PlayerAuthInputData
pub type PlayerPermissionLevel = enums_662.PlayerPermissionLevel
pub type PlayerPositionMode = enums_2168.PlayerPositionMode
pub type PlayerRespawnState = enums_662.PlayerRespawnState
pub type SpawnBiomeType = enums_662.SpawnBiomeType
pub type TextChat = enums_924.TextChat
pub type TextPacketType = enums_924.TextPacketType
pub type TextRaw = enums_924.TextRaw
pub type TextTranslate = enums_924.TextTranslate

// Collections and enum values that a caller has to hand to a packet field
// directly. V keeps an alias apart from the type it stands for once it is
// wrapped in an array or reached through an enum value, so these are exported
// in the shape the field expects.
pub type AttributeEntries = []packets_2168.AttributeEntry
pub type ScorePacketEntries = []packets_2168.ScorePacketEntry
pub type SerializedLayers = []types_776.SerializedLayer

pub const connection_fail_disconnect_packet = enums_1001.ConnectionFailReason.disconnect_packet
pub const education_edition_offer_none = enums_662.EducationEditionOffer.@none
