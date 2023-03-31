using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using ModWobblyLife.Audio;

public class ModTrashPowerupConveyorTrashSystem : ModTrashPowerupBehaviour
{
    private byte RPC_CLIENT_PLAY_SOUND;

    [SerializeField] private ModTouchButton[] touchButtons;
    [SerializeField] private ModTrashSpecialSpawner[] specialSpawners;
    [SerializeField] private float buttonCooldown = 30.0f;
    [SerializeField] private float spawnLastSeconds = 5.0f;
    [SerializeField] private float spawnRate = 0.5f;
    [SerializeField] private string pressedSound = "event:/TrashManDemo/TrashManDemo_ButtonPressed";

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_PLAY_SOUND = modNetworkObject.RegisterRPC(ClientPlaySound);
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if(touchButtons != null)
        {
            foreach(ModTouchButton button in touchButtons)
            {
                if (button)
                {
                    button.onButtonPressed.AddListener(OnTouchButtonPressed);
                }
            }
        }
    }

    void OnTouchButtonPressed()
    {
        if(modNetworkObject.IsServer())
        {
            StartCoroutine(ServerCooldown());
        }
    }

    IEnumerator ServerCooldown()
    {
        modNetworkObject.SendRPC(RPC_CLIENT_PLAY_SOUND, ModRPCRecievers.All);

        if (touchButtons != null)
        {
            foreach (ModTouchButton button in touchButtons)
            {
                if (button)
                {
                    button.ServerSetButtonOn(false);
                }
            }
        }

        if (specialSpawners != null)
        {
            foreach(ModTrashSpecialSpawner specialSpawner in specialSpawners)
            {
                if(specialSpawner)
                {
                    specialSpawner.ServerTurnOnSpecialSpawner(spawnRate);
                }
            }
        }

        yield return new WaitForSeconds(spawnLastSeconds);

        if (specialSpawners != null)
        {
            foreach (ModTrashSpecialSpawner specialSpawner in specialSpawners)
            {
                if (specialSpawner)
                {
                    specialSpawner.ServerTurnOffSpecialSpawner();
                }
            }
        }

        yield return new WaitForSeconds(buttonCooldown);

        if (touchButtons != null)
        {
            foreach (ModTouchButton button in touchButtons)
            {
                if (button)
                {
                    button.ServerSetButtonOn(true);
                }
            }
        }
    }

    public override void ServerActivate()
    {
        OnTouchButtonPressed();
    }

    #region RPC Callbacks

    void ClientPlaySound(ModNetworkReader reader, ModRPCInfo info)
    {
        if(!string.IsNullOrEmpty(pressedSound))
        {
            ModRuntimeManager.PlayOneShot(pressedSound, transform.position);
        }
    }

    #endregion

    public override float GetDuration()
    {
        return spawnLastSeconds;
    }
}
