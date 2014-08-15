module Bubbledash where

import BoxesAndBubbles as BB
import BoxesAndBubblesBodies as BBB

{- let's see.. I want bubbles rising when stuff happens
bubbles can appear and disappear dynamically
let's say they have a ttl for now. the bubbles have some info attached.
I guess for starters we'll just use ttl and some string.
-}

ttl = 60 -- 1 minute for now?
bubbleTag = "some string"

-- the Thing is whatever we want displayed in the dash
type Thing = { ttl: Int, tag: String, body: Int }


-- so this draws an enriched bubble, I hope?
draw: (BBB.Body, Thing) -> Form
draw ({pos, shape}, {ttl, tag}) = 
  let s = case shape of
        BBB.Bubble radius -> circle radius
        BBB.Box (w,h) -> rect (w*2) (h*2)
      body = outlined (solid black) s
      info = concat [tag, "\n", show ttl] |> toText |> centered |> toForm
  in group [body, info] |> move pos

aBubble = BB.bubble 100 1 0.1 (0,0) (0,0)

scene bodies = 
  let drawnBodies = map draw bodies 
  in collage 800 800 drawnBodies

s1 = BB.step (0,0) (0,0) [aBubble]


main = scene [(aBubble,Thing ttl bubbleTag 0)]
--main = asText "bub"