{-# LANGUAGE DeriveFoldable             #-}
{-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

-- Module      : Network.AWS.Data.List1
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Network.AWS.Data.List1
    ( List1 (..)
    , _List1
    , parseXMLList1
    ) where

import           Control.Lens         (makePrisms)
import           Control.Monad
import           Data.Aeson
import           Data.List.NonEmpty   (NonEmpty (..))
import qualified Data.List.NonEmpty   as NonEmpty
import           Data.Text            (Text)
import           GHC.Exts
import           Network.AWS.Data.XML
import           Text.XML             (Node)

newtype List1 a = List1 { toNonEmpty :: NonEmpty a }
    deriving
        ( Functor
        , Monad
        , Applicative
        , Foldable
        , Traversable
        , Eq
        , Ord
        , Read
        , Show
        )

instance IsList (List1 a) where
   type Item (List1 a) = a

   fromList = List1 . NonEmpty.fromList
   toList   = NonEmpty.toList . toNonEmpty

makePrisms ''List1

instance FromJSON a => FromJSON (List1 a) where
    parseJSON = withArray "List1" (go >=> traverse parseJSON)
      where
        go = maybe (fail empty) (pure . List1)
           . NonEmpty.nonEmpty
           . toList

instance ToJSON a => ToJSON (List1 a) where
    toJSON = toJSON . toList

parseXMLList1 :: FromXML a
              => Text
              -> [Node]
              -> Either String (List1 a)
parseXMLList1 n ns = parseXMLList n ns >>=
    maybe (Left $ empty ++ ": " ++ show n) (Right . List1) . NonEmpty.nonEmpty

empty :: String
empty = "Error parsing empty List1 when expecting at least one element"
