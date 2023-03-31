using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using ModWobblyLife.Audio;

public class ModTrashCharacterDeathArea : ModNetworkBehaviour
{
    private byte RPC_CLIENT_PLAY_DEATH_SOUND;

    [SerializeField] private string deathSound;
    [SerializeField] private ModCameraFocus deathCameraFocus;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_PLAY_DEATH_SOUND = modNetworkObject.RegisterRPC(ClientPlayDeathSound);
    }

    void OnTriggerEnter(Collider other)
    {
        ModPlayerCharacter playerCharacter = other.GetComponentInParent<ModPlayerCharacter>();
        if(playerCharacter && !playerCharacter.IsDead())
        {
            playerCharacter.Kill(2.0f);

            ModPlayerController controller = playerCharacter.GetPlayerController();
            if(controller)
            {
                controller.SetOwnerCameraFocus(deathCameraFocus);
            }

            modNetworkObject.SendRPC(RPC_CLIENT_PLAY_DEATH_SOUND, ModRPCRecievers.All, transform.position);
        }
    }

    #region RPC Callbacks

    void ClientPlayDeathSound(ModNetworkReader reader, ModRPCInfo info)
    {
        Vector3 position = reader.ReadVector3();

        if(!string.IsNullOrEmpty(deathSound))
        {
            ModRuntimeManager.PlayOneShot(deathSound, position);
        }
    }

    #endregion
}
