using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ModWobblyLife
{
    [CustomEditor(typeof(ModGUIDComponent))]
    public class ModGUIDComponentEditor : Editor
    {
        private string currentGUID;

        void OnEnable()
        {
            ModGUIDComponent component = target as ModGUIDComponent;
            if (component)
            {
                currentGUID = component.GetGUIDString();
            }
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            ModGUIDComponent component = target as ModGUIDComponent;

            if (!component) return;

            bool bDirty = false;

            if (GUILayout.Button("Generate"))
            {
                component.GenerateNewGUID();
                bDirty = true;

                currentGUID = component.GetGUIDString();
            }

            GUILayout.Label("Set GUID");
            currentGUID = GUILayout.TextField(currentGUID);
            if (GUILayout.Button("Apply GUID"))
            {
                component.SetGUID(currentGUID);
                bDirty = true;
            }

            if (bDirty)
            {
                EditorUtility.SetDirty(component);
            }
        }
    }
}
