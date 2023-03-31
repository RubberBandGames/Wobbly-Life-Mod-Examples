using ModWobblyLife;
using ModWobblyLife.UI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModUIPlayerBasedHideAndSeekPlayerIcons : MonoBehaviour
{
    [SerializeField] private ModUIPlayerBasedHideAndSeekPlayerIcon playerIconPrefab;
    [SerializeField] private RectTransform playerIconContent;

    private Dictionary<ModPlayerController, ModUIPlayerBasedHideAndSeekPlayerIcon> playerIconsDic = new Dictionary<ModPlayerController, ModUIPlayerBasedHideAndSeekPlayerIcon>();

	void Awake()
	{
        ModInstance.Instance.IterateModPlayerControllers(OnAssignedPlayerController);
        ModInstance.Instance.onAssignedPlayerController += OnAssignedPlayerController;
        ModInstance.Instance.onUnassignedPlayerController += OnUnassignedPlayerController;
    }

	void OnDestroy()
	{
        ModInstance.Instance.onAssignedPlayerController -= OnAssignedPlayerController;
        ModInstance.Instance.onUnassignedPlayerController -= OnUnassignedPlayerController;
    }

	void OnAssignedPlayerController(ModPlayerController modPlayerController)
    {
        if (playerIconsDic.ContainsKey(modPlayerController)) return;

        if (playerIconPrefab)
        {
            ModUIPlayerBasedHideAndSeekPlayerIcon playerIcon = Instantiate(playerIconPrefab, playerIconContent, false);
            if (playerIcon)
            {
                playerIconsDic.Add(modPlayerController, playerIcon);

                ModHideAndSeekPlayerController hideAndSeekPlayerController = modPlayerController as ModHideAndSeekPlayerController;

                if (hideAndSeekPlayerController)
                {
                    playerIcon.Assign(hideAndSeekPlayerController);
                }
            }
        }
    }

    void OnUnassignedPlayerController(ModPlayerController modPlayerController)
    {
        if(playerIconsDic.TryGetValue(modPlayerController,out ModUIPlayerBasedHideAndSeekPlayerIcon icon))
		{
            Destroy(icon);
            playerIconsDic.Remove(modPlayerController);
		}
    }
}
