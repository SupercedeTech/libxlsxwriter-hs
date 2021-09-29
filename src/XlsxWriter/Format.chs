{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/format_8h.html
module XlsxWriter.Format where

#include <stdio.h>
#include "xlsxwriter/format.h"

import Foreign.C
import Data.ByteString

data Format_struct
{#pointer *lxw_format as Format -> Format_struct #}

{#fun unsafe format_set_hidden
  { id `Format' } -> `()' #}

{#fun unsafe format_set_unlocked
  { id `Format' } -> `()' #}

{#fun unsafe format_set_num_format
  { id `Format', useAsCString* `ByteString' } -> `()' #}

{#fun unsafe format_set_num_format_index
  { id `Format', `Int' } -> `()' #}
