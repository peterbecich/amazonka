{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}

-- Module      : Network.AWS.Redshift.DescribeResize
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

-- | Returns information about the last resize operation for the specified
-- cluster. If no resize operation has ever been initiated for the
-- specified cluster, a @HTTP 404@ error is returned. If a resize operation
-- was initiated and completed, the status of the resize remains as
-- @SUCCEEDED@ until the next resize.
--
-- A resize operation can be requested using ModifyCluster and specifying a
-- different number or type of nodes for the cluster.
--
-- <http://docs.aws.amazon.com/redshift/latest/APIReference/API_DescribeResize.html>
module Network.AWS.Redshift.DescribeResize
    (
    -- * Request
      DescribeResize
    -- ** Request constructor
    , describeResize
    -- ** Request lenses
    , drClusterIdentifier

    -- * Response
    , DescribeResizeResponse
    -- ** Response constructor
    , describeResizeResponse
    -- ** Response lenses
    , drrEstimatedTimeToCompletionInSeconds
    , drrImportTablesNotStarted
    , drrAvgResizeRateInMegaBytesPerSecond
    , drrTargetNumberOfNodes
    , drrTargetNodeType
    , drrImportTablesInProgress
    , drrImportTablesCompleted
    , drrProgressInMegaBytes
    , drrTotalResizeDataInMegaBytes
    , drrElapsedTimeInSeconds
    , drrTargetClusterType
    , drrStatus
    ) where

import           Network.AWS.Prelude
import           Network.AWS.Redshift.Types
import           Network.AWS.Request
import           Network.AWS.Response

-- |
--
-- /See:/ 'describeResize' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'drClusterIdentifier'
newtype DescribeResize = DescribeResize'
    { _drClusterIdentifier :: Text
    } deriving (Eq,Read,Show)

-- | 'DescribeResize' smart constructor.
describeResize :: Text -> DescribeResize
describeResize pClusterIdentifier =
    DescribeResize'
    { _drClusterIdentifier = pClusterIdentifier
    }

-- | The unique identifier of a cluster whose resize progress you are
-- requesting. This parameter is case-sensitive.
--
-- By default, resize operations for all clusters defined for an AWS
-- account are returned.
drClusterIdentifier :: Lens' DescribeResize Text
drClusterIdentifier = lens _drClusterIdentifier (\ s a -> s{_drClusterIdentifier = a});

instance AWSRequest DescribeResize where
        type Sv DescribeResize = Redshift
        type Rs DescribeResize = DescribeResizeResponse
        request = post
        response
          = receiveXMLWrapper "DescribeResizeResult"
              (\ s h x ->
                 DescribeResizeResponse' <$>
                   (x .@? "EstimatedTimeToCompletionInSeconds") <*>
                     (x .@? "ImportTablesNotStarted" .!@ mempty >>=
                        may (parseXMLList "member"))
                     <*> (x .@? "AvgResizeRateInMegaBytesPerSecond")
                     <*> (x .@? "TargetNumberOfNodes")
                     <*> (x .@? "TargetNodeType")
                     <*>
                     (x .@? "ImportTablesInProgress" .!@ mempty >>=
                        may (parseXMLList "member"))
                     <*>
                     (x .@? "ImportTablesCompleted" .!@ mempty >>=
                        may (parseXMLList "member"))
                     <*> (x .@? "ProgressInMegaBytes")
                     <*> (x .@? "TotalResizeDataInMegaBytes")
                     <*> (x .@? "ElapsedTimeInSeconds")
                     <*> (x .@? "TargetClusterType")
                     <*> (pure (fromEnum s)))

instance ToHeaders DescribeResize where
        toHeaders = const mempty

instance ToPath DescribeResize where
        toPath = const "/"

instance ToQuery DescribeResize where
        toQuery DescribeResize'{..}
          = mconcat
              ["Action" =: ("DescribeResize" :: ByteString),
               "Version" =: ("2012-12-01" :: ByteString),
               "ClusterIdentifier" =: _drClusterIdentifier]

-- | Describes the result of a cluster resize operation.
--
-- /See:/ 'describeResizeResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'drrEstimatedTimeToCompletionInSeconds'
--
-- * 'drrImportTablesNotStarted'
--
-- * 'drrAvgResizeRateInMegaBytesPerSecond'
--
-- * 'drrTargetNumberOfNodes'
--
-- * 'drrTargetNodeType'
--
-- * 'drrImportTablesInProgress'
--
-- * 'drrImportTablesCompleted'
--
-- * 'drrProgressInMegaBytes'
--
-- * 'drrTotalResizeDataInMegaBytes'
--
-- * 'drrElapsedTimeInSeconds'
--
-- * 'drrTargetClusterType'
--
-- * 'drrStatus'
data DescribeResizeResponse = DescribeResizeResponse'
    { _drrEstimatedTimeToCompletionInSeconds :: !(Maybe Integer)
    , _drrImportTablesNotStarted             :: !(Maybe [Text])
    , _drrAvgResizeRateInMegaBytesPerSecond  :: !(Maybe Double)
    , _drrTargetNumberOfNodes                :: !(Maybe Int)
    , _drrTargetNodeType                     :: !(Maybe Text)
    , _drrImportTablesInProgress             :: !(Maybe [Text])
    , _drrImportTablesCompleted              :: !(Maybe [Text])
    , _drrProgressInMegaBytes                :: !(Maybe Integer)
    , _drrTotalResizeDataInMegaBytes         :: !(Maybe Integer)
    , _drrElapsedTimeInSeconds               :: !(Maybe Integer)
    , _drrTargetClusterType                  :: !(Maybe Text)
    , _drrStatus                             :: !Int
    } deriving (Eq,Read,Show)

-- | 'DescribeResizeResponse' smart constructor.
describeResizeResponse :: Int -> DescribeResizeResponse
describeResizeResponse pStatus =
    DescribeResizeResponse'
    { _drrEstimatedTimeToCompletionInSeconds = Nothing
    , _drrImportTablesNotStarted = Nothing
    , _drrAvgResizeRateInMegaBytesPerSecond = Nothing
    , _drrTargetNumberOfNodes = Nothing
    , _drrTargetNodeType = Nothing
    , _drrImportTablesInProgress = Nothing
    , _drrImportTablesCompleted = Nothing
    , _drrProgressInMegaBytes = Nothing
    , _drrTotalResizeDataInMegaBytes = Nothing
    , _drrElapsedTimeInSeconds = Nothing
    , _drrTargetClusterType = Nothing
    , _drrStatus = pStatus
    }

-- | The estimated time remaining, in seconds, until the resize operation is
-- complete. This value is calculated based on the average resize rate and
-- the estimated amount of data remaining to be processed. Once the resize
-- operation is complete, this value will be 0.
drrEstimatedTimeToCompletionInSeconds :: Lens' DescribeResizeResponse (Maybe Integer)
drrEstimatedTimeToCompletionInSeconds = lens _drrEstimatedTimeToCompletionInSeconds (\ s a -> s{_drrEstimatedTimeToCompletionInSeconds = a});

-- | The names of tables that have not been yet imported.
--
-- Valid Values: List of table names
drrImportTablesNotStarted :: Lens' DescribeResizeResponse [Text]
drrImportTablesNotStarted = lens _drrImportTablesNotStarted (\ s a -> s{_drrImportTablesNotStarted = a}) . _Default;

-- | The average rate of the resize operation over the last few minutes,
-- measured in megabytes per second. After the resize operation completes,
-- this value shows the average rate of the entire resize operation.
drrAvgResizeRateInMegaBytesPerSecond :: Lens' DescribeResizeResponse (Maybe Double)
drrAvgResizeRateInMegaBytesPerSecond = lens _drrAvgResizeRateInMegaBytesPerSecond (\ s a -> s{_drrAvgResizeRateInMegaBytesPerSecond = a});

-- | The number of nodes that the cluster will have after the resize
-- operation is complete.
drrTargetNumberOfNodes :: Lens' DescribeResizeResponse (Maybe Int)
drrTargetNumberOfNodes = lens _drrTargetNumberOfNodes (\ s a -> s{_drrTargetNumberOfNodes = a});

-- | The node type that the cluster will have after the resize operation is
-- complete.
drrTargetNodeType :: Lens' DescribeResizeResponse (Maybe Text)
drrTargetNodeType = lens _drrTargetNodeType (\ s a -> s{_drrTargetNodeType = a});

-- | The names of tables that are being currently imported.
--
-- Valid Values: List of table names.
drrImportTablesInProgress :: Lens' DescribeResizeResponse [Text]
drrImportTablesInProgress = lens _drrImportTablesInProgress (\ s a -> s{_drrImportTablesInProgress = a}) . _Default;

-- | The names of tables that have been completely imported .
--
-- Valid Values: List of table names.
drrImportTablesCompleted :: Lens' DescribeResizeResponse [Text]
drrImportTablesCompleted = lens _drrImportTablesCompleted (\ s a -> s{_drrImportTablesCompleted = a}) . _Default;

-- | While the resize operation is in progress, this value shows the current
-- amount of data, in megabytes, that has been processed so far. When the
-- resize operation is complete, this value shows the total amount of data,
-- in megabytes, on the cluster, which may be more or less than
-- TotalResizeDataInMegaBytes (the estimated total amount of data before
-- resize).
drrProgressInMegaBytes :: Lens' DescribeResizeResponse (Maybe Integer)
drrProgressInMegaBytes = lens _drrProgressInMegaBytes (\ s a -> s{_drrProgressInMegaBytes = a});

-- | The estimated total amount of data, in megabytes, on the cluster before
-- the resize operation began.
drrTotalResizeDataInMegaBytes :: Lens' DescribeResizeResponse (Maybe Integer)
drrTotalResizeDataInMegaBytes = lens _drrTotalResizeDataInMegaBytes (\ s a -> s{_drrTotalResizeDataInMegaBytes = a});

-- | The amount of seconds that have elapsed since the resize operation
-- began. After the resize operation completes, this value shows the total
-- actual time, in seconds, for the resize operation.
drrElapsedTimeInSeconds :: Lens' DescribeResizeResponse (Maybe Integer)
drrElapsedTimeInSeconds = lens _drrElapsedTimeInSeconds (\ s a -> s{_drrElapsedTimeInSeconds = a});

-- | The cluster type after the resize operation is complete.
--
-- Valid Values: @multi-node@ | @single-node@
drrTargetClusterType :: Lens' DescribeResizeResponse (Maybe Text)
drrTargetClusterType = lens _drrTargetClusterType (\ s a -> s{_drrTargetClusterType = a});

-- | FIXME: Undocumented member.
drrStatus :: Lens' DescribeResizeResponse Int
drrStatus = lens _drrStatus (\ s a -> s{_drrStatus = a});
