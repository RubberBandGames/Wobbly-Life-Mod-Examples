using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A interface used to open the seeker door
/// </summary>
public interface ModIHideAndSeekSeekerDoor
{
	/// <summary>
	/// To be called by server only
	/// Opens the seeker door whatever that may be
	/// </summary>
	public void ServerOpenSeekerDoor();
}
