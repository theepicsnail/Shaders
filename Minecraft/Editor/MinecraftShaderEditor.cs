using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MinecraftShaderEditor : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);
        if (GUILayout.Button("Show animation generator"))
        {
            MinecraftShaderAnimationWindow w = EditorWindow.GetWindow<MinecraftShaderAnimationWindow>();
            if(Selection.activeGameObject != null)
                w.source = Selection.activeGameObject.GetComponent<TrailRenderer>();
            w.Show();

        }
    }
}

public class MinecraftShaderAnimationWindow : EditorWindow
{
    Transform avatar;
    public TrailRenderer source;
    string path = "Assets/Snail/shaders/Minecraft/Generated";
    string animationPath = null;

    private void OnGUI()
    {
        GUILayout.Label("Trail renderer to create animations for:");
        source = (TrailRenderer)EditorGUILayout.ObjectField(source, typeof(TrailRenderer), true);
        if (source == null)
        {
            colorLabel("Required trail renderer.", Color.red);
            return;
        }
        if (source.widthMultiplier != 0)
        {
            colorLabel("Trail width should be 0", Color.red);
            return;
        }
        computeAvatarPath();
        if (animationPath == null)
        {
            colorLabel("Trail is not on an avatar.", Color.red);
            return;
        }
        
        
        GUILayout.Space(20);
        GUILayout.Label("Animation destination:");
        GUILayout.Label(path);
        if (GUILayout.Button("Change"))
        {
            string newpath = EditorUtility.SaveFolderPanel("Select folder", path, "");
            if (newpath.IndexOf(Application.dataPath) == 0)
                path = newpath.Replace(Application.dataPath, "Assets");
            else
                Debug.LogError("Path must be under Assets directory: " + Application.dataPath);
        }

        if (System.IO.File.Exists(path + "/Choose.anim") ||
            System.IO.File.Exists(path + "/Clear.anim") ||
            System.IO.File.Exists(path + "/Minecraft.overrideController"))
            colorLabel("Warning: This will overwrite files here.", Color.blue);


        GUILayout.Space(20);
        if (GUILayout.Button("Generate animations"))
        {
            generateAnimations();
        }
        GUILayout.Label("Optionally, setup a default controller on your avatar.");
        if (GUILayout.Button("Setup controller"))
            setupController();
    }

    private void generateAnimations()
    {
        AnimationCurve zeroCurve = new AnimationCurve(new Keyframe[]{
            new Keyframe(0,0),
            new Keyframe(1/60f,0)});

        AnimationClip choose = new AnimationClip();
        choose.SetCurve(animationPath, typeof(TrailRenderer), "m_MinVertexDistance", zeroCurve);
        AssetDatabase.CreateAsset(choose, path +"/Choose.anim");
        
        AnimationClip clear = new AnimationClip();
        clear.SetCurve(animationPath, typeof(TrailRenderer), "m_Time", zeroCurve);
        AssetDatabase.CreateAsset(clear, path + "/Clear.anim");
    }

    public static readonly string TEMPLATE_PATH = "Assets/VRCSDK/Examples/Sample Assets/Animation/AvatarControllerTemplate.controller";
    private void setupController()
    {
        AnimatorOverrideController o = new AnimatorOverrideController();
        o.runtimeAnimatorController = AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(TEMPLATE_PATH);
        AssetDatabase.CreateAsset(o, path + "/Minecraft.overrideController");

        VRCSDK2.VRC_AvatarDescriptor descriptor = avatar.gameObject.GetComponent<VRCSDK2.VRC_AvatarDescriptor>();
        descriptor.CustomSittingAnims = o;
        descriptor.CustomStandingAnims = o;

        Selection.activeObject = o;
        EditorGUIUtility.PingObject(o);
    }

    private void colorLabel(string s, Color c)
    {
        var style = new GUIStyle(GUI.skin.label);
        style.normal.textColor = c;
        GUILayout.Label(s, style);
    }

    void computeAvatarPath()
    {
        avatar = null;
        Transform cur = source.transform;
        string path = "";
        do
        {
            if (cur.GetComponent<VRCSDK2.VRC_AvatarDescriptor>() != null)
            {
                avatar = cur;
                break;
            }
            if (path.Length > 0)
                path = cur.name + "/" + path;
            else
                path = cur.name;
            cur = cur.parent;
        } while (cur != null);

        animationPath = avatar == null ? null : path;

    }
}

//GUILayout.SelectionGrid(0, new string[] { "A", "B", "c" }, 2, (GUILayoutOption[])null);