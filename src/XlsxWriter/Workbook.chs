{-# LANGUAGE ForeignFunctionInterface #-}
-- | https://libxlsxwriter.github.io/workbook_8h.html
module XlsxWriter.Workbook where

#include "xlsxwriter/workbook.h"

import Data.Foldable
import Foreign
import Foreign.C
import Data.ByteString
{#import XlsxWriter.Common #}

{#context lib="xlsxwriter" #}

-- these structs are only used via opaque pointers, so we follow the
-- convention of giving naming priority to the generated pointer
-- rather than the struct value (i.e. Workbook, not WorkbookPtr)
data Workbook_struct
{#pointer *lxw_workbook as Workbook -> Workbook_struct #}

data WorkbookOptions = WorkbookOptions
  { woConstantMemory :: Bool,
    woTmpdir :: Maybe ByteString,
    woUseZip64 :: Bool
  }
  deriving (Show)

instance Storable WorkbookOptions where
  sizeOf _ = {#sizeof lxw_workbook_options #}
  alignment _ = {#alignof lxw_workbook_options #}
  peek p = do
    constMem <- (/= 0) <$> {#get lxw_workbook_options->constant_memory #} p
    tmpdir <-
      {#get lxw_workbook_options->tmpdir #} p
      >>= \ptr -> if ptr == nullPtr then pure Nothing else (Just <$> packCString ptr)
    useZip64 <- (/= 0) <$> {#get lxw_workbook_options->use_zip64 #} p
    pure $ WorkbookOptions constMem tmpdir useZip64
  poke p x = do
    {#set lxw_workbook_options.constant_memory #} p $
      if woConstantMemory x then 1 else 0
    for_ (woTmpdir x) $ \dir -> useAsCString dir $ \cstr ->
      {#set lxw_workbook_options.tmpdir #} p cstr
    {#set lxw_workbook_options.use_zip64 #} p $
      if woUseZip64 x then 1 else 0

{#pointer *lxw_workbook_options as WorkbookOptionsPtr -> WorkbookOptions #}

{#fun unsafe workbook_new
 { useAsCString* `ByteString' } -> `Workbook' #}

{#fun unsafe workbook_new_opt
  { useAsCString* `ByteString', with* `WorkbookOptions' } -> `Workbook' #}

{#fun unsafe workbook_close { id `Workbook' } -> `Error' #}
