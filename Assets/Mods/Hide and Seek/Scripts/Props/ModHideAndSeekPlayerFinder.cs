using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;
using System;

/// <summary>
/// A prop which can be assigned with a button, once pressed will ping the seeker with the hiders location
/// </summary>
public class ModHideAndSeekPlayerFinder : ModNetworkBehaviour
{
    [SerializeField] private ModTouchButton button;

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if(button)
        {
            button.onButtonPressed.AddListener(OnButtonPressed);
        }
    }

    void OnButtonPressed()
    {
        ModHideAndSeekPingSystem pingSystem = FindObjectOfType<ModHideAndSeekPingSystem>();
        if(pingSystem)
        {
            if(pingSystem.ServerPingRandomHider())
            {
                // Successful
            }
            else
            {
                // Unsuccessful
            }
        }
    }
}
