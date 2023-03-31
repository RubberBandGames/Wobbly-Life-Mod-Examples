using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using Random = UnityEngine.Random;
using ModWobblyLife.Audio;

[Serializable]
public class ModTrashPowerupMachineData
{
    [SerializeField] private ModTrashPowerupBehaviour powerup;
    [SerializeField] private GameObject displayObject;

    public void ServerActivate()
    {
        if (powerup)
        {
            powerup.ServerActivate();
        }
    }

    public void SetDisplayObjectVisible(bool bIsVisible)
    {
        if (displayObject)
        {
            displayObject.SetActive(bIsVisible);
        }
    }

    public float GetDuration()
    {
        return powerup ? powerup.GetDuration() : 0.0f;
    }
}

public class ModTrashPowerupMachine : ModNetworkBehaviour
{
    private byte RPC_CLIENT_START_RANDOMIZER;
    private byte RPC_CLIENT_POWERUP_FINISHED;
    private byte RPC_CLIENT_END_RANDOMIZER;

    [SerializeField] private ModTrashPowerupMachineData[] machineDatas;
    [SerializeField] private ModTouchButton button;
    [SerializeField] private Animator animator;
    [SerializeField] private float cooldownSeconds = 30.0f;
    [SerializeField] private Renderer machineRenderer;
    [SerializeField] private Material readyMaterial;
    [SerializeField] private Material notReadyMaterial;
    [SerializeField] private string readySound;
    [SerializeField] private string usingSound;

    private int shownPotentialPowerupIndex;
    private int seed;
    private int previousShowingIndex;

    private int actualPowerupIndex;
    private bool bHasActivatedPowerup;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_START_RANDOMIZER = modNetworkObject.RegisterRPC(ClientStartRandomizer);
        RPC_CLIENT_POWERUP_FINISHED = modNetworkObject.RegisterRPC(ClientPowerupFinished);
        RPC_CLIENT_END_RANDOMIZER = modNetworkObject.RegisterRPC(ClientEndRandomizer);
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if(button)
        {
            button.onButtonPressed.AddListener(OnButtonPressed);
        }
    }

    public void ShowPotentalPowerup()
    {
        int newSeed = shownPotentialPowerupIndex + seed;
        ++shownPotentialPowerupIndex;

        Random.InitState(newSeed);

        int index = Random.Range(0, machineDatas.Length);

        if(previousShowingIndex == index)
        {
            index++;
            index = index % machineDatas.Length;
        }

        ModTrashPowerupMachineData previousShowing = machineDatas[previousShowingIndex];
        if(previousShowing != null)
        {
            previousShowing.SetDisplayObjectVisible(false);
        }

        previousShowingIndex = index;
        ModTrashPowerupMachineData showing = machineDatas[index];
        if (showing != null)
        {
            showing.SetDisplayObjectVisible(true);
        }
    }

    public void ShowActualPowerup()
    {
        ModTrashPowerupMachineData previousShowing = machineDatas[previousShowingIndex];
        if (previousShowing != null)
        {
            previousShowing.SetDisplayObjectVisible(false);
        }

        previousShowingIndex = actualPowerupIndex;

        ModTrashPowerupMachineData showing = machineDatas[actualPowerupIndex];
        if (showing != null)
        {
            showing.SetDisplayObjectVisible(true);
        }
    }

    public void ActivateActualPowerup()
    {
        ModTrashPowerupMachineData showing = machineDatas[actualPowerupIndex];
        if (showing != null)
        {
            if (modNetworkObject != null && modNetworkObject.IsServer())
            {
                showing.ServerActivate();
            }
        }

        bHasActivatedPowerup = true;
    }

    void OnButtonPressed()
    {
        if (modNetworkObject != null && modNetworkObject.IsServer())
        {
            int actualPowerupIndex = Random.Range(0, machineDatas.Length);
            int seed = Random.Range(0, int.MaxValue);

            modNetworkObject.SendRPC(RPC_CLIENT_START_RANDOMIZER, ModRPCRecievers.All, seed,actualPowerupIndex);

            StartCoroutine(Cooldown());
        }
    }

    IEnumerator Cooldown()
    {
        if(button)
        {
            button.ServerSetButtonOn(false);
        }

        yield return new WaitUntil(() => bHasActivatedPowerup);
        bHasActivatedPowerup = false;

        float adjustedCooldownSecs = cooldownSeconds;

        ModTrashPowerupMachineData showing = machineDatas[actualPowerupIndex];
        if (showing != null)
        {
            adjustedCooldownSecs -= showing.GetDuration();

            yield return new WaitForSeconds(showing.GetDuration());

            modNetworkObject.SendRPC(RPC_CLIENT_POWERUP_FINISHED, ModRPCRecievers.All);
        }

        yield return new WaitForSeconds(adjustedCooldownSecs);

        modNetworkObject.SendRPC(RPC_CLIENT_END_RANDOMIZER, ModRPCRecievers.All);

        if (button)
        {
            button.ServerSetButtonOn(true);
        }
    }

    void OnMachineReady()
    {
        if(machineRenderer)
        {
            Material[] materials = machineRenderer.sharedMaterials;
            materials[1] = readyMaterial;
            machineRenderer.sharedMaterials = materials;
        }

        if(!string.IsNullOrEmpty(readySound))
        {
            ModRuntimeManager.PlayOneShot(readySound, transform.position);
        }
    }

    void OnMachineNotReady()
    {
        if (machineRenderer)
        {
            Material[] materials = machineRenderer.sharedMaterials;
            materials[1] = notReadyMaterial;
            machineRenderer.sharedMaterials = materials;
        }
    }

    #region RPC Callbacks

    void ClientEndRandomizer(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        OnMachineReady();
    }

    void ClientStartRandomizer(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        seed = reader.ReadInt32();
        actualPowerupIndex = reader.ReadInt32();

        shownPotentialPowerupIndex = 0;

        if(animator)
        {
            animator.Play("Play");
        }

        if (!string.IsNullOrEmpty(usingSound))
        {
            ModRuntimeManager.PlayOneShot(usingSound, transform.position);
        }

        OnMachineNotReady();
    }

    void ClientPowerupFinished(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        ModTrashPowerupMachineData previousShowing = machineDatas[previousShowingIndex];
        if (previousShowing != null)
        {
            previousShowing.SetDisplayObjectVisible(false);
        }
    }

    #endregion
}
