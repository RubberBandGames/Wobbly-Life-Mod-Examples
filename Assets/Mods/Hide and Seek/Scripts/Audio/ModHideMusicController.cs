using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;
using ModWobblyLife.Audio;
using System;
using ModWobblyLife;
using ModWobblyLife.UI;

public class ModHideMusicController : ModNetworkBehaviour
{
    private byte RPC_CLIENT_SET_MODE;

    public enum HideMusicMode : byte
    {
        Intro,
        Game,
        Complete,
    }

    [SerializeField] private string musicEvent = "event:/Music/Music_ArcadeModeMusic_HideSeek";

    private ModEventInstance instance;

    protected override void ModAwake()
    {
        base.ModAwake();

        StartCoroutine(WaitTillLoadingFinished());
    }

    /// <summary>
    /// Waits for the loading screen to finish before playing the music controller
    /// </summary>
    /// <returns></returns>
    IEnumerator WaitTillLoadingFinished()
    {
        yield return new WaitUntil(() => !ModUILoadingScreen.IsShowingLoading());

        Play();
    }

    protected override void ModOnDestroy()
    {
        base.ModOnDestroy();

        Stop();
    }

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SET_MODE = modNetworkObject.RegisterRPC(ClientSetMode);
    }

    /// <summary>
    /// Starts playing the music controller
    /// </summary>
    void Play()
    {
        if (string.IsNullOrEmpty(musicEvent)) return;
        if (instance.IsValid()) return;

        instance = ModRuntimeManager.CreateInstance(musicEvent);
        instance.Start();
    }

    /// <summary>
    /// Sets the music mode and replicate that over to all clients (Call from server only)
    /// </summary>
    /// <param name="musicMode"></param>
    public void ServerModeComplete(HideMusicMode musicMode)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SET_MODE, true, ModRPCRecievers.OthersBuffered, (byte)musicMode);

        SetMode_Internal(musicMode);
    }


    /// <summary>
    /// Sets the music mode locally
    /// </summary>
    /// <param name="musicMode"></param>
    void SetMode_Internal(HideMusicMode musicMode)
    {
        if (!instance.IsValid()) return;

        instance.SetParameterByName("Music_ArcadeMode",(float)musicMode);
    }

    /// <summary>
    /// Stops playing the music controller
    /// </summary>
    void Stop()
    {
        if (!instance.IsValid()) return;

        instance.Stop(MOD_STOP_MODE.ALLOWFADEOUT);
        instance.Release();
        instance.ClearHandle();
    }

    #region RPC Callbacks

    void ClientSetMode(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        HideMusicMode musicMode = (HideMusicMode)reader.ReadByte();

        SetMode_Internal(musicMode);
    }

    #endregion
}
