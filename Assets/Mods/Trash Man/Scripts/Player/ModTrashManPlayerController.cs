using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using ModWobblyLife.UI;
using System;

public class ModTrashManPlayerController : ModPlayerController
{
    private byte RPC_CLIENT_SHOW_HIDE_INSTRUCTIONS;

    [SerializeField] private ModUIPlayerBasedCanvas instructionsUIPrefab;

    private ModUIElement winnerUIInstance;
    private ModUIElement instructionsInstance;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SHOW_HIDE_INSTRUCTIONS = modNetworkObject.RegisterRPC(ClientShowHideInstructions);
    }

    protected override void ModNetworkPost(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkPost(modNetworkObject);
    }

    protected override void ModReady()
    {
        base.ModReady();

        if (modNetworkObject.IsServer())
        {
            SetAllowedSavedClothes(false);
            SetAllowedToRespawn(false);
            ServerSetAllowedCustomClothingAbilities(false);
        }
    }

    protected override void OnServerPersistentDataLoaded()
    {
        base.OnServerPersistentDataLoaded();

        ServerLoadSavedClothesOnActivePlayer(ModClothingSelectionType.Hat, true);
    }

    protected override void OnPlayerCharacterSpawned(ModPlayerCharacter playerCharacter)
    {
        base.OnPlayerCharacterSpawned(playerCharacter);
    }

    public void ServerShowInstructions(bool bIsTrashMan)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SHOW_HIDE_INSTRUCTIONS, ModRPCRecievers.Owner, true, bIsTrashMan);
    }

    public void ServerHideInstructions()
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SHOW_HIDE_INSTRUCTIONS, ModRPCRecievers.Owner, false);
    }

    #region RPC Callbacks

    void ClientShowHideInstructions(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        bool bIsActive = reader.ReadBoolean();

        if(bIsActive)
        {
            bool bIsTrashMan = reader.ReadBoolean();

            ModPlayerControllerUI controllerUI = GetModPlayerControllerUI();
            if (controllerUI)
            {
                if (!instructionsInstance && instructionsUIPrefab)
                {
                    instructionsInstance = controllerUI.CreateUIOnGameplayCanvas(instructionsUIPrefab);
                }
            }

            ModUIPlayerBasedTrashInstructions trashInstructionsUI = instructionsInstance as ModUIPlayerBasedTrashInstructions;

            if (trashInstructionsUI)
            {
                if (bIsTrashMan)
                {
                    trashInstructionsUI.ShowTrashManInstructions();
                }
                else
                {
                    trashInstructionsUI.ShowGarbageInstructions();
                }
            }
        }
        else
        {
            if(instructionsInstance)
            {
                instructionsInstance.Hide();
                Destroy(instructionsInstance);
                instructionsInstance = null;
            }
        }
    }

    #endregion
}
