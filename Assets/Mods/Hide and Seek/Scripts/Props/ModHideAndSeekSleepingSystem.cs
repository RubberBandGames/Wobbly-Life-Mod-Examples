using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;
using ModWobblyLife;
using System;

class ModHideAndSeekSleepinPlayerData
{
    public Vector3 previousPosition;
    public float timeSincePositionUpdated;
}

public class ModHideAndSeekSleepingSystem : ModNetworkBehaviour
{
    [SerializeField] private float secondsUntillSleeping = 5.0f;

    private Dictionary<ModPlayerCharacter, ModHideAndSeekSleepinPlayerData> playerDataDic = new Dictionary<ModPlayerCharacter, ModHideAndSeekSleepinPlayerData>();

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        // Only allow the server to update the sleeping system
        if (modNetworkObject.IsServer())
        {
            StartCoroutine(ServerUpdate());
        }
    }

    void OnEnable()
    {
        if (ModInstance.Instance)
        {
            ModInstance.Instance.onUnassignedPlayerCharacter += OnUnassignedPlayerCharacter;
        }
    }

    void OnDisable()
    {
        if (ModInstance.InstanceExists)
        {
            ModInstance.Instance.onUnassignedPlayerCharacter -= OnUnassignedPlayerCharacter;
        }
    }

    void OnUnassignedPlayerCharacter(ModPlayerCharacter modPlayerCharacter)
    {
        playerDataDic.Remove(modPlayerCharacter);
    }

    IEnumerator ServerUpdate()
    {
        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        List<ModPlayerCharacter> characters = new List<ModPlayerCharacter>();

        while (true)
        {
            yield return fixedUpdate;

            ModInstance.Instance.GetModPlayerCharacters(characters);

            foreach (ModPlayerCharacter character in characters)
            {
                Vector3 position = character.GetPlayerPosition();

                ModHideAndSeekSleepinPlayerData playerData;

                if (!playerDataDic.TryGetValue(character, out playerData))
                {
                    playerData = new ModHideAndSeekSleepinPlayerData();
                    playerDataDic.Add(character, playerData);
                    playerData.previousPosition = position;
                    playerData.timeSincePositionUpdated = Time.time;
                    continue;
                }

                // Check whether the player has moved
                bool bHasMoved = (position - playerData.previousPosition).magnitude > 0.5f;

                // If player has moved or time has passed
                if ((Time.time - playerData.timeSincePositionUpdated) >= secondsUntillSleeping || bHasMoved)
                {
                    playerData.timeSincePositionUpdated = Time.time;
                    playerData.previousPosition = position;

                    ModHideAndSeekPlayerCharacter hideAndSeekPlayerCharacter = character as ModHideAndSeekPlayerCharacter;
                    if(hideAndSeekPlayerCharacter)
                    {
                        // Only show sleeping if the player has moved
                        hideAndSeekPlayerCharacter.ServerSetIsSleeping(!bHasMoved);
                    }
                }
            }
        }
    }
}
