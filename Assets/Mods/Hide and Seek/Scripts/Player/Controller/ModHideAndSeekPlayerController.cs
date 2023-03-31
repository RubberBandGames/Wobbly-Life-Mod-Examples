using ModWobblyLife;
using ModWobblyLife.Audio;
using ModWobblyLife.Network;
using ModWobblyLife.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModHideAndSeekPlayerController : ModPlayerController
{
    private byte RPC_CLIENT_SHOW_GAMEPLAY_UI;
    private byte RPC_CLIENT_SET_IS_SEEKER;
    private byte RPC_CLIENT_SET_USE_TIMER;
    private byte RPC_CLIENT_SHOW_INSTRUCTIONS;
    private byte RPC_CLIENT_SET_CAUGHT;

    public event Action<ModPlayerController,bool> onCaughtChanged;
    public event Action<ModPlayerController, bool> onSeekerChanged;

    [SerializeField] private ModUIElement gameplayUIPrefab;
    [SerializeField] private ModHideBaseParticle localDetectedParticlePrefab;
    [SerializeField] private string localDetectedSound = "event:/HideAndSeekDemo/HideAndSeekDemo_2D_GettingPinged";
    [SerializeField] private ModUIPlayerBasedHideAndSeekInstructions instructionPrefab;

    private ModUIPlayerBasedHideAndSeekGameplayCanvas hideAndSeekGameplayCanvas;

    private bool bIsSeeker;
    private bool bCaught;
    private Coroutine findTimerCoroutine;

    private ModUIElement instructionInstance;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SHOW_GAMEPLAY_UI = modNetworkObject.RegisterRPC(ClientShowGameplayUI);
        RPC_CLIENT_SET_IS_SEEKER = modNetworkObject.RegisterRPC(ClientSetIsSeeker);
        RPC_CLIENT_SET_USE_TIMER = modNetworkObject.RegisterRPC(ClientSetUseTimer);
        RPC_CLIENT_SHOW_INSTRUCTIONS = modNetworkObject.RegisterRPC(ClientShowInstructions);
        RPC_CLIENT_SET_CAUGHT = modNetworkObject.RegisterRPC(ClientSetCaught);
    }

	protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);
    }

    protected override void ModReady()
    {
        base.ModReady();

        ModPlayerControllerInteractor interactor = GetControllerInteractor();
        if (interactor)
        {
            interactor.SetActionInteractEnabled(this, false);
        }

        if (modNetworkObject.IsServer())
        {
            ServerSetAllowedCustomClothingAbilities(false);
        }
    }

    protected override void ModOnDestroy()
    {
        base.ModOnDestroy();

        ModHideAndSeekGamemode hideAndSeekGamemode = FindObjectOfType<ModHideAndSeekGamemode>();
        if (hideAndSeekGamemode)
        {
            hideAndSeekGamemode.UnassignSpectator(this);
        }
    }

    protected override void OnPlayerBasedUIAssigned()
    {
        base.OnPlayerBasedUIAssigned();

        if (modNetworkObject.IsOwner())
        {
            ModPlayerControllerUI ui = GetModPlayerControllerUI();
            if (ui)
            {
                hideAndSeekGameplayCanvas = ui.CreateUIOnGameplayCanvas(gameplayUIPrefab, false) as ModUIPlayerBasedHideAndSeekGameplayCanvas;

                if (hideAndSeekGameplayCanvas)
                {
                    hideAndSeekGameplayCanvas.SetIsSeeker(bIsSeeker);
                }
            }
        }
    }

    /// <summary>
    /// Called when a player has been detected
    /// </summary>
    /// <param name="detectedCharacter"></param>
    public void OnAPlayerIsDetected(ModPlayerCharacter detectedCharacter)
    {
        if (!IsLocal()) return;

        ModHideAndSeekPlayerController detectedController = detectedCharacter.GetPlayerController() as ModHideAndSeekPlayerController;

        if (!detectedController)
        {
            Debug.LogError("Detected controller is null");
            return;
        }

        Transform detectedPlayerTransform = detectedController.GetPlayerTransform();

        if (!detectedPlayerTransform)
        {
            Debug.LogError("PlayerTransform doesn't exist");
            return;
        }

        // Check to see if it was our character that was pinged
        if (detectedCharacter == GetPlayerCharacter())
        {
            if (localDetectedParticlePrefab)
            {
                PlayPing(localDetectedParticlePrefab, detectedPlayerTransform.position, detectedPlayerTransform.rotation, localDetectedSound);
            }
        }
        else if (!detectedController.IsSeeker() && !IsSeeker() && detectedController != this)
        {
            // We can assume this is our ally

            ModHideAndSeekPingSystem pingSystem = FindObjectOfType<ModHideAndSeekPingSystem>();
            if (pingSystem)
            {
                pingSystem.Ping(ModHideAndSeekPingSystem.PingSystemType.Ally, detectedPlayerTransform.position, this);
            }
        }
    }

    void PlayPing(ModHideBaseParticle particlePrefab, Vector3 position, Quaternion rotation, string sound)
    {
        ModGameplayCamera gameplayCamera = GetModGameplayCamera();

        if (!gameplayCamera)
        {
            Debug.LogError("GameplayCamera is null");
            return;
        }

        ModHideBaseParticle particle = ModHideParticleManager.Instance.Pop(particlePrefab);
        particle.transform.SetPositionAndRotation(position, rotation);

        // Makes it so not all split screen players see it. Only the one which needs to see it
        ParticleSystem[] particleSystems = particle.GetComponentsInChildren<ParticleSystem>();
        foreach (ParticleSystem particleSystem in particleSystems)
        {
            // Gameplay Camera's layer is unique to each split screen player and will only render that layer plus default layers i.e Default/World/Building etc
            particleSystem.gameObject.layer = gameplayCamera.gameObject.layer;
        }

        particle.Play();

        ModHideParticleManager.Instance.Push(localDetectedParticlePrefab, particle);

        if (!string.IsNullOrEmpty(sound))
        {
            ModRuntimeManager.PlayOneShot(sound);
        }
    }
    /// <summary>
    /// Called from server, sets the instructions visible on the owner
    /// </summary>
    /// <param name="bVisible"></param>
    public void ServerSetInstructionsVisible(bool bVisible)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SHOW_INSTRUCTIONS, ModRPCRecievers.Owner, bVisible);
    }

    /// <summary>
    /// Called from server, sets what timer we are using and replicates this to all clients
    /// </summary>
    /// <param name="timer"></param>
    public void ServerSetTimer(ModHideAndSeekGameTimer timer)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        if (timer)
        {
            modNetworkObject.SendRPC(RPC_CLIENT_SET_USE_TIMER, true, ModRPCRecievers.AllBuffered, true, timer.modNetworkObject.GetNetworkID());
        }
        else
        {
            modNetworkObject.SendRPC(RPC_CLIENT_SET_USE_TIMER, true, ModRPCRecievers.AllBuffered, false);
        }
    }

    /// <summary>
    /// Called from server, sets whether is player is the seeker and replicate it to all clients
    /// </summary>
    /// <param name="bIsSeeker"></param>
    public void ServerSetIsSeeker(bool bIsSeeker)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SET_IS_SEEKER, true, ModRPCRecievers.AllBuffered, bIsSeeker);
    }

    /// <summary>
    /// Called from server sets whether the gameplay ui should be visible on this player
    /// </summary>
    /// <param name="bVisible"></param>
    public void ServerSetGameplayUIVisible(bool bVisible)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SHOW_GAMEPLAY_UI, ModRPCRecievers.Owner, ModNetworkManager.Instance.GetTimestep(), bVisible);
    }

    public void ServerHiderCaught(ModHideAndSeekPlayerController seekerController)
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        ModHideAndSeekGamemode hideAndSeekGamemode = FindObjectOfType<ModHideAndSeekGamemode>();
        if (hideAndSeekGamemode)
        {
            hideAndSeekGamemode.AssignSpectator(this);
            hideAndSeekGamemode.DestroyPlayerCharacter(this, false, true);
        }

        modNetworkObject.SendRPC(RPC_CLIENT_SET_CAUGHT, true, ModRPCRecievers.AllBuffered, true);
    }

    protected override void OnPlayerCharacterSpawned(ModPlayerCharacter playerCharacter)
    {
        base.OnPlayerCharacterSpawned(playerCharacter);

        ModHideAndSeekPlayerCharacter hiderCharacter = playerCharacter as ModHideAndSeekPlayerCharacter;
        if (hiderCharacter)
        {
            hiderCharacter.OnIsSeekerUpdated(IsSeeker());
        }

        if (IsSeeker())
        {
            if (playerCharacter)
            {
                ModPlayerCharacterMovement movement = playerCharacter.GetComponent<ModPlayerCharacterMovement>();
                if (movement)
                {
                    movement.SetSpeedMultiplier(1.2f);
                    movement.SetJumpMultiplier(1.2f);
                }
            }
        }
    }

    #region RPC Callbacks

    void ClientSetCaught(ModNetworkReader reader, ModRPCInfo info)
    {
        bool bCaught = reader.ReadBoolean();

        if(this.bCaught != bCaught)
		{
            this.bCaught = bCaught;
            onCaughtChanged.Invoke(this,bCaught);
        }
    }

    void ClientSetUseTimer(ModNetworkReader reader, ModRPCInfo info)
    {
        bool bUseTimer = reader.ReadBoolean();

        if (findTimerCoroutine != null)
        {
            StopCoroutine(findTimerCoroutine);
        }

        if (bUseTimer)
        {
            uint timerNetworkid = reader.ReadUInt32();

            findTimerCoroutine = StartCoroutine(ModNetworkCoroutine.WaitUntillNetworkObjectAvaliable<ModHideAndSeekGameTimer>(timerNetworkid, x =>
            {
                if (x)
                {
                    if (hideAndSeekGameplayCanvas)
                    {
                        hideAndSeekGameplayCanvas.SetTimer(x);
                    }
                }
            }));
        }
        else
        {
            if (hideAndSeekGameplayCanvas)
            {
                hideAndSeekGameplayCanvas.SetTimer(null);
            }
        }
    }

    void ClientSetIsSeeker(ModNetworkReader reader, ModRPCInfo info)
    {
        bIsSeeker = reader.ReadBoolean();

        if (hideAndSeekGameplayCanvas)
        {
            hideAndSeekGameplayCanvas.SetIsSeeker(bIsSeeker);
        }

        ModHideAndSeekPlayerCharacter playerCharacter = GetPlayerCharacter() as ModHideAndSeekPlayerCharacter;
        if(playerCharacter)
        {
            playerCharacter.OnIsSeekerUpdated(bIsSeeker);
        }

        onSeekerChanged?.Invoke(this,bIsSeeker);
    }

    private ulong lastShowGameplayUIStamp;

    void ClientShowGameplayUI(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        ulong timestep = reader.ReadUInt64();

        if (lastShowGameplayUIStamp >= timestep)
            return;

        lastShowGameplayUIStamp = timestep;

        bool bShow = reader.ReadBoolean();

        if (bShow)
        {
            if (hideAndSeekGameplayCanvas)
            {
                hideAndSeekGameplayCanvas.Show();
            }
        }
        else
        {
            if (hideAndSeekGameplayCanvas)
            {
                hideAndSeekGameplayCanvas.Hide();
            }
        }
    }

    void ClientShowInstructions(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;
        if (!IsLocal()) return;

        bool bShowInstructions = reader.ReadBoolean();

        if (bShowInstructions)
        {
            if (!instructionInstance)
            {
                ModPlayerControllerUI controllerUI = GetModPlayerControllerUI();
                if (controllerUI)
                {
                    instructionInstance = controllerUI.CreateUIOnGameplayCanvas(instructionPrefab);
                }
            }

            ModUIPlayerBasedHideAndSeekInstructions hideAndSeekInstructions = instructionInstance as ModUIPlayerBasedHideAndSeekInstructions;

            if (hideAndSeekInstructions)
            {
                if(IsSeeker())
                {
                    hideAndSeekInstructions.ShowSeekerInstructions();
                }
                else
                {
                    hideAndSeekInstructions.ShowHidersInstructions();
                }
            }
        }
        else
        {
            if (instructionInstance)
            {
                Destroy(instructionInstance.gameObject);
                instructionInstance = null;
            }
        }
    }

    #endregion

    #region Getters/Setters

    public bool IsCaught()
	{
        return bCaught;
	}

    public bool IsSeeker()
    {
        return bIsSeeker;
    }

    #endregion
}
