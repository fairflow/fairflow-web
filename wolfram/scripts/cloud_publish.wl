(* ::Package:: *)

(* Publish the interactive documents to Wolfram Cloud with public
   read+interact permissions, for embedding on fairflow.co.uk/design
   via the Wolfram Notebook Embedder.
   Run:  wolframscript -file cloud_publish.wl
   Requires: kernel already cloud-connected ($CloudConnected == True).
   Prints one line per file:  <name> -> <cloud URL>
*)

If[!$CloudConnected, Print["ERROR: not cloud-connected"]; Exit[1]];

downloads = FileNameJoin[{DirectoryName[$InputFileName], "..", "downloads"}];

files = {
  "PrimFairflow_2014_10_27_022.cdf",
  "FibonacciTrees.cdf",
  "Jitterbug2.cdf",
  "Kruskal_export1.cdf",
  "YFrontC.nb"
};

publish[f_] := Module[{src, obj},
  src = FileNameJoin[{downloads, f}];
  If[!FileExistsQ[src], Print[f, " -> MISSING"]; Return[]];
  obj = CopyFile[src, CloudObject["fairflow-web/" <> f]];
  SetPermissions[obj, All -> {"Read", "Interact"}];
  Print[f, " -> ", First[obj]]];

publish /@ files;
