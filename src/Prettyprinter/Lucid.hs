module Prettyprinter.Lucid where

import qualified Data.Text as T
import Lucid
import Prettyprinter.Render.Util.SimpleDocTree

renderHtml :: SimpleDocTree (Html () -> Html ()) -> Html ()
renderHtml = \case
    STEmpty -> pure ()
    STChar c -> toHtml $ T.singleton c
    STText _ t -> toHtml t
    STLine i -> br_ [] >> toHtml (textSpaces i)
    STAnn ann content -> ann $ renderHtml content
    STConcat contents -> foldMap renderHtml contents
  where
    textSpaces n = T.replicate n $ T.singleton ' '
