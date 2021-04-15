# Logeion Mapping Project: Plautus

This is some custom code written to fixup line numbers in Logeon citations of Plautus. The work is in progress, but there's enough to evaluate.

# Scripts

## map-citations.pl

This maps citations of Plautus' plays in Lewis and Short, which are in the format

``` sh
play:act:scene:line-in-scene
```

to

``` sh
play:act:scene:line-in-scene, play:act:scene:absolute-line-number.
```
I keep both references (in file "good.txt") for debugging purposes. If these look correct, I can run a script to replace the citations on the left of the comma with those on the right, as it were. Errors are output to "bad.txt" with enough debugging info to enable curation of these entries, I believe. See "Files, below."


## pull-citations.pl

This simply pulls references to Plautus from the Lewis and Short .xml files via a regex. Not worthy of note. Some ad-hoc scripting, one-liners, etc, were used to create the master citation list from this. (See "Files" below)


# Mapping Algorithm
The citations this script encounters are of the patterns:

* play:act:line. This is assumed for no good reason to be a line in a corrupt play (20, 21), or to be scene 1. In the latter case this is mapped to play:act:"1":line. This needs verification.
* play:prol. line (literally, e.g. "010:prol. 123"). This is basically left alone, prologue line assumed to be absolute from the start of the play.
* play:act:scene:line-in-scene. The line-in-scene is rewritten according to the formula 

``` sh
absolute-start-of-scene + line-in-scene 
```

Just have to check off-by-one errors.


# Output Files

## good.txt
The citations which properly mapped to an absolute line number via the mappings I was given.

## bad.txt
Those which don't map. Debug output is given, usually showing that the scene in question can't possibly exist, e.g. play 010, act 2, scene 11, etc. Hand-curation of the original entry is necessary.

# Input Files

## citations.txt
Citation references extracted by devious means from the Lewis and Short .xml files, in the format play:act:scene:line, or act:prol. line, or occasionally play:line, as described above.

## section_starts.txt
This is the mapping of scene starts to absolute line numbers as provided by ??, integrated into a single list.

## number_to_title.txt
Number of the play as known to Logeion mapped to the canonical title of the Plautus work in question. Not used yet, will be used in some citation fixups.
