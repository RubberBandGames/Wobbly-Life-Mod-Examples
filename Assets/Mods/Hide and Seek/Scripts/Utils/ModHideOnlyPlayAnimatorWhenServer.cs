using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife.Network;

/// <summary>
/// This component is useful for when we want to animate a physics object and because the physics only happens on the server we need to ensure that the client doesn't use the animator
/// </summary>
public class ModHideOnlyPlayAnimatorWhenServer : ModNetworkBehaviour
{
    [SerializeField] private Animator animator;

    void Awake()
    {
        if(animator)
        {
            animator.enabled = false;
        }
    }

    protected override void ModNetworkPost(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkPost(modNetworkObject);

        if(modNetworkObject.IsServer() && animator)
        {
            animator.enabled = true;
        }
    }
}
