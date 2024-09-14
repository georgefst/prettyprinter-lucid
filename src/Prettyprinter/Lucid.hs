module Prettyprinter.Lucid (renderHtml) where

import qualified Data.Text as T
import Lucid (Html, ToHtml (toHtml), br_, pre_)
import Lucid.Base (makeAttribute)
import Prettyprinter.Render.Util.SimpleDocTree (SimpleDocTree (..))

renderHtml :: SimpleDocTree (Html () -> Html ()) -> Html ()
renderHtml =
    let go = \case
            STEmpty -> pure ()
            STChar c -> toHtml $ T.singleton c
            STText _ t -> toHtml t
            STLine i -> br_ [] >> toHtml (T.replicate i $ T.singleton ' ')
            STAnn ann content -> ann $ go content
            STConcat contents -> foldMap go contents
     in pre_ [makeAttribute "style" "margin: 0"] . go
