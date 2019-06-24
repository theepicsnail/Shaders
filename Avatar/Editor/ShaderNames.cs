using System.IO;
using UnityEditor;
using UnityEngine;

public class ShaderNames : EditorWindow
{

    [MenuItem("Snail/Fix Shader Names")]
    static void Create()
    {
        DirectoryInfo dir = new DirectoryInfo("Assets/Snail/shaders");

        FileInfo[] shaders = dir.GetFiles("*.shader", SearchOption.AllDirectories);


		string prefix = dir.FullName;
		string fullName = "";
        foreach (FileInfo shader in shaders)
        {
			fullName=shader.FullName;
			process(dir.FullName, fullName);
        }
		Debug.Log("Done.");
    }

	private static void process(string prefix, string fullName){
		
            string name = "snail" + fullName.Replace(prefix, "").Replace(".shader", "").Replace("\\", "/");

            string[] lines = File.ReadAllLines(fullName);
            int lineNo = 0;
            bool found = false;
            while (lineNo < lines.Length && !found)
            {
                if (lines[lineNo].StartsWith("Shader ")) 
                    found = true;
                else
					lineNo++;
            }

			if (!found)
            {
                Debug.LogWarning("No shader line: " + fullName);
                return;
            }

            string[] parts = lines[lineNo].Split('"');
            if (name.Equals(parts[1])) return;

            parts[1] = name;
			lines[lineNo] = string.Join("\"", parts);
			File.WriteAllLines(fullName, lines);
			Debug.LogWarning("Fixed " + fullName);
	}

}
