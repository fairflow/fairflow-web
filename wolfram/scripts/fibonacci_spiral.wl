(* ::Package:: *)

(* Fibonacci / golden-angle planting design — regenerates the classic
   Fairflow spiral planting visuals as web media.
   Run:  wolframscript -file fibonacci_spiral.wl
   Outputs (into ../media/):
     fibonacci_spiral.png        high-res still, 108 plants
     fibonacci_spiral_anim.gif   plants placed one by one
     fibonacci_families.png      the {13, 21} spiral families picked out
*)

mediaDir = FileNameJoin[{DirectoryName[$InputFileName], "..", "media"}];

golden = 2. Pi (1 - 1/GoldenRatio);            (* the golden angle, ~137.5\[Degree] *)
pt[k_] := Sqrt[k] {Cos[k golden], Sin[k golden]};

(* palette: greens on cream, matching the site *)
plantStyle[k_, n_] := Directive[
   Blend[{RGBColor[0.11, 0.35, 0.12], RGBColor[0.55, 0.78, 0.35]}, k/n],
   EdgeForm[{Thin, Darker@Green}]];

(* --- 1. Still: 108 plants (95 outer + 13 inner circle, as in the
       original Fairtlough/Pollard planting) --- *)
nPlants = 108;
still = Graphics[
   Table[{plantStyle[k, nPlants], Disk[pt[k], 0.36 Sqrt[1 + k/nPlants]]},
     {k, 1, nPlants}],
   Background -> None, ImageSize -> 900, PlotRangePadding -> Scaled[.04]];
Export[FileNameJoin[{mediaDir, "fibonacci_spiral.png"}], still];
Print["still done"];

(* --- 2. Animation: the pattern growing plant by plant --- *)
frames = Table[
    Graphics[
     Table[{plantStyle[k, nPlants], Disk[pt[k], 0.36 Sqrt[1 + k/nPlants]]},
       {k, 1, m}],
     Background -> White, ImageSize -> 420,
     PlotRange -> 1.15 {{-Sqrt[nPlants], Sqrt[nPlants]}, {-Sqrt[nPlants], Sqrt[nPlants]}}],
    {m, 1, nPlants, 1}];
Export[FileNameJoin[{mediaDir, "fibonacci_spiral_anim.gif"}], frames,
  "DisplayDurations" -> Append[ConstantArray[0.06, nPlants - 1], 3],
  "AnimationRepetitions" -> Infinity];
Print["animation done"];

(* --- 3. Spiral families: successive Fibonacci pairs {13, 21} --- *)
famPlot[m_, col_] := Table[
   {col, Thickness[0.004], Opacity[0.7],
    Line[Table[pt[k], {k, r, nPlants, m}]]},
   {r, 1, m}];
families = Graphics[
   {Table[{GrayLevel[0.55], Disk[pt[k], 0.3]}, {k, 1, nPlants}],
    famPlot[13, Darker@Orange], famPlot[21, Darker@Green]},
   Background -> White, ImageSize -> 900, PlotRangePadding -> Scaled[.04]];
Export[FileNameJoin[{mediaDir, "fibonacci_families.png"}], families];
Print["families done"];
