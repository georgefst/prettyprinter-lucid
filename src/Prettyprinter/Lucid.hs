module Prettyprinter.Lucid where

import qualified Data.Text as T
import Lucid
import Prettyprinter.Render.Util.SimpleDocTree

renderHtml :: SimpleDocTree (Html () -> Html ()) -> Html ()
renderHtml =
    let go = \case
            STEmpty -> pure ()
            STChar c -> toHtml $ T.singleton c
            STText _ t -> toHtml t
            STLine i -> br_ [] >> toHtml (T.replicate i $ T.singleton ' ')
            STAnn ann content -> ann $ renderHtml content
            STConcat contents -> foldMap renderHtml contents
     in pre_ . go
