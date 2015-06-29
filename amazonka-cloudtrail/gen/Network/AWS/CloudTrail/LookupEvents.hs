{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}

-- Module      : Network.AWS.CloudTrail.LookupEvents
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

-- | Looks up API activity events captured by CloudTrail that create, update,
-- or delete resources in your account. Events for a region can be looked
-- up for the times in which you had CloudTrail turned on in that region
-- during the last seven days. Lookup supports five different attributes:
-- time range (defined by a start time and end time), user name, event
-- name, resource type, and resource name. All attributes are optional. The
-- maximum number of attributes that can be specified in any one lookup
-- request are time range and one other attribute. The default number of
-- results returned is 10, with a maximum of 50 possible. The response
-- includes a token that you can use to get the next page of results. The
-- rate of lookup requests is limited to one per second per account.
--
-- Events that occurred during the selected time range will not be
-- available for lookup if CloudTrail logging was not enabled when the
-- events occurred.
--
-- <http://docs.aws.amazon.com/awscloudtrail/latest/APIReference/API_LookupEvents.html>
module Network.AWS.CloudTrail.LookupEvents
    (
    -- * Request
      LookupEvents
    -- ** Request constructor
    , lookupEvents
    -- ** Request lenses
    , leStartTime
    , leLookupAttributes
    , leNextToken
    , leEndTime
    , leMaxResults

    -- * Response
    , LookupEventsResponse
    -- ** Response constructor
    , lookupEventsResponse
    -- ** Response lenses
    , lerNextToken
    , lerEvents
    , lerStatus
    ) where

import           Network.AWS.CloudTrail.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | Contains a request for LookupEvents.
--
-- /See:/ 'lookupEvents' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'leStartTime'
--
-- * 'leLookupAttributes'
--
-- * 'leNextToken'
--
-- * 'leEndTime'
--
-- * 'leMaxResults'
data LookupEvents = LookupEvents'
    { _leStartTime        :: !(Maybe POSIX)
    , _leLookupAttributes :: !(Maybe [LookupAttribute])
    , _leNextToken        :: !(Maybe Text)
    , _leEndTime          :: !(Maybe POSIX)
    , _leMaxResults       :: !(Maybe Nat)
    } deriving (Eq,Read,Show)

-- | 'LookupEvents' smart constructor.
lookupEvents :: LookupEvents
lookupEvents =
    LookupEvents'
    { _leStartTime = Nothing
    , _leLookupAttributes = Nothing
    , _leNextToken = Nothing
    , _leEndTime = Nothing
    , _leMaxResults = Nothing
    }

-- | Specifies that only events that occur after or at the specified time are
-- returned. If the specified start time is after the specified end time,
-- an error is returned.
leStartTime :: Lens' LookupEvents (Maybe UTCTime)
leStartTime = lens _leStartTime (\ s a -> s{_leStartTime = a}) . mapping _Time;

-- | Contains a list of lookup attributes. Currently the list can contain
-- only one item.
leLookupAttributes :: Lens' LookupEvents [LookupAttribute]
leLookupAttributes = lens _leLookupAttributes (\ s a -> s{_leLookupAttributes = a}) . _Default;

-- | The token to use to get the next page of results after a previous API
-- call. This token must be passed in with the same parameters that were
-- specified in the the original call. For example, if the original call
-- specified an AttributeKey of \'Username\' with a value of \'root\', the
-- call with NextToken should include those same parameters.
leNextToken :: Lens' LookupEvents (Maybe Text)
leNextToken = lens _leNextToken (\ s a -> s{_leNextToken = a});

-- | Specifies that only events that occur before or at the specified time
-- are returned. If the specified end time is before the specified start
-- time, an error is returned.
leEndTime :: Lens' LookupEvents (Maybe UTCTime)
leEndTime = lens _leEndTime (\ s a -> s{_leEndTime = a}) . mapping _Time;

-- | The number of events to return. Possible values are 1 through 50. The
-- default is 10.
leMaxResults :: Lens' LookupEvents (Maybe Natural)
leMaxResults = lens _leMaxResults (\ s a -> s{_leMaxResults = a}) . mapping _Nat;

instance AWSRequest LookupEvents where
        type Sv LookupEvents = CloudTrail
        type Rs LookupEvents = LookupEventsResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 LookupEventsResponse' <$>
                   (x .?> "NextToken") <*> (x .?> "Events" .!@ mempty)
                     <*> (pure (fromEnum s)))

instance ToHeaders LookupEvents where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("com.amazonaws.cloudtrail.v20131101.CloudTrail_20131101.LookupEvents"
                       :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON LookupEvents where
        toJSON LookupEvents'{..}
          = object
              ["StartTime" .= _leStartTime,
               "LookupAttributes" .= _leLookupAttributes,
               "NextToken" .= _leNextToken, "EndTime" .= _leEndTime,
               "MaxResults" .= _leMaxResults]

instance ToPath LookupEvents where
        toPath = const "/"

instance ToQuery LookupEvents where
        toQuery = const mempty

-- | Contains a response to a LookupEvents action.
--
-- /See:/ 'lookupEventsResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lerNextToken'
--
-- * 'lerEvents'
--
-- * 'lerStatus'
data LookupEventsResponse = LookupEventsResponse'
    { _lerNextToken :: !(Maybe Text)
    , _lerEvents    :: !(Maybe [Event])
    , _lerStatus    :: !Int
    } deriving (Eq,Read,Show)

-- | 'LookupEventsResponse' smart constructor.
lookupEventsResponse :: Int -> LookupEventsResponse
lookupEventsResponse pStatus =
    LookupEventsResponse'
    { _lerNextToken = Nothing
    , _lerEvents = Nothing
    , _lerStatus = pStatus
    }

-- | The token to use to get the next page of results after a previous API
-- call. If the token does not appear, there are no more results to return.
-- The token must be passed in with the same parameters as the previous
-- call. For example, if the original call specified an AttributeKey of
-- \'Username\' with a value of \'root\', the call with NextToken should
-- include those same parameters.
lerNextToken :: Lens' LookupEventsResponse (Maybe Text)
lerNextToken = lens _lerNextToken (\ s a -> s{_lerNextToken = a});

-- | A list of events returned based on the lookup attributes specified and
-- the CloudTrail event. The events list is sorted by time. The most recent
-- event is listed first.
lerEvents :: Lens' LookupEventsResponse [Event]
lerEvents = lens _lerEvents (\ s a -> s{_lerEvents = a}) . _Default;

-- | FIXME: Undocumented member.
lerStatus :: Lens' LookupEventsResponse Int
lerStatus = lens _lerStatus (\ s a -> s{_lerStatus = a});
