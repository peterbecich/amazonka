{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}

-- Module      : Network.AWS.DynamoDB.ListTables
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- | Returns an array of table names associated with the current account and
-- endpoint. The output from /ListTables/ is paginated, with each page
-- returning a maximum of 100 table names.
--
-- <http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_ListTables.html>
module Network.AWS.DynamoDB.ListTables
    (
    -- * Request
      ListTables
    -- ** Request constructor
    , listTables
    -- ** Request lenses
    , ltExclusiveStartTableName
    , ltLimit

    -- * Response
    , ListTablesResponse
    -- ** Response constructor
    , listTablesResponse
    -- ** Response lenses
    , ltrLastEvaluatedTableName
    , ltrTableNames
    , ltrStatus
    ) where

import           Network.AWS.DynamoDB.Types
import           Network.AWS.Pager
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | Represents the input of a /ListTables/ operation.
--
-- /See:/ 'listTables' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ltExclusiveStartTableName'
--
-- * 'ltLimit'
data ListTables = ListTables'
    { _ltExclusiveStartTableName :: !(Maybe Text)
    , _ltLimit                   :: !(Maybe Nat)
    } deriving (Eq,Read,Show)

-- | 'ListTables' smart constructor.
listTables :: ListTables
listTables =
    ListTables'
    { _ltExclusiveStartTableName = Nothing
    , _ltLimit = Nothing
    }

-- | The first table name that this operation will evaluate. Use the value
-- that was returned for /LastEvaluatedTableName/ in a previous operation,
-- so that you can obtain the next page of results.
ltExclusiveStartTableName :: Lens' ListTables (Maybe Text)
ltExclusiveStartTableName = lens _ltExclusiveStartTableName (\ s a -> s{_ltExclusiveStartTableName = a});

-- | A maximum number of table names to return. If this parameter is not
-- specified, the limit is 100.
ltLimit :: Lens' ListTables (Maybe Natural)
ltLimit = lens _ltLimit (\ s a -> s{_ltLimit = a}) . mapping _Nat;

instance AWSPager ListTables where
        page rq rs
          | stop (rs ^. ltrLastEvaluatedTableName) = Nothing
          | stop (rs ^. ltrTableNames) = Nothing
          | otherwise =
            Just $ rq &
              ltExclusiveStartTableName .~
                rs ^. ltrLastEvaluatedTableName

instance AWSRequest ListTables where
        type Sv ListTables = DynamoDB
        type Rs ListTables = ListTablesResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 ListTablesResponse' <$>
                   (x .?> "LastEvaluatedTableName") <*>
                     (x .?> "TableNames" .!@ mempty)
                     <*> (pure (fromEnum s)))

instance ToHeaders ListTables where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("DynamoDB_20120810.ListTables" :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.0" :: ByteString)])

instance ToJSON ListTables where
        toJSON ListTables'{..}
          = object
              ["ExclusiveStartTableName" .=
                 _ltExclusiveStartTableName,
               "Limit" .= _ltLimit]

instance ToPath ListTables where
        toPath = const "/"

instance ToQuery ListTables where
        toQuery = const mempty

-- | Represents the output of a /ListTables/ operation.
--
-- /See:/ 'listTablesResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ltrLastEvaluatedTableName'
--
-- * 'ltrTableNames'
--
-- * 'ltrStatus'
data ListTablesResponse = ListTablesResponse'
    { _ltrLastEvaluatedTableName :: !(Maybe Text)
    , _ltrTableNames             :: !(Maybe [Text])
    , _ltrStatus                 :: !Int
    } deriving (Eq,Read,Show)

-- | 'ListTablesResponse' smart constructor.
listTablesResponse :: Int -> ListTablesResponse
listTablesResponse pStatus =
    ListTablesResponse'
    { _ltrLastEvaluatedTableName = Nothing
    , _ltrTableNames = Nothing
    , _ltrStatus = pStatus
    }

-- | The name of the last table in the current page of results. Use this
-- value as the /ExclusiveStartTableName/ in a new request to obtain the
-- next page of results, until all the table names are returned.
--
-- If you do not receive a /LastEvaluatedTableName/ value in the response,
-- this means that there are no more table names to be retrieved.
ltrLastEvaluatedTableName :: Lens' ListTablesResponse (Maybe Text)
ltrLastEvaluatedTableName = lens _ltrLastEvaluatedTableName (\ s a -> s{_ltrLastEvaluatedTableName = a});

-- | The names of the tables associated with the current account at the
-- current endpoint. The maximum size of this array is 100.
--
-- If /LastEvaluatedTableName/ also appears in the output, you can use this
-- value as the /ExclusiveStartTableName/ parameter in a subsequent
-- /ListTables/ request and obtain the next page of results.
ltrTableNames :: Lens' ListTablesResponse [Text]
ltrTableNames = lens _ltrTableNames (\ s a -> s{_ltrTableNames = a}) . _Default;

-- | FIXME: Undocumented member.
ltrStatus :: Lens' ListTablesResponse Int
ltrStatus = lens _ltrStatus (\ s a -> s{_ltrStatus = a});
