-- Copyright Spencer Janssen <spencerjanssen@gmail.com>
--           Tomas Janousek <tomi@nomi.cz>
-- BSD3 (see LICENSE)
--
-- Reads from standard input and writes to an X propery on root window.
-- To be used with XPropertyLog:
--  Add it to commands:
--      Run XPropertyLog "_XMONAD_LOG_CUSTOM"
--  Add it to the template:
--      template = "... %_XMONAD_LOG_CUSTOM% ..."
--  Run:
--      $ blah blah | xmonadpropwrite _XMONAD_LOG_CUSTOM

import Control.Monad
import Graphics.X11
import Graphics.X11.Xlib.Extras
import qualified Data.ByteString as B
import Foreign.C (CChar)
import System.IO
import System.Environment

main = do
    atom <- flip fmap getArgs $ \args -> case args of
        [a] -> a
        _   -> "_XMONAD_LOG"

    d <- openDisplay ""
    xlog <- internAtom d atom False
    ustring <- internAtom d "UTF8_STRING" False

    root  <- rootWindow d (defaultScreen d)

    forever $ do
        msg <- B.getLine
        changeProperty8 d root xlog ustring propModeReplace (encodeCChar msg)
        sync d True

    return ()

encodeCChar :: B.ByteString -> [CChar]
encodeCChar = map fromIntegral . B.unpack
