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

data RowColOptions = RowColOptions
  { rcoHidden :: Bool,
    -- | must be in range 0 <= level <= 7. TODO: Proper datatype
    rcoLevel :: Int,
    rcoCollapsed :: Bool
  }
  deriving Show

instance Storable RowColOptions where
  sizeOf _ = {#sizeof lxw_row_col_options #}
  alignment _ = {#alignof lxw_row_col_options #}
  peek p = do
    hidden <- (/= 0) <$> {#get lxw_row_col_options->hidden #} p
    level <- fromIntegral <$> {#get lxw_row_col_options->level #} p
    collapsed <- (/= 0) <$> {#get lxw_row_col_options->collapsed #} p
    pure $ RowColOptions hidden level collapsed
  poke p x = do
    when (rcoHidden x) $
      {#set lxw_row_col_options.hidden #} p 1
    when (rcoLevel x /= 0) $
      {#set lxw_row_col_options.level #} p (fromIntegral $ rcoLevel x)
    when (rcoCollapsed x) $
      {#set lxw_row_col_options.collapsed #} p 1

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
