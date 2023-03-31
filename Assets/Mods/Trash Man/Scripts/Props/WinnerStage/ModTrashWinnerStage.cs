using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;

public class ModTrashWinnerStageData : IModNetworkMessage
{
    public List<uint> winnersNetworkids = new List<uint>();
    public string bannerText;

    public void Deserialize(ModNetworkReader reader)
    {
        byte count = reader.ReadByte();

        winnersNetworkids.Clear();
        for (int i = 0; i < count; ++i)
        {
            winnersNetworkids.Add(reader.ReadUInt32());
        }

        bannerText = reader.ReadString();
    }

    public void Serialize(ModNetworkWriter writer)
    {
        byte count = (byte)winnersNetworkids.Count;

        writer.Write(count);

        for (int i = 0; i < count; ++i)
        {
            writer.Write(winnersNetworkids[i]);
        }

        writer.Write(bannerText);
    }
}

public class ModTrashWinnerStage : ModNetworkBehaviour
{
    private byte RPC_CLIENT_UPDATE_STAGE_DATA;

    [SerializeField] private TMPro.TextMeshPro bannerText;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] winnerSpawnPoints;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] losersSpawnPoints;
    [SerializeField] private ModCameraFocus cameraFocus;

    private ModTrashWinnerStageData stageData = new ModTrashWinnerStageData();

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_UPDATE_STAGE_DATA = modNetworkObject.RegisterRPC(ClientUpdateStageData);
    }

    public void ServerShowWinners(ModBaseGamemode gamemode, string bannerText, params ModPlayerController[] winnerControllers)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        stageData.bannerText = bannerText;
        stageData.winnersNetworkids.Clear();

        int spawnIndex_Winners = 0;
        int spawnIndex_Losers = 0;

        ModInstance.Instance.IterateModPlayerControllers(x =>
        {
            ModPlayerControllerInputManager inputManager = x.GetModPlayerControllerInputManager();
            if (inputManager)
            {
                inputManager.DisablePlayerTransformInput(this);
            }

            gamemode.DestroyPlayerCharacter(x);
            if (Array.IndexOf(winnerControllers, x) == -1)
            {
                if (winnerSpawnPoints != null)
                {
                    int index = (spawnIndex_Losers++) % losersSpawnPoints.Length;
                    ModPlayerCharacterSpawnPoint spawnPoint = losersSpawnPoints[index];
                    gamemode.SpawnPlayerCharacter(x, null, spawnPoint, false);
                }
            }
            else
            {
                if (winnerSpawnPoints != null)
                {
                    int index = (spawnIndex_Winners++) % winnerSpawnPoints.Length;
                    ModPlayerCharacterSpawnPoint spawnPoint = winnerSpawnPoints[index];
                    gamemode.SpawnPlayerCharacter(x, null, spawnPoint, false);
                }

                stageData.winnersNetworkids.Add(x.modNetworkObject.GetNetworkID());
            }

            if(cameraFocus)
            {
                x.SetOwnerCameraFocus(cameraFocus);
            }
        });

        modNetworkObject.SendRPC(RPC_CLIENT_UPDATE_STAGE_DATA, true, ModRPCRecievers.AllBuffered, stageData.Serialize());
        OnStageDataUpdated();
    }

    void OnStageDataUpdated()
    {
        if (bannerText)
        {
            bannerText.text = stageData.bannerText;
        }
    }

    #region RPC Callbacks

    void ClientUpdateStageData(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        reader.ReadNetworkMessage(stageData);
        OnStageDataUpdated();
    }

    #endregion
}
