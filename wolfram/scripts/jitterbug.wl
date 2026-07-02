(* ::Package:: *)

(* Buckminster Fuller's Jitterbug transformation — octahedron ->
   cuboctahedron -> (inside-out) and back, as on the original site.
   Run:  wolframscript -file jitterbug.wl
   Outputs (into ../media/):
     jitterbug.png        mid-transformation still
     jitterbug_anim.gif   full open-close cycle
*)

mediaDir = FileNameJoin[{DirectoryName[$InputFileName], "..", "media"}];

(* The eight triangles of the jitterbug are the faces of an octahedron.
   Each rotates about its own axis (the face normal) by t while its
   centre slides outward, tracing octahedron (t=0) -> icosahedron ->
   cuboctahedron (t=Pi/3) and, extended, turning inside out. *)

(* octahedron vertices and faces explicitly *)
V = {{1, 0, 0}, {-1, 0, 0}, {0, 1, 0}, {0, -1, 0}, {0, 0, 1}, {0, 0, -1}} // N;
F = {{1, 3, 5}, {3, 2, 5}, {2, 4, 5}, {4, 1, 5},
     {3, 1, 6}, {2, 3, 6}, {4, 2, 6}, {1, 4, 6}};

jitterTri[f_, t_] := Module[{p = V[[f]], c, n, r},
   c = Mean[p]; n = Normalize[c];
   (* rotate the triangle about its face normal and push it outward so
      edge length is preserved: scale factor for jitterbug opening *)
   r = RotationTransform[t, n, c];
   p = r /@ p;
   (* radial expansion keeping edge length constant *)
   p = (# - c) & /@ p;
   c = c (1 + 0.35 (1 - Cos[2 t]));
   (c + #) & /@ p];

frame[t_] := Graphics3D[
   {EdgeForm[{Thick, Darker@Green}],
    Table[{FaceForm[Directive[Opacity[0.75],
        Blend[{RGBColor[0.13, 0.38, 0.15], RGBColor[0.5, 0.75, 0.32]},
          0.12 + 0.25 Mod[i, 4]]]],
      Polygon[jitterTri[F[[i]], t]]}, {i, 8}]},
   Boxed -> False, Lighting -> "Neutral",
   ViewPoint -> {2.2, 1.4, 1.1}, ViewAngle -> 0.32,
   PlotRange -> 2.2 {{-1, 1}, {-1, 1}, {-1, 1}},
   Background -> White, ImageSize -> 460, SphericalRegion -> True];

(* full cycle: open out to inside-out (t: 0 -> Pi) and return *)
ts = Join[Range[0., Pi, Pi/36], Range[Pi, 0., -Pi/36]];
frames = frame /@ ts;
Export[FileNameJoin[{mediaDir, "jitterbug_anim.gif"}], frames,
  "DisplayDurations" -> 0.09, "AnimationRepetitions" -> Infinity];
Print["animation done"];

Export[FileNameJoin[{mediaDir, "jitterbug.png"}],
  Show[frame[Pi/3], ImageSize -> 800]];
Print["still done"];
