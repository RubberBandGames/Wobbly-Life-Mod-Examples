using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using System;
using Random = UnityEngine.Random;
using ModWobblyLife.Network;

public enum TrashWinner : byte
{
    TrashMan,
    Garbage
}

[Serializable]
public class TrashManCamera
{
    [SerializeField] private Animator animator;
    [SerializeField] private ModCameraFocus cameraFocus;

    public void Play()
    {
        if (animator)
        {
            animator.enabled = true;
            animator.Play("Play");
            animator.Update(0.0f);
        }
    }

    public void Assign(ModPlayerController playerController)
    {
        if (cameraFocus)
        {
            playerController.SetOwnerCameraFocus(cameraFocus, false);
        }
    }

    public void Stop()
    {
        if (animator)
        {
            animator.enabled = false;
        }
    }

    public bool HasFinished()
    {
        if (!animator) return false;

        return animator.GetCurrentAnimatorStateInfo(0).normalizedTime >= 1.0f;
    }

    public bool IsReady()
    {
        if (!cameraFocus) return false;

        return cameraFocus.modNetworkObject != null;
    }
}

public class ModTrashManGamemode : ModGamemode
{
    private const float ReturnToLobbySeconds = 8.0f;

    enum TrashManGamemodeState
    {
        None,
        Intro,
        Game,
        Outro
    }

    [Header("Spawnpoints")]
    [SerializeField] private ModPlayerCharacterSpawnPoint[] trashManPlayerSpawnPoints;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] respawnedTrashManPlayerSpawnPoints;
    [SerializeField] private ModPlayerCharacterSpawnPoint[] trashPlayerSpawnPoints;

    [Header("Camera")]
    [SerializeField] private TrashManCamera introCamera_NonTrashMan;
    [SerializeField] private TrashManCamera introCamera_TrashMan;
    [SerializeField] private ModCameraFocus respawnCamera;

    [Header("Props")]
    [SerializeField] private ModConveyorBeltPlatform[] conveyorBeltPlatforms;
    [SerializeField] private ModTrashGameTimer gameTimer;
    [SerializeField] private ModNetworkBehaviour winnerStagePrefab;
    [SerializeField] private Transform winnerStageSpawnPoint;

    [Header("Clothes")]
    [SerializeField] private ModClothingPiece[] trashManClothesPrefabs;

    [Header("Settings")]
    [SerializeField] private float gameTimerInSeconds = 60.0f * 2.0f;
    [Tooltip("The amount of seconds once the intro is running till the instructions appear")]
    [SerializeField] private float instructionsStartShowSeconds = 7.0f;

    private ModPlayerController mainTrashManController;
    private HashSet<ModPlayerController> trashMans = new HashSet<ModPlayerController>();

    private TrashManGamemodeState gamemodeState;
    private bool bWinnerSet;
    private Coroutine gamemodeCoroutine;

    protected override void ModStart()
    {
        base.ModStart();

        if (ModNetworkManager.Instance.IsServer())
        {
            StartCoroutine(Wait());

            SetConveyorBeltsOn(false);

            if (gameTimer)
            {
                gameTimer.onTimerFinished += OnTimerFinished;
            }
        }
    }

    void SetConveyorBeltsOn(bool bOn)
    {
        if (conveyorBeltPlatforms != null)
        {
            foreach (ModConveyorBeltPlatform beltPlatform in conveyorBeltPlatforms)
            {
                if (beltPlatform)
                {
                    beltPlatform.SetIsOn(bOn);
                }
            }
        }
    }

    void OnTimerFinished(ModTrashGameTimer gameTimer)
    {
        ServerSetWinner(TrashWinner.Garbage);
    }

    void ServerSetWinner(TrashWinner winner)
    {
        if (bWinnerSet)
            return;

        bWinnerSet = true;

        SetGamemodeState(TrashManGamemodeState.Outro);

        if (winnerStagePrefab)
        {
            ModNetworkManager.Instance.InstantiateNetworkPrefab(winnerStagePrefab.gameObject, x =>
            {
                ModTrashWinnerStage winnerStage = x as ModTrashWinnerStage;
                if (winnerStage)
                {
                    if (winner == TrashWinner.Garbage)
                    {
                        List<ModPlayerController> controllers = new List<ModPlayerController>();
                        ModInstance.Instance.GetModPlayerControllers(controllers);

                        controllers.RemoveAll(x => trashMans.Contains(x));

                        winnerStage.ServerShowWinners(this, "Garbage Wins", controllers.ToArray());
                    }
                    else
                    {
                        winnerStage.ServerShowWinners(this, "Trash Man Wins", mainTrashManController);
                    }
                }
            }, winnerStageSpawnPoint.position, winnerStageSpawnPoint.rotation, null, true);
        }

        StartCoroutine(ReturnToLobbyAfterSeconds(ReturnToLobbySeconds));
    }

    IEnumerator ReturnToLobbyAfterSeconds(float seconds)
    {
        yield return new WaitForSeconds(seconds);

        ModInstance.Instance.ServerPlayAgainOrReturnToLobby();
    }

    IEnumerator Wait()
    {
        yield return new WaitUntil(() => introCamera_TrashMan.IsReady());
        yield return new WaitUntil(() => introCamera_NonTrashMan.IsReady());

        SetGamemodeState(TrashManGamemodeState.Intro);
    }

    protected override void OnSpawnedPlayerController(ModPlayerController playerController)
    {
        base.OnSpawnedPlayerController(playerController);

        playerController.onServerPersistentDataLoaded += OnServerPerisistentDataLoaded;

        SetGamemodeState(gamemodeState, playerController, true);
    }

    protected override void OnSpawnedPlayerCharacter(ModPlayerController playerController, ModPlayerCharacter playerCharacter)
    {
        base.OnSpawnedPlayerCharacter(playerController, playerCharacter);

        LoadPlayerControllerClothes(playerController);
    }

    protected override void OnDestroyedPlayerController(ModPlayerController playerController)
    {
        base.OnDestroyedPlayerController(playerController);

        trashMans.Remove(playerController);
    }

    protected override void OnServerPlayerDied(ModPlayerController playerController, ModPlayerCharacter playerCharacter)
    {
        base.OnServerPlayerDied(playerController, playerCharacter);

        if (gamemodeState == TrashManGamemodeState.Outro)
            return;

        trashMans.Add(playerController);

        playerController.SetAllowedToRespawn(true);
        DestroyPlayerCharacter(playerController);

        playerController.SetOwnerCameraFocus(respawnCamera);
        RespawnPlayerCharacter(playerController, GetPlayerSpawnPoint(playerController), false);
        playerController.SetAllowedToRespawn(false);

        ModPlayerControllerInputManager inputManager = playerController.GetModPlayerControllerInputManager();
        if (inputManager)
        {
            inputManager.DisablePlayerTransformInput(this);
        }

        StartCoroutine(PlayerRespawnedCutscene(playerController));
    }

    IEnumerator PlayerRespawnedCutscene(ModPlayerController playerController)
    {
        yield return new WaitForSeconds(2.0f);

        if (gamemodeState == TrashManGamemodeState.Game)
        {
            if (playerController)
            {
                playerController.SetOwnerCameraFocusPlayer();
            }
        }

        ModPlayerControllerInputManager inputManager = playerController.GetModPlayerControllerInputManager();
        if (inputManager)
        {
            inputManager.EnablePlayerTransformInput(this);
        }
    }

    void OnServerPerisistentDataLoaded(ModPlayerController modPlayerController)
    {
        LoadPlayerControllerClothes(modPlayerController);
    }

    void LoadPlayerControllerClothes(ModPlayerController playerController)
    {
        if ((trashMans.Contains(playerController) && gamemodeState == TrashManGamemodeState.Game) || mainTrashManController == playerController)
        {
            ModPlayerCharacter modPlayerCharacter = playerController.GetPlayerCharacter();
            if (modPlayerCharacter)
            {
                ModCharacterCustomize characterCustomize = modPlayerCharacter.GetCharacterCustomize();
                if (characterCustomize)
                {
                    foreach (ModClothingPiece clothingPiece in trashManClothesPrefabs)
                    {
                        if (clothingPiece)
                        {
                            characterCustomize.SetClothingPiece(clothingPiece);
                        }
                    }
                }

                playerController.ServerLoadSavedClothesOnActivePlayer(ModClothingSelectionType.Hat, true);
            }
        }
        else
        {
            playerController.ServerLoadSavedClothesOnActivePlayer(true);
        }
    }

    IEnumerator Intro()
    {
        ModPlayerController[] playerControllers = ModInstance.Instance.GetModPlayerControllers();

        // Picks trash man 
        if (playerControllers.Length > 0)
        {
            ModPlayerController trashController = playerControllers[Random.Range(0, playerControllers.Length)];
            if (trashController)
            {
                mainTrashManController = trashController;

                trashMans.Add(trashController);
            }
        }

        // Delay for a second so all the clothes have loaded
        yield return new WaitForSeconds(1.0f);

        // Spawns all player characters in but don't focus on their cameras as we are in the intro
        ModInstance.Instance.IterateModPlayerControllers(controller =>
        {
            // Disables player input so they cannot move around
            ModPlayerControllerInputManager inputManager = controller.GetModPlayerControllerInputManager();
            if (inputManager)
            {
                inputManager.DisablePlayerTransformInput(this);
            }

            SpawnPlayerCharacter(controller, null, false);
        });

        yield return new WaitForSeconds(instructionsStartShowSeconds - 1.0f);

        // Show instructions
        ModInstance.Instance.IterateModPlayerControllers(controller =>
        {
            ModTrashManPlayerController trashManPlayerController = controller as ModTrashManPlayerController;
            if (trashManPlayerController)
            {
                trashManPlayerController.ServerShowInstructions(trashMans.Contains(controller));
            }
        });

        yield return new WaitUntil(() => introCamera_TrashMan.HasFinished());
        yield return new WaitUntil(() => introCamera_NonTrashMan.HasFinished());

        // Hide instructions
        ModInstance.Instance.IterateModPlayerControllers(controller =>
        {
            ModTrashManPlayerController trashManPlayerController = controller as ModTrashManPlayerController;
            if (trashManPlayerController)
            {
                trashManPlayerController.ServerHideInstructions();
            }
        });

        // Enable the player input so they can move
        ModInstance.Instance.IterateModPlayerControllers(controller =>
        {
            ModPlayerControllerInputManager inputManager = controller.GetModPlayerControllerInputManager();
            if (inputManager)
            {
                inputManager.EnablePlayerTransformInput(this);
            }
        });

        SetGamemodeState(TrashManGamemodeState.Game);
    }

    IEnumerator Game()
    {
        StartCoroutine(GameExternal());

        while (true)
        {
            yield return null;

            bool bAtleastOneGarbageAlive = false;

            ModInstance.Instance.IterateModPlayerControllers(controller =>
            {
                if (!trashMans.Contains(controller))
                {
                    bAtleastOneGarbageAlive = true;
                }
            });

            if (!bAtleastOneGarbageAlive)
            {
                ServerSetWinner(TrashWinner.TrashMan);
                yield break;
            }
            else if(!mainTrashManController)
            {
                ServerSetWinner(TrashWinner.Garbage);
                yield break;
            }
        }

    }

    IEnumerator GameExternal()
    {
        if (gameTimer)
        {
            gameTimer.ServerStartTimer(gameTimerInSeconds);
        }

        yield return new WaitForSeconds(3.0f);

        SetConveyorBeltsOn(true);
    }

    IEnumerator Outro()
    {
        if (gameTimer)
        {
            gameTimer.ServerStopTimer();
        }

        yield return null;
    }


    void SetGamemodeState(TrashManGamemodeState gamemodeState)
    {
        this.gamemodeState = gamemodeState;

        if(gamemodeCoroutine != null)
        {
            StopCoroutine(gamemodeCoroutine);
        }

        switch (gamemodeState)
        {
            case TrashManGamemodeState.Intro:
                {
                    introCamera_NonTrashMan.Play();
                    introCamera_TrashMan.Play();

                    gamemodeCoroutine = StartCoroutine(Intro());
                }
                break;
            case TrashManGamemodeState.Game:
                {
					ModTrashManMusicController musicController = FindObjectOfType<ModTrashManMusicController>();
                    if (musicController)
                    {
                        musicController.ServerModeComplete(ModTrashManMusicController.TrashMusicMode.Game);
                    }
					
                    gamemodeCoroutine = StartCoroutine(Game());
                }
                break;
            case TrashManGamemodeState.Outro:
                {
                    ModTrashManMusicController musicController = FindObjectOfType<ModTrashManMusicController>();
                    if(musicController)
                    {
                        musicController.ServerModeComplete(ModTrashManMusicController.TrashMusicMode.Complete);
                    }

                    gamemodeCoroutine = StartCoroutine(Outro());
                }
                break;
        }

        ModInstance.Instance.IterateModPlayerControllers(x =>
        {
            SetGamemodeState(gamemodeState, x, false);
        });
    }

    void SetGamemodeState(TrashManGamemodeState gamemodeState, ModPlayerController playerController, bool bAlreadyStarted)
    {
        switch (gamemodeState)
        {
            case TrashManGamemodeState.Intro:
                {
                    if (trashMans.Contains(playerController))
                    {
                        introCamera_TrashMan.Assign(playerController);
                    }
                    else
                    {
                        introCamera_NonTrashMan.Assign(playerController);
                    }
                }
                break;
            case TrashManGamemodeState.Game:
                {
                    playerController.SetOwnerCameraFocusPlayer();
                }
                break;
            case TrashManGamemodeState.Outro:
                {

                }
                break;
        }
    }

    private int trashManSpawnIndex;
    private int trashSpawnIndex;
    private int respawnSpawnIndex;

    public override ModPlayerCharacterSpawnPoint GetPlayerSpawnPoint(ModPlayerController playerController)
    {
        ModPlayerCharacterSpawnPoint spawnPoint = base.GetPlayerSpawnPoint(playerController);
        if (!spawnPoint)
        {
            if (mainTrashManController == playerController)
            {
                if (trashManPlayerSpawnPoints != null && trashManPlayerSpawnPoints.Length > 0)
                {
                    spawnPoint = trashManPlayerSpawnPoints[trashManSpawnIndex % trashManPlayerSpawnPoints.Length];
                    trashManSpawnIndex++;
                }
            }
            else if (trashMans.Contains(playerController))
            {
                if (respawnedTrashManPlayerSpawnPoints != null && respawnedTrashManPlayerSpawnPoints.Length > 0)
                {
                    spawnPoint = respawnedTrashManPlayerSpawnPoints[respawnSpawnIndex % respawnedTrashManPlayerSpawnPoints.Length];
                    respawnSpawnIndex++;
                }
            }
            else
            {
                if (trashPlayerSpawnPoints != null && trashPlayerSpawnPoints.Length > 0)
                {
                    spawnPoint = trashPlayerSpawnPoints[trashSpawnIndex % trashPlayerSpawnPoints.Length];
                    trashSpawnIndex++;
                }
            }
        }

        return spawnPoint;
    }

    public override bool IsRespawningAllowed()
    {
        return true;
    }
}
