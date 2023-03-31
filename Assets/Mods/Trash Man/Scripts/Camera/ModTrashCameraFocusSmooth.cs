using ModWobblyLife;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModTrashCameraFocusSmooth : ModCameraFocus
{
    [SerializeField] private float smooth = 10.0f;

    private Vector3 previousCameraPosition;
    private Quaternion previousCameraRotation;

    protected override void OnFocusCamera(ModPlayerController playerController)
    {
        // Inital position to stop interpolating from 0,0,0
        ModGameplayCamera gameplayCamera = playerController.GetModGameplayCamera();
        if(gameplayCamera)
        {
            previousCameraPosition = gameplayCamera.transform.position;
            previousCameraRotation = gameplayCamera.transform.rotation;
        }
    }

    protected override void OnUnfocusCamera(ModPlayerController playerController)
    {

    }

    public override void UpdateCamera(ModGameplayCamera camera, Transform cameraTransform)
    {
        previousCameraPosition = Vector3.Lerp(previousCameraPosition, transform.position, Time.deltaTime * smooth);
        previousCameraRotation = Quaternion.Slerp(previousCameraRotation, transform.rotation, Time.deltaTime * smooth);

        camera.transform.position = previousCameraPosition;
        camera.transform.rotation = previousCameraRotation;
    }

    public override bool IsFOVChangeAllowed()
    {
        return false;
    }

    public override bool ShouldResetFOVOnFocus()
    {
        return true;
    }
}
