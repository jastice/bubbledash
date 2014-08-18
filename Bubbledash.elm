module Bubbledash where

import BoxesAndBubbles (bubble,box,step)
import BoxesAndBubblesBodies (Body,Bubble,Box)

{- let's see.. I want bubbles rising when stuff happens
bubbles can appear and disappear dynamically
let's say they have a ttl for now. the bubbles have some info attached.
I guess for starters we'll just use ttl and some string.
-}

ttl = 60 -- 1 minute for now?
bubbleTag = "some string"

-- the Thing is whatever we want displayed in the dash
type Thing = { id: Int, ttl: Time, label: String }
-- thing attached to a body, so we can display it after doing physics
type ThingBody = Body Thing


-- so this draws a bubble with Thing data attached to it
draw: ThingBody -> Form
draw {pos, shape, ttl, label} = 
  let s = case shape of
        Bubble radius -> circle radius
        Box (w,h) -> rect (w*2) (h*2)
      body = outlined (solid black) s
      info = concat [label, "\n", show ttl] |> toText |> centered |> toForm
  in group [body, info] |> move pos




thingBody id ttl label body = -- this sucks. why no multi-update syntax?
  let tmp0 = { body | id=id } 
      tmp1 = { tmp0 | ttl=ttl }
      tmp2 = { tmp1 | label=label }
  in tmp2

forces t = ((0,-0.1), (0,0))
tick = forces <~ fps 40

sim bodies = foldp (uncurry step) bodies tick

scene bodies = 
  let drawnBodies = map draw bodies 
  in collage 800 1600 drawnBodies

aBubble = bubble 100 1 0.1 (0,800) (0,0)
main = scene <~ sim [thingBody 0 60 "foobark" aBubble]
