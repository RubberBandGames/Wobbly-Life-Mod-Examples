using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ModWobblyLife;
using System;
using ModWobblyLife.Network;

[Serializable]
public class ModHideAndSeekCamera
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

public class ModHideAndSeekGamemode : ModGamemode
{
	private const float ReturnToLobbySeconds = 8.0f;

	enum HideAndSeekGamemodeState
	{
		None,
		Intro,
		Countdown,
		Game,
		Outro
	}

	enum HideAndSeekWinner
	{
		Seeker,
		Hiders
	}

	[Header("Camera")]
	[SerializeField] private ModHideAndSeekCamera introCamera_Seeker;
	[SerializeField] private ModHideAndSeekCamera introCamera_Hider;

	[Header("Spawn Points")]
	[SerializeField] private ModPlayerCharacterSpawnPoint[] seekersSpawnPoints;
	[SerializeField] private ModPlayerCharacterSpawnPoint[] hidersSpawnPoints;

	[Header("Timer")]
	[SerializeField] private ModHideAndSeekGameTimer timeToHideTimer;
	[SerializeField] private ModHideAndSeekGameTimer gameTimer;

	[Header("Settings")]
	[SerializeField] private float timeToHideSeconds = 30.0f;
	[SerializeField] private float timeToSeekSeconds = 120.0f;
	[SerializeField] private ModHideAndSeekPingSystem pingSystem;
	[Tooltip("Seeker doors must use interface IHideAndSeekSeekerDoor")]
	[SerializeField] private GameObject[] seekersDoors;
	[SerializeField] private Transform winnerStageSpawnPoint;
	[SerializeField] private ModHideAndSeekWinningStage winnerStagePrefab;
	[SerializeField] private float timeTillInstructionsAppear = 5.0f;

	private HashSet<ModPlayerController> hiderControllers = new HashSet<ModPlayerController>();
	private ModPlayerController seekerController;

	private HideAndSeekGamemodeState gamemodeState;
	private Coroutine gamemodeCoroutine;

	private HashSet<ModHideAndSeekPlayerController> spectators = new HashSet<ModHideAndSeekPlayerController>();

	void Start()
	{
		if (ModNetworkManager.Instance.IsServer())
		{
			StartCoroutine(Prepare());
		}
	}

	IEnumerator Prepare()
	{
		// Waits for the intro camera to be initalized on the network engine so that we can inform other players about this camera
		yield return new WaitUntil(() => introCamera_Seeker.IsReady());
		yield return new WaitUntil(() => introCamera_Hider.IsReady());

		// Sets the gamesstate to intro
		SetGamemodeState(HideAndSeekGamemodeState.Intro);
	}

	protected override void OnSpawnedPlayerController(ModPlayerController playerController)
	{
		base.OnSpawnedPlayerController(playerController);

		// Informs the gamestate that a controller has spawned
		SetGamemodeState(gamemodeState, playerController, true);
	}

	protected override void OnSpawnedPlayerCharacter(ModPlayerController playerController, ModPlayerCharacter playerCharacter)
	{
		base.OnSpawnedPlayerCharacter(playerController, playerCharacter);

		// Check to see if the seeker has respawned
		ModHideAndSeekPlayerController seekPlayerController = playerController as ModHideAndSeekPlayerController;
		if (seekPlayerController && seekPlayerController.IsSeeker())
		{
			OnSeekerRespawned(seekerController, playerCharacter);
		}
	}

	protected override void OnServerPlayerDied(ModPlayerController playerController, ModPlayerCharacter playerCharacter)
	{
		base.OnServerPlayerDied(playerController, playerCharacter);

		ModHideAndSeekPlayerController controller = playerController as ModHideAndSeekPlayerController;
		if (controller)
		{
			if (controller.IsSeeker())
			{
				// Respawn the seeker if they died (Most likely they fell through the map)
				RespawnPlayerCharacter(playerController);
			}
			else
			{
				// Otherwise they are probably the hider and they fell through the map so assign them to spectator
				controller.ServerHiderCaught(null);
			}
		}
	}

	protected override void OnDestroyedPlayerController(ModPlayerController playerController)
	{
		base.OnDestroyedPlayerController(playerController);

		hiderControllers.Remove(playerController);
	}

	void OnSeekerRespawned(ModPlayerController seekerController, ModPlayerCharacter playerCharacter)
	{
		Debug.Log("Seeker respawned");

		if (gamemodeState != HideAndSeekGamemodeState.Outro)
		{
			// If the seeker has respawned then update all spectator cameras so they are specating the seeker
			foreach (ModHideAndSeekPlayerController controller in spectators)
			{
				ModCameraFocus cameraFocus = seekerController.GetCurrentCameraFocus();
				if (cameraFocus)
				{
					controller.SetOwnerCameraFocus(cameraFocus);
				}
			}
		}
	}

	/// <summary>
	/// Assigns a controller to spectate
	/// </summary>
	/// <param name="controller"></param>
	public void AssignSpectator(ModHideAndSeekPlayerController controller)
	{
		if (spectators.Add(controller))
		{
			if (gamemodeState != HideAndSeekGamemodeState.Outro)
			{
				if (seekerController)
				{
					ModPlayerControllerSpectate spectate = controller.GetModPlayerControllerSpectate();
					if (spectate)
					{
						spectate.ServerSetSpectating(true);
					}
				}
			}
		}
	}

	/// <summary>
	/// Unassigns a controller to stop spectating
	/// </summary>
	/// <param name="controller"></param>
	public void UnassignSpectator(ModHideAndSeekPlayerController controller)
	{
		if (spectators.Remove(controller))
		{
			ModPlayerControllerSpectate spectate = controller.GetModPlayerControllerSpectate();
			if (spectate)
			{
				spectate.ServerSetSpectating(false);
			}
		}
	}

	private bool bWinnerSet;

	/// <summary>
	/// Called when there is a winner
	/// </summary>
	/// <param name="winner"></param>
	void ServerSetWinner(HideAndSeekWinner winner)
	{
		if (bWinnerSet)
			return;

		bWinnerSet = true;

		// Sets gamestate to outro
		SetGamemodeState(HideAndSeekGamemodeState.Outro);

		// Stops all controllers from respawning
		ModInstance.Instance.IterateModPlayerControllers(x =>
		{
			ModHideAndSeekPlayerController controller = x as ModHideAndSeekPlayerController;
			if (controller)
			{
				controller.SetAllowedToRespawn(false);

				ModPlayerControllerSpectate spectate = controller.GetModPlayerControllerSpectate();
				if (spectate)
				{
					spectate.ServerSetSpectating(false);
				}
			}

		});

		// Spawns the winning stage
		if (winnerStagePrefab)
		{
			ModNetworkManager.Instance.InstantiateNetworkPrefab(winnerStagePrefab.gameObject, x =>
			{
				ModHideAndSeekWinningStage winnerStage = x as ModHideAndSeekWinningStage;
				if (winnerStage)
				{
					if (winner == HideAndSeekWinner.Seeker)
					{
						winnerStage.ServerShowWinners(this, "Seeker Wins", seekerController);
					}
					else
					{
						List<ModPlayerController> controllers = new List<ModPlayerController>();
						ModInstance.Instance.GetModPlayerControllers(controllers);

						controllers.Remove(seekerController);
						controllers.RemoveAll(x =>
						{
							ModHideAndSeekPlayerController controller = x as ModHideAndSeekPlayerController;

							return spectators.Contains(controller);
						});

						winnerStage.ServerShowWinners(this, "Hiders Wins", controllers.ToArray());
					}
				}
			}, winnerStageSpawnPoint.position, winnerStageSpawnPoint.rotation, null, true);
		}

		// Return to lobby after X Time
		StartCoroutine(ReturnToLobbyAfterSeconds(ReturnToLobbySeconds));
	}

	IEnumerator ReturnToLobbyAfterSeconds(float seconds)
	{
		yield return new WaitForSeconds(seconds);

		ModInstance.Instance.ServerPlayAgainOrReturnToLobby();
	}

	IEnumerator Intro()
	{
		// Starts playing the intro camera animation
		if (introCamera_Seeker != null)
		{
			introCamera_Seeker.Play();
		}

		if (introCamera_Hider != null)
		{
			introCamera_Hider.Play();
		}

		ModPlayerController[] controllers = ModInstance.Instance.GetModPlayerControllers();

		// Finds a seeker based on random chance
		if (controllers.Length > 0)
		{
			seekerController = controllers[UnityEngine.Random.Range(0, controllers.Length)];
		}

		// Informs all clients whether they are the seeker or not
		foreach (ModPlayerController controller in controllers)
		{
			ModHideAndSeekPlayerController hideAndSeekPlayerController = controller as ModHideAndSeekPlayerController;

			if (controller != seekerController)
			{
				hiderControllers.Add(controller);
			}

			if (hideAndSeekPlayerController)
			{
				hideAndSeekPlayerController.ServerSetIsSeeker(seekerController == controller);
			}
		}

		// Spawns all player characters
		foreach (ModPlayerController controller in controllers)
		{
			SpawnPlayerCharacter(controller, null, false);

			// But disable their input untill the intro is done
			ModPlayerControllerInputManager inputManager = controller.GetModPlayerControllerInputManager();
			if (inputManager)
			{
				inputManager.DisablePlayerTransformInput(this);
			}
		}

		// Wait X time untill we show the instructions
		yield return new WaitForSeconds(timeTillInstructionsAppear);

		// Show instructions
		foreach (ModPlayerController controller in controllers)
		{
			ModHideAndSeekPlayerController hideController = controller as ModHideAndSeekPlayerController;
			if (hideController)
			{
				hideController.ServerSetInstructionsVisible(true);
			}
		}

		// Wait untill the intro has been completed
		yield return new WaitUntil(() => introCamera_Hider.HasFinished() && introCamera_Seeker.HasFinished());

		// Hide instructions
		foreach (ModPlayerController controller in controllers)
		{
			ModHideAndSeekPlayerController hideController = controller as ModHideAndSeekPlayerController;
			if (hideController)
			{
				hideController.ServerSetInstructionsVisible(false);
			}
		}

		foreach (ModPlayerController controller in controllers)
		{
			ModHideAndSeekPlayerController hideAndSeekPlayerController = controller as ModHideAndSeekPlayerController;

			// If you are the seeker then allow respawning
			hideAndSeekPlayerController.SetAllowedToRespawn(hideAndSeekPlayerController.IsSeeker());

			// Enable input so everyone can move
			ModPlayerControllerInputManager inputManager = controller.GetModPlayerControllerInputManager();
			if (inputManager)
			{
				inputManager.EnablePlayerTransformInput(this);
			}
		}

		// Sets the gamestate to countdown
		SetGamemodeState(HideAndSeekGamemodeState.Countdown);
	}

	IEnumerator Countdown()
	{
		if (timeToHideTimer)
		{
			// Starts hiders countdown timer
			timeToHideTimer.ServerStartTimer(timeToHideSeconds);

			// Waits untill countdown timer has finished or if the seeker has left
			yield return new WaitUntil(() => !timeToHideTimer.IsTimerRunning() || !seekerController);

			// Stops hiders countdown timer
			timeToHideTimer.ServerStopTimer();
		}

		SetGamemodeState(HideAndSeekGamemodeState.Game);
	}

	IEnumerator Game()
	{
		// Starts game timer
		if (gameTimer)
		{
			gameTimer.ServerStartTimer(timeToSeekSeconds);
		}

		bool bHasPingedEveryone = false;

		while (true)
		{
			yield return null;

			// If the timer runs out or there is no seeker then hiders win
			if ((!gameTimer.IsTimerRunning()) || !seekerController)
			{
				// Hiders win
				ServerSetWinner(HideAndSeekWinner.Hiders);
				break;
			}
			else
			{
				// If there is no more hiders then seeker wins
				if (hiderControllers.Count == spectators.Count)
				{
					yield return new WaitForSeconds(2.0f);
					// Seekers win
					ServerSetWinner(HideAndSeekWinner.Seeker);
					break;
				}
			}

			// When X time hits - ping all hiders!
			if (gameTimer.GetSecondsLeft() <= 30 && !bHasPingedEveryone)
			{
				bHasPingedEveryone = true;

				if (pingSystem)
				{
					pingSystem.ServerPingEveryone();
				}
			}
		}

		// Stops game timer
		if (gameTimer)
		{
			gameTimer.ServerStopTimer();
		}
	}

	IEnumerator Outro()
	{
		yield return null;
	}

	void SetGamemodeState(HideAndSeekGamemodeState gamemodeState)
	{
		this.gamemodeState = gamemodeState;

		if (gamemodeCoroutine != null)
		{
			StopCoroutine(gamemodeCoroutine);
		}

		switch (gamemodeState)
		{
			case HideAndSeekGamemodeState.Intro:
				{
					gamemodeCoroutine = StartCoroutine(Intro());
				}
				break;
			case HideAndSeekGamemodeState.Countdown:
				{
					gamemodeCoroutine = StartCoroutine(Countdown());
				}
				break;
			case HideAndSeekGamemodeState.Game:
				{
					// Sets the music controller to game
					ModHideMusicController hideMusicController = FindObjectOfType<ModHideMusicController>();
					if (hideMusicController)
					{
						hideMusicController.ServerModeComplete(ModHideMusicController.HideMusicMode.Game);
					}

					// Opens the seekers doors
					if (seekersDoors != null)
					{
						foreach (GameObject door in seekersDoors)
						{
							if (door)
							{
								ModIHideAndSeekSeekerDoor seekerDoor = door.GetComponent<ModIHideAndSeekSeekerDoor>();

								if (seekerDoor != null)
								{
									seekerDoor.ServerOpenSeekerDoor();
								}
							}
						}
					}

					// Starts the pinging system
					if (pingSystem)
					{
						pingSystem.ServerStartPingSystem();
					}

					gamemodeCoroutine = StartCoroutine(Game());
				}
				break;
			case HideAndSeekGamemodeState.Outro:
				{
					// Stops the pinging system
					if (pingSystem)
					{
						pingSystem.ServerStopPingSystem();
					}

					// Sets the music controller to complete
					ModHideMusicController hideMusicController = FindObjectOfType<ModHideMusicController>();
					if (hideMusicController)
					{
						hideMusicController.ServerModeComplete(ModHideMusicController.HideMusicMode.Complete);
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

	void SetGamemodeState(HideAndSeekGamemodeState gamemodeState, ModPlayerController playerController, bool bAlreadyStarted)
	{
		switch (gamemodeState)
		{
			case HideAndSeekGamemodeState.Intro:
				{
					ModHideAndSeekPlayerController hideAndSeekPlayerController = playerController as ModHideAndSeekPlayerController;
					if (hideAndSeekPlayerController)
					{
						// Sets the controllers camera to the intro camera
						if (hideAndSeekPlayerController.IsSeeker())
						{
							introCamera_Seeker.Assign(playerController);
						}
						else
						{
							introCamera_Hider.Assign(playerController);
						}

						// Stop respawning
						hideAndSeekPlayerController.SetAllowedToRespawn(false);
					}
				}
				break;
			case HideAndSeekGamemodeState.Countdown:
				{
					ModHideAndSeekPlayerController controller = playerController as ModHideAndSeekPlayerController;
					if (controller)
					{
						// Informs the client which timer we are using which is the hiders timer
						controller.ServerSetTimer(timeToHideTimer);
						// Shows the gameplay ui
						controller.ServerSetGameplayUIVisible(true);

						// If you are the seeker then allow respawning
						controller.SetAllowedToRespawn(controller.IsSeeker());
					}

					playerController.SetOwnerCameraFocusPlayer();
				}
				break;
			case HideAndSeekGamemodeState.Game:
				{
					ModHideAndSeekPlayerController controller = playerController as ModHideAndSeekPlayerController;
					if (controller)
					{
						// Informs the client which timer we are using which is the game timer
						controller.ServerSetTimer(gameTimer);
						// Show the gameplay ui
						controller.ServerSetGameplayUIVisible(true);

						// If you are the seeker then allow respawning
						controller.SetAllowedToRespawn(controller.IsSeeker());
					}
				}
				break;
			case HideAndSeekGamemodeState.Outro:
				{
					ModHideAndSeekPlayerController controller = playerController as ModHideAndSeekPlayerController;
					if (controller)
					{
						// Hides the gameplay ui
						controller.ServerSetGameplayUIVisible(false);

						// Stop respawning
						controller.SetAllowedToRespawn(false);
					}
				}
				break;
		}
	}

	// These are just basic counters so that two players won't spawn in the game spawn point
	private int hiderSpawnIndex;
	private int seekerSpawnIndex;

	public override ModPlayerCharacterSpawnPoint GetPlayerSpawnPoint(ModPlayerController playerController)
	{
		if (hiderControllers.Contains(playerController))
		{
			// If you are a hider then use the hiders spawn points
			return hidersSpawnPoints[hiderSpawnIndex++ % hidersSpawnPoints.Length];
		}
		else
		{
			// If you are the seeker then use the seeker spawn points
			return seekersSpawnPoints[seekerSpawnIndex++ % seekersSpawnPoints.Length];
		}
	}

	public bool IsAllowedToBeCaught()
	{
		return gamemodeState == HideAndSeekGamemodeState.Game;
	}
}
