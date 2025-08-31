{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TemplateHaskell #-}

module Frontend where

import Control.Lens ((^.))
import Control.Monad
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Language.Javascript.JSaddle (liftJSM, js, js1, jsg)
import Language.Javascript.JSaddle.Evaluate (eval)

import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Obelisk.Generated.Static

import Reflex.Dom.Core

import Common.Api
import Common.Route


-- This runs in a monad that can be run on the client or the server.
-- To run code in a pure client or pure server context, use one of the
-- `prerender` functions.




frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = do
      el "title" $ text "Agus Minimal Example"
      elAttr "script" ("type" =: "application/javascript" <> "src" =: $(static "lib.js")) blank
      elAttr "link" ("href" =: $(static "main.css") <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
  , _frontend_body = do
      el "div" $ do
      	el "p" $ text "write something"
	elAttr "audio" ("controls" =: "" <> "src" =: $(static "sounder.mp3")) blank
--	welcomeComp
	t <- inputElement def
	text " "
	el "ol" $ do
	 el "li" $ text "something"
	 el "li" $ dynText $ _inputElement_value t
	text " "
	prerender_ blank $ liftJSM $ void
	         $ jsg ("window" :: T.Text)
	         ^. js ("skeleton_lib" :: T.Text)
	         ^. js1 ("log" :: T.Text) ("Hello, World!" :: T.Text)
		 ^. js1 ("new Audio('alarm.mp3').play();" :: T.Text)

	
	--(btn, _) <- el' "button" $ text "Start alarm"
	--let clickEv = domEvent Click btn
	-- Start a timer 5 seconds after click
	--tickEv <- delay 5 clickEv
	--performEvent_ $ ffor tickEv $ \_ -> do
	 --liftJSM $ void $ eval ("new Audio('alarm.mp3').play();" :: T.Text)
      return ()
  }

--welcomeComp = el "h1" $ text "Welcome agus!"
