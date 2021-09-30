{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/utility_8h.html
module XlsxWriter.Utility where

#include "xlsxwriter/utility.h"

import Foreign.C
{#import XlsxWriter.Common #}

{#context lib="xlsxwriter" #}

{#fun pure lxw_datetime_to_excel_datetime
  { id `DateTimePtr' } -> `Double' #}


{#fun pure lxw_strerror
   { `Error' } -> `String' #}

{-- TODO: figure out version mismatch; header file has this function

double lxw_datetime_to_excel_date_epoch(lxw_datetime *datetime, uint8_t date_1904);

but doxygen website has this function:

double lxw_unixtime_to_excel_date(int64_t unixtime)

--}
