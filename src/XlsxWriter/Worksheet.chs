{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/worksheet_8h.html
module XlsxWriter.Worksheet where

#include "xlsxwriter/worksheet.h"

import Foreign
import Foreign.C
import Data.ByteString
import Control.Monad (when)
{#import XlsxWriter.Common #}
{#import XlsxWriter.Format #}

{#context lib="xlsxwriter" #}

data Worksheet_struct
{#pointer *lxw_worksheet as Worksheet -> Worksheet_struct #}

defColWidth :: Double
defColWidth =
  let double = id -- workaround the #define having a C cast: `(double)`
  in {#const LXW_DEF_COL_WIDTH #}

defRowHeight :: Double
defRowHeight =
  let double = id -- workaround the #define having a C cast: `(double)`
  in {#const LXW_DEF_ROW_HEIGHT #}

data RowColOptions = RowColOptions
  { rcoHidden :: Bool,
    -- | must be in range 0 <= level <= 7. TODO: Proper datatype
    rcoLevel :: Int,
    rcoCollapsed :: Bool
  }
  deriving Show

instance Storable RowColOptions where
  sizeOf _ = 3 -- c2hs outputs 4, but it should be 3: {#sizeof lxw_row_col_options #}
  alignment _ = 1 -- c2hs outputs 1, but I don't trust it anymore {#alignof lxw_row_col_options #}
  peek p = do
    hidden <- (/= 0) <$> {#get lxw_row_col_options->hidden #} p
    level <- fromIntegral <$> {#get lxw_row_col_options->level #} p
    collapsed <- (/= 0) <$> {#get lxw_row_col_options->collapsed #} p
    pure $ RowColOptions hidden level collapsed
  poke p x = do
    {#set lxw_row_col_options.hidden #} p $ if rcoHidden x then 1 else 0
    {#set lxw_row_col_options.level #} p (fromIntegral $ rcoLevel x)
    {#set lxw_row_col_options.collapsed #} p $ if rcoCollapsed x then 1 else 0

{#pointer *lxw_row_col_options as RowColOptionsPtr -> RowColOptions #}

{#fun unsafe worksheet_write_number
  { id `Worksheet', id `Row', id `Col', `Double', id `Format' } -> `Error' #}

{#fun unsafe worksheet_write_string
  { id `Worksheet', id `Row', id `Col', useAsCString* `ByteString', id `Format' } -> `Error' #}

{#fun unsafe worksheet_write_datetime
  { id `Worksheet', id `Row', id `Col', with* `DateTime', id `Format' } -> `Error' #}

{#fun unsafe worksheet_write_boolean
  { id `Worksheet', id `Row', id `Col', `Int', id `Format' } -> `Error' #}

{#fun unsafe worksheet_write_blank
  { id `Worksheet', id `Row', id `Col', id `Format' } -> `Error' #}

{#fun unsafe worksheet_write_comment
  { id `Worksheet', id `Row', id `Col', useAsCString* `ByteString' } -> `Error' #}

{#fun unsafe worksheet_set_row
  { id `Worksheet', id `Row', `Double', id `Format' } -> `Error' #}

{#fun unsafe worksheet_set_row_opt
  { id `Worksheet', id `Row', `Double', id `Format', with* `RowColOptions' } -> `Error' #}

{#fun unsafe worksheet_set_column
  { id `Worksheet', id `Col', id `Col', `Double', id `Format' } -> `Error' #}

{#fun unsafe worksheet_set_column_opt
  { id `Worksheet', id `Col', id `Col', `Double', id `Format', with* `RowColOptions' } -> `Error' #}

{#fun unsafe worksheet_activate { id `Worksheet' } -> `()' #}
{#fun unsafe worksheet_select { id `Worksheet' } -> `()' #}
{#fun unsafe worksheet_hide { id `Worksheet' } -> `()' #}
{#fun unsafe worksheet_set_first_sheet { id `Worksheet' } -> `()' #}
{#fun unsafe worksheet_set_landscape { id `Worksheet' } -> `()' #}
{#fun unsafe worksheet_show_comments { id `Worksheet' } -> `()' #}
