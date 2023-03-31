using ModWobblyLife;
using ModWobblyLife.Audio;
using ModWobblyLife.Network;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.ParticleSystem;

public class ModHideAndSeekPlayerCharacter : ModPlayerCharacter, IModGrabInteract
{
    private const float SeekerIconHeight = 4.0f;
    private const float SeekerIconUpdateIntervalSeconds = 5.0f;

    private byte RPC_CLIENT_PLAYER_DETECTED;
    private byte RPC_CLIENT_SET_IS_SLEEPING;
    private byte RPC_CLIENT_CAUGHT;

    private static Type[] AlwaysAllowedToGrabTypes = new Type[]
    {
        typeof(ModTouchButton)
    };

    [SerializeField] private string sleepingSound = "event:/Objects/Arcade/Objects_Arcade_HideAndSeek_Sleeping";
    [SerializeField] private ParticleSystem sleepingParticlePrefab;
    [SerializeField] private float seekerCatcherHelperRadius = 1.0f;
    [SerializeField] private string caughtSound;
    [SerializeField] private ModWorldIcon seekerIconPrefab;

    private ModEventInstance sleepingInstance;
    private ParticleSystem sleepingParticleInstance;

    private bool bIsSleeping;

    private ModWorldIcon seekerIcon;
    private float seekerIconLastUpdateTime;
    private Vector3 newSeekerPosition;

    private ModHideAndSeekGamemode gamemode;

    protected override void ModAwake()
	{
		base.ModAwake();

        gamemode = FindObjectOfType<ModHideAndSeekGamemode>();

        if (sleepingParticlePrefab)
		{
            GameObject psGO = Instantiate(sleepingParticlePrefab.gameObject, transform);
            if(psGO)
			{
                sleepingParticleInstance = psGO.GetComponent<ParticleSystem>();
            }
		}
	}


	protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_PLAYER_DETECTED = modNetworkObject.RegisterRPC(ClientPlayerDetected);
        RPC_CLIENT_SET_IS_SLEEPING = modNetworkObject.RegisterRPC(ClientSetIsSleeping);
        RPC_CLIENT_CAUGHT = modNetworkObject.RegisterRPC(ClientCaught);
    }

    protected override void ModNetworkPost(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkPost(modNetworkObject);

        if (modNetworkObject.IsServer())
        {
            StartCoroutine(SeekerCatchingHelper());
        }
    }

    protected override void ModOnDestroy()
    {
        base.ModOnDestroy();

        if (sleepingInstance.IsValid())
        {
            sleepingInstance.Stop(MOD_STOP_MODE.IMMEDIATE);
            sleepingInstance.Release();
        }

        if (seekerIcon)
        {
            Destroy(seekerIcon.gameObject);
        }
    }

    protected override void ModReady()
    {
        base.ModReady();

        SetPlayerCamUIAllowed(false);
        SetCharacterNameVisible(false);
        SetupGrabbingEvents();
    }

    void Update()
    {
        UpdateSeekerIcon();
    }

    /// <summary>
    /// Updates the seeker icon position
    /// </summary>
    void UpdateSeekerIcon()
    {
        if (seekerIcon)
        {
            if (Time.time - seekerIconLastUpdateTime >= SeekerIconUpdateIntervalSeconds)
            {
                seekerIconLastUpdateTime = Time.time;

                Vector3 position = GetPlayerPosition();
                newSeekerPosition = position + Vector3.up * SeekerIconHeight;
            }

            seekerIcon.transform.position = Vector3.Lerp(seekerIcon.transform.position, newSeekerPosition, Time.deltaTime * 10.0f);
        }
    }

    public void OnIsSeekerUpdated(bool bIsSeeker)
    {
        IEnumerator Delay()
        {
            // Short delay to make sure everything is intialized (Probably not ideal)
            yield return new WaitForSeconds(1.0f);

            if (bIsSeeker)
            {
                if (!seekerIcon)
                {
                    seekerIcon = Instantiate(seekerIconPrefab, transform);
                    if (seekerIcon)
                    {
                        ModHideAndSeekPlayerController playerController = GetPlayerController() as ModHideAndSeekPlayerController;

                        if (playerController && playerController.IsLocal())
                        {
                            // We don't want to see it ourself
                            seekerIcon.Hide(playerController);
                        }
                    }
                }
            }
            else
            {
                if (seekerIcon)
                {
                    Destroy(seekerIcon.gameObject);
                }
            }
        }

        StartCoroutine(Delay());
    }

    /// <summary>
    /// Sets up the grabbing events
    /// </summary>
    void SetupGrabbingEvents()
    {
        ModPlayerBody playerBody = GetPlayerBody();
        if (!playerBody)
        {
            Debug.LogError("No player body");
            return;
        }

        ModRagdollHandJoint leftHand = playerBody.GetLeftHandJoint();
        ModRagdollHandJoint rightHand = playerBody.GetRightHandJoint();

        if (!leftHand)
        {
            Debug.LogError("No left hand");
            return;
        }

        if (!rightHand)
        {
            Debug.LogError("No right hand");
            return;
        }

        leftHand.AddIsAllowedToGrab(IsAllowedToGrab);
        rightHand.AddIsAllowedToGrab(IsAllowedToGrab);
    }

    IEnumerator SeekerCatchingHelper()
    {
        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        while (true)
        {
            yield return fixedUpdate;

            ModHideAndSeekPlayerController controller = GetPlayerController() as ModHideAndSeekPlayerController;
            if (controller && controller.IsSeeker())
            {
                ModPlayerBody playerBody = GetPlayerBody();
                if (playerBody)
                {
                    SeekerCatchingHelper_Internal(playerBody.GetLeftHandJoint());
                    SeekerCatchingHelper_Internal(playerBody.GetRightHandJoint());
                }
            }
        }
    }

    void SeekerCatchingHelper_Internal(ModRagdollHandJoint handJoint)
    {
        if (!handJoint) return;

        if (handJoint.IsPointing())
        {
            int playerLayer = LayerMask.GetMask("Ragdoll");

            Collider[] colliders = Physics.OverlapSphere(handJoint.transform.position, seekerCatcherHelperRadius, playerLayer);
            foreach (Collider collider in colliders)
            {
                ModPlayerCharacter playerCharacter = collider.GetComponentInParent<ModPlayerCharacter>();
                if (playerCharacter)
                {
                    ModHideAndSeekPlayerController hideAndSeekPlayerController = playerCharacter.GetPlayerController() as ModHideAndSeekPlayerController;
                    if (hideAndSeekPlayerController && !hideAndSeekPlayerController.IsSeeker())
                    {
                        ModHideAndSeekPlayerCharacter hiderCharacter = hideAndSeekPlayerController.GetPlayerCharacter() as ModHideAndSeekPlayerCharacter;
                        if (hiderCharacter)
                        {
                            hiderCharacter.CaughtHider(hideAndSeekPlayerController, GetPlayerController() as ModHideAndSeekPlayerController);
                        }
                    }
                }
            }
        }
    }

    private bool bBeenCaught;

    void CaughtHider(ModHideAndSeekPlayerController hiderController, ModHideAndSeekPlayerController seekerController)
    {
        if (!gamemode || !gamemode.IsAllowedToBeCaught()) return;
        if (bBeenCaught) return;

        if (hiderController)
        {
            bBeenCaught = true;

            modNetworkObject.SendRPC(RPC_CLIENT_CAUGHT, ModRPCRecievers.All);
            hiderController.ServerHiderCaught(seekerController);
        }
    }

    public void OnPlayerArmGrab(ModPlayerCharacter character, ModRagdollHandJoint handJoint)
    {
        // Check to see if the player who grabbed you is a seeker
        ModHideAndSeekPlayerController seekerController = character.GetPlayerController() as ModHideAndSeekPlayerController;
        if (seekerController)
        {
            if (seekerController.IsSeeker())
            {
                ModHideAndSeekPlayerController hiderController = GetPlayerController() as ModHideAndSeekPlayerController;
                if (hiderController)
                {
                    // if they are then catch this player
                    CaughtHider(hiderController, seekerController);
                }
            }
        }
    }

    public void OnPlayerArmRelease(ModPlayerCharacter character, ModRagdollHandJoint handJoint)
    {

    }

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);
    }

    /// <summary>
    /// Called from server, notify players that this player has been detected 
    /// </summary>
    public void ServerPlayerDetected()
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_PLAYER_DETECTED, ModRPCRecievers.All);
    }

    /// <summary>
    /// Called from server, sets whether this player is sleeping and replicates this over to all clients
    /// </summary>
    /// <param name="bIsSleeping"></param>
    public void ServerSetIsSleeping(bool bIsSleeping)
    {
        if (this.bIsSleeping == bIsSleeping) return;
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        modNetworkObject.SendRPC(RPC_CLIENT_SET_IS_SLEEPING, true, ModRPCRecievers.OthersBuffered, ModNetworkManager.Instance.GetTimestep(), bIsSleeping);

        SetIsSleeping(bIsSleeping);
    }

    /// <summary>
    /// Sets whether this player is sleeping locally
    /// </summary>
    /// <param name="bIsSleeping"></param>
    void SetIsSleeping(bool bIsSleeping)
    {
        if (this.bIsSleeping == bIsSleeping) return;

        this.bIsSleeping = bIsSleeping;

        ModPlayerBody playerBody = GetPlayerBody();
        if (!playerBody)
        {
            return;
        }

        if (bIsSleeping)
        {
            if (!sleepingInstance.IsValid() && !string.IsNullOrEmpty(sleepingSound))
            {
                sleepingInstance = ModRuntimeManager.CreateInstance(sleepingSound);
                ModRuntimeManager.AttachInstanceToGameObject(sleepingInstance, playerBody.transform, (Rigidbody)null);
                sleepingInstance.Start();
            }

            if (sleepingParticleInstance)
            {
                // Finds the player head (Maybe a better way to do this)
                Transform head = RecursiveFindChild(playerBody.transform, "Head");

                if (head)
                {
                    // Plays sleeping particle on player head
                    sleepingParticleInstance.transform.parent = head;
                    sleepingParticleInstance.transform.localPosition = Vector3.zero;
                    sleepingParticleInstance.transform.localRotation = Quaternion.identity;

                    sleepingParticleInstance.Play();

                    EmissionModule emission = sleepingParticleInstance.emission;
                    emission.enabled = true;
                }
            }
        }
        else
        {
            if (sleepingInstance.IsValid())
            {
                sleepingInstance.Stop(MOD_STOP_MODE.ALLOWFADEOUT);
                sleepingInstance.Release();
                sleepingInstance.ClearHandle();
            }

            if (sleepingParticleInstance)
            {
                EmissionModule emission = sleepingParticleInstance.emission;
                emission.enabled = false;
            }
        }
    }

    // Redo: not great for performance
    private Transform RecursiveFindChild(Transform parent, string childName)
    {
        foreach (Transform child in parent)
        {
            if (child.name == childName)
            {
                return child;
            }
            else
            {
                return RecursiveFindChild(child, childName);
            }
        }

        return null;
    }

    #region RPC Callbacks

    void ClientCaught(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!string.IsNullOrEmpty(caughtSound))
        {
            ModRuntimeManager.PlayOneShot(caughtSound, GetPlayerPosition());
        }

        ModHideAndSeekPingSystem pingSystem = FindObjectOfType<ModHideAndSeekPingSystem>();
        if (pingSystem)
        {
            List<ModPlayerController> controllers = new List<ModPlayerController>();
            ModInstance.Instance.GetModPlayerControllers(controllers);

            controllers.RemoveAll(x =>
            {
                ModHideAndSeekPlayerController controller = x as ModHideAndSeekPlayerController;
                if (!controller)
                    return true;

                if (!controller.IsLocal())
                    return true;

                if (controller.IsSeeker())
                    return true;

                if (controller == GetPlayerController())
                    return true;

                return false;
            });

            pingSystem.Ping(ModHideAndSeekPingSystem.PingSystemType.AllyCaught, GetPlayerPosition(), controllers.ToArray());
        }
    }

    void ClientPlayerDetected(ModNetworkReader reader, ModRPCInfo info)
    {
        ModInstance.Instance.IterateModPlayerControllers(x =>
        {
            ModHideAndSeekPlayerController controller = x as ModHideAndSeekPlayerController;
            if (controller)
            {
                controller.OnAPlayerIsDetected(this);
            }
        });
    }

    private ulong sleepingTimestep;

    void ClientSetIsSleeping(ModNetworkReader reader, ModRPCInfo info)
    {
        if (!info.sender.IsHost) return;

        ulong timestep = reader.ReadUInt64();

        if (sleepingTimestep >= timestep)
            return;

        sleepingTimestep = timestep;

        bool bIsSleeping = reader.ReadBoolean();

        SetIsSleeping(bIsSleeping);
    }

    #endregion

    #region Getters/Setters

    bool IsAllowedToGrab(GameObject objectToGrab)
    {
        foreach (Type type in AlwaysAllowedToGrabTypes)
        {
            if (objectToGrab.GetComponent(type))
                return true;

            if (objectToGrab.GetComponentInParent(type))
                return true;
        }

        ModHideAndSeekPlayerController playerController = GetPlayerController() as ModHideAndSeekPlayerController;
        if (playerController)
        {
            return playerController.IsSeeker();
        }

        return false;
    }

    public bool IsGrabbable()
    {
        return true;
    }

    #endregion
}
