using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;
using System;
using ModWobblyLife.Audio;

public class ModTrashGameTimer : ModNetworkBehaviour
{
    private byte RPC_CLIENT_STARTSTOP;

    public Action<ModTrashGameTimer> onTimerFinished;

    [SerializeField] private TMPro.TextMeshPro[] timerTexts;
    [SerializeField] private string start2DSound = "event:/ModDemo_2D_GameMode_Start";
    [SerializeField] private string countdown2DSound = "event:/ModDemo_2D_GameMode_Countdown";
    [SerializeField] private string stop2DSound = "event:/ModDemo_2D_GameMode_Complete";

    private Coroutine timerCoroutine;
    private ulong secondsLeft;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_STARTSTOP = modNetworkObject.RegisterRPC(ClientStartStop);
    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        UpdateTimers(0);
    }

    IEnumerator Timer(ulong endTimestep)
    {
        ulong previousSecondsRemaining = 0;

        while (true)
        {
            yield return null;

            secondsLeft = GetSecondsLeft(endTimestep);

            if(previousSecondsRemaining != secondsLeft)
            {
                if(secondsLeft <= 10 && secondsLeft > 0)
                {
                    if(!string.IsNullOrEmpty(countdown2DSound))
                    {
                        ModRuntimeManager.PlayOneShot(countdown2DSound);
                    }
                }
            }

            previousSecondsRemaining = secondsLeft;

            UpdateTimers(secondsLeft);

            if (secondsLeft <= 0.0f)
            {
                break;
            }
        }

        onTimerFinished?.Invoke(this);
    }

    void UpdateTimers(ulong secondsLeft)
    {
        TimeSpan time = TimeSpan.FromSeconds(secondsLeft);

        if (timerTexts != null)
        {
            string timeLeftString = string.Format("{0}:{1:D2}", time.Minutes, time.Seconds);
            if (timerTexts != null)
            {
                foreach (TMPro.TextMeshPro timerText in timerTexts)
                {
                    if (timerText)
                    {
                        timerText.text = timeLeftString;
                    }
                }
            }
        }
    }

    ulong GetSecondsLeft(ulong endTimestep)
    {
        ulong duration = endTimestep - ModNetworkManager.Instance.GetTimestep();

        return duration / 1000;
    }

    #region RPC Callbacks

    private ulong previousTimestep;

    void ClientStartStop(ModNetworkReader reader, ModRPCInfo info)
    {
        ulong timestep = reader.ReadUInt64();

        if (previousTimestep >= timestep)
            return;

        previousTimestep = timestep;

        bool bStartTimer = reader.ReadBoolean();

        if(timerCoroutine != null)
        {
            StopCoroutine(timerCoroutine);
        }

        if(bStartTimer)
        {
            ulong endTimestep = reader.ReadUInt64();

            timerCoroutine = StartCoroutine(Timer(endTimestep));

            if(!string.IsNullOrEmpty(start2DSound))
            {
                ModRuntimeManager.PlayOneShot(start2DSound);
            }
        }
        else
        {
            ulong secondsRemaining = reader.ReadUInt64();

            UpdateTimers(secondsRemaining);

            if (!string.IsNullOrEmpty(stop2DSound))
            {
                ModRuntimeManager.PlayOneShot(stop2DSound);
            }
        }
    }

    #endregion

    #region Getters/Setters

    public void ServerStartTimer(float seconds)
    {
        if(modNetworkObject == null)
        {
            Debug.LogError("NetworkObject is null");
            return;
        }

        if(!modNetworkObject.IsServer())
        {
            Debug.LogError("Only the server can start the timer");
            return;
        }

        ulong startTimestep = ModNetworkManager.Instance.GetTimestep();
        ulong endTimestep = startTimestep + (ulong)(seconds * 1000);

        modNetworkObject.SendRPC(RPC_CLIENT_STARTSTOP, true, ModRPCRecievers.AllBuffered, startTimestep, true, endTimestep);
    }

    public void ServerStopTimer()
    {
        if (modNetworkObject == null)
        {
            Debug.LogError("NetworkObject is null");
            return;
        }

        if (!modNetworkObject.IsServer())
        {
            Debug.LogError("Only the server can stop the timer");
            return;
        }

        modNetworkObject.SendRPC(RPC_CLIENT_STARTSTOP, true, ModRPCRecievers.AllBuffered, ModNetworkManager.Instance.GetTimestep(),false, secondsLeft);
    }

    #endregion
}
