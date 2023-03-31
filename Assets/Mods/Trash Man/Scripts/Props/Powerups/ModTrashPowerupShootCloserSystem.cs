using ModWobblyLife;
using ModWobblyLife.Network;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModTrashPowerupShootCloserSystem : ModTrashPowerupBehaviour
{
    [SerializeField] private ModTrashSlidingDoor[] slidingDoors;
    [SerializeField] private ModTouchButton[] buttons;
    [SerializeField] private float closeForSeconds = 5.0f;
    [SerializeField] private float cooldownSeconds = 30.0f;

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if(buttons != null)
        {
            foreach(ModTouchButton button in buttons)
            {
                if(button)
                {
                    button.onButtonPressed.AddListener(OnButtonPressed);
                }
            }
        }
    }

    public override void ServerActivate()
    {
        OnButtonPressed();
    }

    void OnButtonPressed()
    {
        if (modNetworkObject == null) return;

        if(modNetworkObject.IsServer())
        {
            StartCoroutine(ServerUpdate());
        }
    }

    IEnumerator ServerUpdate()
    {
        foreach (ModTouchButton button in buttons)
        {
            if (button)
            {
                button.ServerSetButtonOn(false);
            }
        }

        foreach (ModTrashSlidingDoor door in slidingDoors)
        {
            if (door)
            {
                door.ServerSetDoorOpen(false);
            }
        }

        yield return new WaitForSeconds(closeForSeconds);

        foreach (ModTrashSlidingDoor door in slidingDoors)
        {
            if (door)
            {
                door.ServerSetDoorOpen(true);
            }
        }

        yield return new WaitForSeconds(cooldownSeconds);

        foreach (ModTouchButton button in buttons)
        {
            if (button)
            {
                button.ServerSetButtonOn(true);
            }
        }
    }

    public override float GetDuration()
    {
        return closeForSeconds;
    }
}
