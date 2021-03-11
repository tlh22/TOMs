-- For Islington

SELECT
"BayLineTypes"."Description" AS "RestrictionDescription", "CPZ", COALESCE("TimePeriods"."Description", '') AS "TimePeriod",
COALESCE("LengthOfTime1"."Description", '') AS "MaxStay", COALESCE("LengthOfTime2"."Description", '') AS "NoReturnTime",
COALESCE("AdditionalConditionTypes"."Description", '') AS "AdditionalCondition", COUNT("BayLineTypes"."Description")

FROM
     ((((((toms."Bays" AS a
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods" ON a."TimePeriodID" is not distinct from "TimePeriods"."Code")
     LEFT JOIN "toms_lookups"."LengthOfTime" AS "LengthOfTime1" ON a."MaxStayID" is not distinct from "LengthOfTime1"."Code")
     LEFT JOIN "toms_lookups"."LengthOfTime" AS "LengthOfTime2" ON a."NoReturnID" is not distinct from "LengthOfTime2"."Code")
     LEFT JOIN "toms_lookups"."AdditionalConditionTypes" AS "AdditionalConditionTypes" ON a."AdditionalConditionID" is not distinct from "AdditionalConditionTypes"."Code")
)

GROUP BY "RestrictionDescription", "CPZ", "TimePeriod", "MaxStay", "NoReturnTime", "AdditionalCondition";

SELECT
"BayLineTypes"."Description" AS "RestrictionDescription", "CPZ",
 COALESCE("TimePeriods1"."Description", '') AS "NoWaitingTime",
 COALESCE("TimePeriods2"."Description", '') AS "NoLoadingTime",
COALESCE("AdditionalConditionTypes"."Description", '') AS "AdditionalCondition", COUNT("BayLineTypes"."Description")

FROM
     (((((toms."Lines" AS a
     LEFT JOIN "toms_lookups"."BayLineTypes" AS "BayLineTypes" ON a."RestrictionTypeID" is not distinct from "BayLineTypes"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods1" ON a."NoWaitingTimeID" is not distinct from "TimePeriods1"."Code")
     LEFT JOIN "toms_lookups"."TimePeriods" AS "TimePeriods2" ON a."NoLoadingTimeID" is not distinct from "TimePeriods2"."Code")
     LEFT JOIN "toms_lookups"."AdditionalConditionTypes" AS "AdditionalConditionTypes" ON a."AdditionalConditionID" is not distinct from "AdditionalConditionTypes"."Code")
)

GROUP BY "RestrictionDescription", "CPZ", "NoWaitingTime", "NoLoadingTime", "AdditionalCondition"