using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;
using ModWobblyLife;
using System;

public class ModPingPlayerData
{
    public Vector3 lastKnownPosition;
    public float timeSinceLastPing;
}

public class ModHideAndSeekPingSystem : ModNetworkBehaviour
{
    private byte RPC_CLIENT_SEEKER_PING_PLAYER;

    public enum PingSystemType
    {
        Enemy,
        Ally,
        AllyCaught
    }

    [SerializeField] private ModWorldIcon enemyPingIconPrefab;
    [SerializeField] private ModWorldIcon allyPingIconPrefab;
    [SerializeField] private ModWorldIcon allyCaughtPingIconPrefab;
    [SerializeField] private float maxDistanceBeforePing = 3.0f;
    [SerializeField] private float timeBeforePing = 10.0f;
    [SerializeField] private float timeTillAnotherPing = 8.0f;

    private Coroutine pingSystemCoroutine;

    private Dictionary<ModPlayerCharacter, ModPingPlayerData> lastKnownData = new Dictionary<ModPlayerCharacter, ModPingPlayerData>();

    private float maxDistanceBeforePingSqrt;

    protected override void ModRegisterRPCs(ModNetworkObject modNetworkObject)
    {
        base.ModRegisterRPCs(modNetworkObject);

        RPC_CLIENT_SEEKER_PING_PLAYER = modNetworkObject.RegisterRPC(ClientSeekerPingPlayer);
    }

    void OnEnable()
    {
        if (ModInstance.Instance)
        {
            ModInstance.Instance.onAssignedPlayerCharacter += OnPlayerCharacterAssigned;
            ModInstance.Instance.onUnassignedPlayerCharacter += OnPlayerCharacterUnassigned;
        }
    }

    void OnDisable()
    {
        if (ModInstance.InstanceExists)
        {
            ModInstance.Instance.onAssignedPlayerCharacter -= OnPlayerCharacterAssigned;
            ModInstance.Instance.onUnassignedPlayerCharacter -= OnPlayerCharacterUnassigned;
        }
    }

    void OnPlayerCharacterAssigned(ModPlayerCharacter modPlayerCharacter)
    {

    }

    void OnPlayerCharacterUnassigned(ModPlayerCharacter modPlayerCharacter)
    {
        lastKnownData.Remove(modPlayerCharacter);
    }

    /// <summary>
    /// Server starts pinging system
    /// </summary>
    public void ServerStartPingSystem()
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return;

        lastKnownData.Clear();
        maxDistanceBeforePingSqrt = maxDistanceBeforePing * maxDistanceBeforePing;

        if (pingSystemCoroutine != null)
        {
            StopCoroutine(pingSystemCoroutine);
        }

        pingSystemCoroutine = StartCoroutine(ServerPingUpdate());
    }

    /// <summary>
    /// Server stops pinging system
    /// </summary>
    public void ServerStopPingSystem()
    {
        if (pingSystemCoroutine != null)
        {
            StopCoroutine(pingSystemCoroutine);
            pingSystemCoroutine = null;
        }

        lastKnownData.Clear();
    }

    private List<ModPlayerController> controllerCache = new List<ModPlayerController>();

    IEnumerator ServerPingUpdate()
    {
        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        float time = Time.time;

        while (true)
        {
            yield return fixedUpdate;

            ModInstance.Instance.GetModPlayerControllers(controllerCache);

            // Whether we should reset the last known positions to their current ones 
            bool bResetLastKnown = (Time.time - time) >= 1.0f;

            foreach (ModPlayerController controller in controllerCache)
            {
                ModHideAndSeekPlayerController hideAndSeekPlayerController = controller as ModHideAndSeekPlayerController;

                if (!hideAndSeekPlayerController || hideAndSeekPlayerController.IsSeeker()) continue;

                ModPingPlayerData lastKnownData;
                Transform playerTransform = controller.GetPlayerTransform();

                ModPlayerCharacter modPlayerCharacter = controller.GetPlayerCharacter();

                if (!modPlayerCharacter)
                    continue;

                if (!playerTransform)
                    continue;

                if (!this.lastKnownData.TryGetValue(modPlayerCharacter, out lastKnownData))
                {
                    lastKnownData = new ModPingPlayerData();

                    lastKnownData.lastKnownPosition = playerTransform.position;
                    this.lastKnownData.Add(modPlayerCharacter, lastKnownData);
                }

                Vector3 currentPosition = playerTransform.position;

                if (!bResetLastKnown)
                {
                    float distanceSqrt = (currentPosition - lastKnownData.lastKnownPosition).sqrMagnitude;

                    // Check whether the player has moved a certain distance 
                    if (distanceSqrt >= maxDistanceBeforePingSqrt)
                    {
                        lastKnownData.lastKnownPosition = currentPosition;

                        // If they have then check if we have pinged them recently
                        if (Time.time - lastKnownData.timeSinceLastPing >= timeTillAnotherPing)
                        {
                            // If we haven't then ping this player
                            lastKnownData.lastKnownPosition = currentPosition;
                            ServerPingPlayer(controller);
                        }
                    }
                }
                else
                {
                    lastKnownData.lastKnownPosition = currentPosition;
                }
            }

            if (bResetLastKnown)
            {
                time = Time.time;
            }
        }
    }

    /// <summary>
    /// Pings everyone
    /// </summary>
    public void ServerPingEveryone()
    {
        ModInstance.Instance.IterateModPlayerControllers(x =>
        {
            ModHideAndSeekPlayerController controller = x as ModHideAndSeekPlayerController;
            if (controller)
            {
                if (!controller.IsSeeker())
                {
                    ServerPingPlayer(controller);
                }
            }
        });
    }

    /// <summary>
    /// Pings a random hider
    /// </summary>
    /// <returns></returns>
    public bool ServerPingRandomHider()
    {
        if (modNetworkObject == null || !modNetworkObject.IsServer()) return false;

        ModInstance.Instance.GetModPlayerControllers(controllerCache);

        controllerCache.RemoveAll(x =>
        {
            ModHideAndSeekPlayerController hideAndSeekPlayerController = x as ModHideAndSeekPlayerController;
            if (hideAndSeekPlayerController)
            {
                if (hideAndSeekPlayerController.IsSeeker())
                {
                    return true;
                }

                if (!hideAndSeekPlayerController.GetPlayerCharacter())
                {
                    return true;
                }
            }

            return false;
        });

        if (controllerCache.Count > 0)
        {
            ModHideAndSeekPlayerController controller = controllerCache[UnityEngine.Random.Range(0, controllerCache.Count)] as ModHideAndSeekPlayerController;
            return ServerPingPlayer(controller);
        }

        return false;
    }

    bool ServerPingPlayer(ModPlayerController controller)
    {
        if (controller)
        {
            ModPingPlayerData playerData;

            Transform playerTransform = controller.GetPlayerTransform();

            ModPlayerCharacter modPlayerCharacter = controller.GetPlayerCharacter();

            if (!modPlayerCharacter)
                return false;

            if (!playerTransform)
                return false;

            if (!lastKnownData.TryGetValue(modPlayerCharacter, out playerData))
            {
                playerData = new ModPingPlayerData();
                playerData.lastKnownPosition = playerTransform.position;
                lastKnownData.Add(modPlayerCharacter, playerData);
            }

            playerData.timeSinceLastPing = Time.time;

            ModHideAndSeekPlayerCharacter playerCharacter = controller.GetPlayerCharacter() as ModHideAndSeekPlayerCharacter;
            if(playerCharacter)
            {
                playerCharacter.ServerPlayerDetected();
            }

            modNetworkObject.SendRPC(RPC_CLIENT_SEEKER_PING_PLAYER, ModRPCRecievers.All, controller.modNetworkObject.GetNetworkID(), playerData.lastKnownPosition);
            return true;
        }

        return false;
    }

    /// <summary>
    /// Pings local
    /// </summary>
    /// <param name="pingType">The ping type</param>
    /// <param name="position">The world position of the ping</param>
    /// <param name="showToControllers">Who sees this ping (Has to be local players only)</param>
    public void Ping(PingSystemType pingType,Vector3 position, params ModPlayerController[] showToControllers)
    {
        ModWorldIcon pingIconPrefab = null;

        switch(pingType)
        {
            case PingSystemType.Ally:
                {
                    pingIconPrefab = allyPingIconPrefab;
                }
                break;
            case PingSystemType.Enemy:
                {
                    pingIconPrefab = enemyPingIconPrefab;
                }
                break;
            case PingSystemType.AllyCaught:
				{
                    pingIconPrefab = allyCaughtPingIconPrefab;
                }
                break;
        }

        if (pingIconPrefab)
        {
            StartCoroutine(Ping_Enumerator(pingIconPrefab, position, showToControllers));
        }
    }

    IEnumerator Ping_Enumerator(ModWorldIcon pingIconPrefab,Vector3 position, params ModPlayerController[] showToControllers)
    {
        if (pingIconPrefab)
        {
            // Spawns the world icon
            GameObject pingGameObject = Instantiate(pingIconPrefab.gameObject, position, Quaternion.identity, transform);
            if (pingGameObject)
            {
                ModWorldIcon modWorldIcon = pingGameObject.GetComponent<ModWorldIcon>();
                if (modWorldIcon)
                {
                    // Shows this world icon to certain controllers (They must be local)
                    foreach (ModPlayerController controller in showToControllers)
                    {
                        modWorldIcon.Show(controller);
                    }

                    // As this icon is animating we want to loop this animation for X time
                    yield return new WaitForSeconds(2.5f);

                    // Then play the ping outro animation
                    Animator animator = modWorldIcon.GetComponent<Animator>();
                    if (animator)
                    {
                        animator.SetBool("bFinish", true);
                    }

                    // Assuming it is a short animation
                    yield return new WaitForSeconds(1.0f);

                    // Then destroy the icon
                    Destroy(modWorldIcon.gameObject);
                }
            }
        }
    }

    #region RPC Callbacks

    void ClientSeekerPingPlayer(ModNetworkReader reader, ModRPCInfo info)
    {
        // Gets the controller of the player we are pinging
        ModPlayerController controller = ModInstance.Instance.GetModPlayerControllerByNetworkid(reader.ReadUInt32());

        if (!controller)
            return;

        // Read the position of the ping
        Vector3 position = reader.ReadVector3();

        ModPlayerController[] controllers = ModInstance.Instance.GetModPlayerControllers();

        foreach (ModPlayerController playerController in controllers)
        {
            ModHideAndSeekPlayerController hideAndSeekPlayerController = playerController as ModHideAndSeekPlayerController;

            if (hideAndSeekPlayerController && hideAndSeekPlayerController.IsLocal())
            {
                // Only show ping if you are the seeker
                if (hideAndSeekPlayerController.IsSeeker())
                {
                    Ping(PingSystemType.Enemy, position, hideAndSeekPlayerController);
                }
            }
        }
    }

    #endregion
}
