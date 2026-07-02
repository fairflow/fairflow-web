(* ::Package:: *)

(* Prim's algorithm on a random weighted graph — animated, matching the
   description in the Graph Theory page: tree edges green, candidate
   edges orange.
   Run:  wolframscript -file prim_mst.wl
   Outputs (into ../media/):
     prim_anim.gif   step-by-step MST growth
     prim_final.png  finished minimal spanning tree
*)

mediaDir = FileNameJoin[{DirectoryName[$InputFileName], "..", "media"}];
SeedRandom[20261];

(* random geometric graph: 12 nodes, edges between nearby nodes *)
n = 12;
pts = RandomReal[{0, 10}, {n, 2}];
edges = Select[Subsets[Range[n], {2}],
   EuclideanDistance[pts[[#[[1]]]], pts[[#[[2]]]]] < 4.6 &];
w[{i_, j_}] := Round[EuclideanDistance[pts[[i]], pts[[j]]], 0.1];

(* Prim from vertex 1, recording state at each step *)
prim[edges_, n_] := Module[{tree = {}, inT = {1}, states = {}, cand, best},
   While[Length[inT] < n,
    cand = Select[edges,
      Xor[MemberQ[inT, #[[1]]], MemberQ[inT, #[[2]]]] &];
    If[cand === {}, Break[]];
    best = First@SortBy[cand, w];
    AppendTo[states, {tree, cand, best}];
    AppendTo[tree, best];
    inT = Union[inT, best]];
   AppendTo[states, {tree, {}, Missing[]}];
   states];

states = prim[edges, n];

edgeLine[e_, col_, th_] := {
   {col, Thickness[th], Line[pts[[e]]]},
   Inset[Framed[Style[w[e], 11, Black], Background -> White,
     FrameStyle -> None, FrameMargins -> 1], Mean[pts[[e]]]]};

frame[{tree_, cand_, best_}] := Graphics[
   {(* untouched edges *)
    Table[edgeLine[e, GrayLevel[0.8], 0.004],
      {e, Complement[edges, tree, cand]}],
    (* candidate edges *)
    Table[edgeLine[e, Darker@Orange, 0.007], {e, cand}],
    (* chosen next edge flashes red *)
    If[! MissingQ[best],
     edgeLine[best, Red, 0.009], {}],
    (* tree so far *)
    Table[edgeLine[e, Darker@Green, 0.010], {e, tree}],
    (* nodes *)
    Table[{If[MemberQ[Flatten[Join[tree, {{1}}]], v],
       Darker@Green, GrayLevel[0.45]],
      Disk[pts[[v]], 0.28], White, FontSize -> 12,
      Text[Style[v, Bold], pts[[v]]]}, {v, n}]},
   Background -> White, ImageSize -> 520, PlotRangePadding -> Scaled[.06]];

frames = frame /@ states;
Export[FileNameJoin[{mediaDir, "prim_anim.gif"}], frames,
  "DisplayDurations" -> Append[ConstantArray[1.1, Length[frames] - 1], 4],
  "AnimationRepetitions" -> Infinity];
Print["animation done"];

Export[FileNameJoin[{mediaDir, "prim_final.png"}],
  Show[frame[Last[states]], ImageSize -> 900]];
Print["still done"];
