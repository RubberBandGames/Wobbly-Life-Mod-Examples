using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideAndSeekWinnerStageData : IModNetworkMessage
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

public class ModHideAndSeekWinningStage : ModNetworkBehaviour
{
    private byte RPC_CLIENT_UPDATE_STAGE_DATA;

    [SerializeField] private TMPro.TextMeshPro bannerText;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] winnerSpawnPoints;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] losersSpawnPoints;
    [SerializeField] private ModCameraFocus cameraFocus;

    private HideAndSeekWinnerStageData stageData = new HideAndSeekWinnerStageData();

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_UPDATE_STAGE_DATA = modNetworkObject.RegisterRPC(ClientUpdateStageData);
    }

    /// <summary>
    /// Shows the winnenrs
    /// </summary>
    /// <param name="gamemode"></param>
    /// <param name="bannerText"></param>
    /// <param name="winnerControllers"></param>
    public void ServerShowWinners(ModBaseGamemode gamemode, string bannerText, params ModPlayerController[] winnerControllers)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        // Put banner text in packet to be sent to all players
        stageData.bannerText = bannerText;
        stageData.winnersNetworkids.Clear();

        int spawnIndex_Winners = 0;
        int spawnIndex_Losers = 0;

        ModInstance.Instance.IterateModPlayerControllers(x =>
        {
            // Disables players input so they can't move on the winner stage
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

                // Add winners player controller networkids into the packet so clients know who the winners are
                stageData.winnersNetworkids.Add(x.modNetworkObject.GetNetworkID());
            }

            // Assign everyones camera to the winner stage camera
            if (cameraFocus)
            {
                x.SetOwnerCameraFocus(cameraFocus);
            }
        });

        // Sends the stage data packet to all clients
        modNetworkObject.SendRPC(RPC_CLIENT_UPDATE_STAGE_DATA, true, ModRPCRecievers.AllBuffered, stageData.Serialize());
        OnStageDataUpdated();
    }

    void OnStageDataUpdated()
    {
        // Assign banner text to banner
        if (bannerText)
        {
            bannerText.text = stageData.bannerText;
        }
    }

    #region RPC Callbacks

    void ClientUpdateStageData(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        // Reads the stage data packet
        reader.ReadNetworkMessage(stageData);

        // Updates the stage data
        OnStageDataUpdated();
    }

    #endregion
}
