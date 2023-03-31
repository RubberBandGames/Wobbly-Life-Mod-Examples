using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using ModWobblyLife.Network;

public class ModHideAndSeekEarthMover : ModNetworkBehaviour
{
    [SerializeField] private Rigidbody rigidbody;
    [SerializeField] private Vector3 axisRotation = Vector3.right;
    [SerializeField] private float speed = 5.0f;

    protected override void ModNetworkStart(ModNetworkObject modNetworkObject)
    {
        base.ModNetworkStart(modNetworkObject);

        if(modNetworkObject.IsServer())
        {
            StartCoroutine(ServerUpdate());
        }
    }

    /// <summary>
    /// Updates the earth mover rotation
    /// We only want to do this on the servers side due to syncing physics. We will use ModTransformSync to sync it over to the clients
    /// </summary>
    /// <returns></returns>
    IEnumerator ServerUpdate()
    {
        if (!rigidbody) yield break;

        WaitForFixedUpdate fixedUpdate = new WaitForFixedUpdate();

        while(true)
        {
            yield return fixedUpdate;

            Quaternion rotation = rigidbody.rotation * Quaternion.Euler(axisRotation * speed);
            rigidbody.MoveRotation(rotation);
        }
    }
}
